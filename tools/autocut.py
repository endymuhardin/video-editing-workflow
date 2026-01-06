#!/usr/bin/env python3
"""
Transcript-Aware Auto-Cut Script

Generates EDL/XML for DaVinci Resolve based on:
1. AI analysis cuts (filler words, repetitions, dead air)
2. Silence detection
3. Manual cut list

Usage:
    ./tools/autocut.py <video_file> --transcript <transcript.json> --analysis <analysis.json>
    ./tools/autocut.py 01-raw/camera/video.mov --transcript 03-project/ai-analysis/video.json

Output:
    - EDL file for DaVinci Resolve import
    - XML file (alternative format)
    - Cut report markdown
"""

import json
import sys
import argparse
import subprocess
from pathlib import Path
from dataclasses import dataclass
from typing import List, Optional
import re


@dataclass
class CutSegment:
    """Represents a segment to keep or cut."""
    start: float
    end: float
    keep: bool
    reason: str = ""


@dataclass
class EditDecision:
    """Represents an edit decision for EDL."""
    record_in: float
    record_out: float
    source_in: float
    source_out: float


def timestamp_to_seconds(ts: str) -> float:
    """Convert MM:SS or HH:MM:SS to seconds."""
    parts = ts.split(':')
    if len(parts) == 2:
        return int(parts[0]) * 60 + float(parts[1])
    elif len(parts) == 3:
        return int(parts[0]) * 3600 + int(parts[1]) * 60 + float(parts[2])
    return float(ts)


def seconds_to_timecode(seconds: float, fps: float = 30.0) -> str:
    """Convert seconds to SMPTE timecode HH:MM:SS:FF."""
    total_frames = int(seconds * fps)
    frames = total_frames % int(fps)
    total_seconds = total_frames // int(fps)
    ss = total_seconds % 60
    total_minutes = total_seconds // 60
    mm = total_minutes % 60
    hh = total_minutes // 60

    return f"{hh:02d}:{mm:02d}:{ss:02d}:{frames:02d}"


def get_video_duration(video_path: str) -> float:
    """Get video duration using ffprobe."""
    result = subprocess.run(
        [
            'ffprobe', '-v', 'error',
            '-show_entries', 'format=duration',
            '-of', 'default=noprint_wrappers=1:nokey=1',
            video_path
        ],
        capture_output=True,
        text=True
    )
    return float(result.stdout.strip())


def load_analysis_cuts(analysis_path: str) -> List[CutSegment]:
    """Load cut segments from AI analysis."""
    cuts = []

    with open(analysis_path, 'r') as f:
        analysis = json.load(f)

    # Filler words
    for fw in analysis.get('filler_words', []):
        cuts.append(CutSegment(
            start=timestamp_to_seconds(fw['timestamp_start']),
            end=timestamp_to_seconds(fw['timestamp_end']),
            keep=False,
            reason=f"Filler: {fw.get('text', '')}"
        ))

    # Repetitions
    for rep in analysis.get('repetitions', []):
        cuts.append(CutSegment(
            start=timestamp_to_seconds(rep['timestamp_start']),
            end=timestamp_to_seconds(rep['timestamp_end']),
            keep=False,
            reason=f"Repetition: {rep.get('text', '')}"
        ))

    # Dead air (only if action is CUT)
    for da in analysis.get('dead_air', []):
        if da.get('action') == 'CUT':
            cuts.append(CutSegment(
                start=timestamp_to_seconds(da['timestamp_start']),
                end=timestamp_to_seconds(da['timestamp_end']),
                keep=False,
                reason="Dead air"
            ))

    return cuts


def load_transcript_silences(transcript_path: str, threshold: float = 0.5) -> List[CutSegment]:
    """Detect silences from transcript gaps."""
    cuts = []

    with open(transcript_path, 'r') as f:
        transcript = json.load(f)

    segments = transcript.get('segments', [])

    for i in range(len(segments) - 1):
        current_end = segments[i]['end']
        next_start = segments[i + 1]['start']
        gap = next_start - current_end

        if gap > threshold:
            # Keep a small buffer
            buffer = 0.1
            cuts.append(CutSegment(
                start=current_end + buffer,
                end=next_start - buffer,
                keep=False,
                reason=f"Silence ({gap:.1f}s)"
            ))

    return cuts


def merge_cut_segments(cuts: List[CutSegment], video_duration: float) -> List[CutSegment]:
    """Merge overlapping cuts and create keep segments."""
    if not cuts:
        return [CutSegment(start=0, end=video_duration, keep=True)]

    # Sort cuts by start time
    cuts = sorted(cuts, key=lambda x: x.start)

    # Merge overlapping cuts
    merged_cuts = []
    current = cuts[0]

    for next_cut in cuts[1:]:
        if next_cut.start <= current.end + 0.1:  # Small overlap tolerance
            # Merge
            current = CutSegment(
                start=current.start,
                end=max(current.end, next_cut.end),
                keep=False,
                reason=f"{current.reason}; {next_cut.reason}"
            )
        else:
            merged_cuts.append(current)
            current = next_cut

    merged_cuts.append(current)

    # Create keep segments between cuts
    result = []
    current_time = 0.0

    for cut in merged_cuts:
        if cut.start > current_time:
            result.append(CutSegment(
                start=current_time,
                end=cut.start,
                keep=True
            ))
        result.append(cut)
        current_time = cut.end

    if current_time < video_duration:
        result.append(CutSegment(
            start=current_time,
            end=video_duration,
            keep=True
        ))

    return result


def generate_edl(segments: List[CutSegment], video_name: str, fps: float = 30.0) -> str:
    """Generate EDL (Edit Decision List) file content."""
    edl_lines = [
        "TITLE: Auto-Generated Edit",
        f"FCM: NON-DROP FRAME",
        ""
    ]

    edit_num = 1
    record_time = 0.0

    for seg in segments:
        if seg.keep:
            duration = seg.end - seg.start
            source_in = seconds_to_timecode(seg.start, fps)
            source_out = seconds_to_timecode(seg.end, fps)
            record_in = seconds_to_timecode(record_time, fps)
            record_out = seconds_to_timecode(record_time + duration, fps)

            edl_lines.append(
                f"{edit_num:03d}  AX       V     C        "
                f"{source_in} {source_out} {record_in} {record_out}"
            )
            edl_lines.append(f"* FROM CLIP NAME: {video_name}")
            edl_lines.append("")

            edit_num += 1
            record_time += duration

    return "\n".join(edl_lines)


def generate_fcpxml(segments: List[CutSegment], video_path: str, fps: float = 30.0) -> str:
    """Generate Final Cut Pro XML."""
    video_name = Path(video_path).name

    # Calculate total duration of kept segments
    total_duration = sum(seg.end - seg.start for seg in segments if seg.keep)

    xml_clips = []
    timeline_offset = 0.0

    for seg in segments:
        if seg.keep:
            duration = seg.end - seg.start
            xml_clips.append(f'''
            <clip name="{video_name}" offset="{int(timeline_offset * fps * 100)}/3000s" duration="{int(duration * fps * 100)}/3000s" start="{int(seg.start * fps * 100)}/3000s">
                <video ref="r1" offset="0s" duration="{int(duration * fps * 100)}/3000s" start="{int(seg.start * fps * 100)}/3000s"/>
            </clip>''')
            timeline_offset += duration

    xml_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fcpxml>
<fcpxml version="1.9">
    <resources>
        <format id="r0" name="FFVideoFormat1080p30" frameDuration="100/3000s" width="1920" height="1080"/>
        <asset id="r1" name="{video_name}" src="file://{video_path}" start="0s" hasVideo="1" hasAudio="1"/>
    </resources>
    <library>
        <event name="Auto-Edit">
            <project name="Auto-Generated Edit">
                <sequence format="r0" duration="{int(total_duration * fps * 100)}/3000s">
                    <spine>
                        {"".join(xml_clips)}
                    </spine>
                </sequence>
            </project>
        </event>
    </library>
</fcpxml>'''

    return xml_content


def generate_davinci_xml(segments: List[CutSegment], video_path: str, fps: float = 30.0) -> str:
    """Generate DaVinci Resolve compatible XML (simplified FCPXML)."""
    # DaVinci can import FCPXML
    return generate_fcpxml(segments, video_path, fps)


def generate_report(segments: List[CutSegment], video_duration: float) -> str:
    """Generate markdown report of edits."""
    kept_duration = sum(seg.end - seg.start for seg in segments if seg.keep)
    cut_duration = video_duration - kept_duration
    cut_count = len([s for s in segments if not s.keep])

    report = f"""# Auto-Cut Report

## Summary

| Metric | Value |
|--------|-------|
| Original Duration | {video_duration:.1f}s ({video_duration/60:.1f} min) |
| Final Duration | {kept_duration:.1f}s ({kept_duration/60:.1f} min) |
| Cut Duration | {cut_duration:.1f}s ({cut_duration/60:.1f} min) |
| Time Saved | {cut_duration/video_duration*100:.1f}% |
| Number of Cuts | {cut_count} |

## Cut Details

| Start | End | Duration | Reason |
|-------|-----|----------|--------|
"""

    for seg in segments:
        if not seg.keep:
            duration = seg.end - seg.start
            report += f"| {seg.start:.1f}s | {seg.end:.1f}s | {duration:.1f}s | {seg.reason} |\n"

    report += f"""
## Kept Segments

| # | Start | End | Duration |
|---|-------|-----|----------|
"""

    for i, seg in enumerate([s for s in segments if s.keep], 1):
        duration = seg.end - seg.start
        report += f"| {i} | {seg.start:.1f}s | {seg.end:.1f}s | {duration:.1f}s |\n"

    return report


def main():
    parser = argparse.ArgumentParser(description="Transcript-aware auto-cut")
    parser.add_argument("video", help="Path to video file")
    parser.add_argument("--transcript", "-t", help="Path to Whisper JSON transcript")
    parser.add_argument("--analysis", "-a", help="Path to AI analysis JSON")
    parser.add_argument("--output-dir", "-o", help="Output directory")
    parser.add_argument("--silence-threshold", type=float, default=0.5,
                        help="Minimum silence duration to cut (seconds)")
    parser.add_argument("--fps", type=float, default=30.0, help="Video frame rate")
    parser.add_argument("--format", choices=["edl", "xml", "both"], default="both",
                        help="Output format")

    args = parser.parse_args()

    video_path = Path(args.video).resolve()

    if not video_path.exists():
        print(f"Error: Video not found: {video_path}")
        sys.exit(1)

    output_dir = Path(args.output_dir) if args.output_dir else video_path.parent / "auto-edit"
    output_dir.mkdir(parents=True, exist_ok=True)

    basename = video_path.stem

    print(f"Video: {video_path}")
    print(f"Getting video duration...")

    video_duration = get_video_duration(str(video_path))
    print(f"Duration: {video_duration:.1f}s ({video_duration/60:.1f} min)")

    all_cuts = []

    # Load AI analysis cuts
    if args.analysis:
        print(f"Loading AI analysis cuts: {args.analysis}")
        analysis_cuts = load_analysis_cuts(args.analysis)
        print(f"  Found {len(analysis_cuts)} AI-suggested cuts")
        all_cuts.extend(analysis_cuts)

    # Load silence cuts from transcript
    if args.transcript:
        print(f"Detecting silences from transcript: {args.transcript}")
        silence_cuts = load_transcript_silences(args.transcript, args.silence_threshold)
        print(f"  Found {len(silence_cuts)} silence gaps")
        all_cuts.extend(silence_cuts)

    if not all_cuts:
        print("No cuts found. Using silence detection fallback...")
        # Could add audio-based silence detection here
        print("Warning: No transcript or analysis provided. Output will be unchanged.")
        all_cuts = []

    print(f"\nTotal cuts to process: {len(all_cuts)}")

    # Merge and create final segment list
    segments = merge_cut_segments(all_cuts, video_duration)

    kept_segments = [s for s in segments if s.keep]
    cut_segments = [s for s in segments if not s.keep]

    print(f"Kept segments: {len(kept_segments)}")
    print(f"Cut segments: {len(cut_segments)}")

    # Generate outputs
    if args.format in ["edl", "both"]:
        edl_content = generate_edl(segments, video_path.name, args.fps)
        edl_path = output_dir / f"{basename}.edl"
        with open(edl_path, 'w') as f:
            f.write(edl_content)
        print(f"\nEDL: {edl_path}")

    if args.format in ["xml", "both"]:
        xml_content = generate_davinci_xml(segments, str(video_path), args.fps)
        xml_path = output_dir / f"{basename}.fcpxml"
        with open(xml_path, 'w') as f:
            f.write(xml_content)
        print(f"XML: {xml_path}")

    # Generate report
    report = generate_report(segments, video_duration)
    report_path = output_dir / f"{basename}_cuts_report.md"
    with open(report_path, 'w') as f:
        f.write(report)
    print(f"Report: {report_path}")

    # Summary
    kept_duration = sum(seg.end - seg.start for seg in segments if seg.keep)
    print(f"\n--- Summary ---")
    print(f"Original: {video_duration:.1f}s → Final: {kept_duration:.1f}s")
    print(f"Saved: {video_duration - kept_duration:.1f}s ({(video_duration - kept_duration)/video_duration*100:.1f}%)")
    print(f"\nNext step: Import {basename}.edl or {basename}.fcpxml into DaVinci Resolve")


if __name__ == "__main__":
    main()
