#!/usr/bin/env python3
"""
AI Analysis Script for Video Production

Analyzes transcript to generate:
1. Visual recommendations (infographics, b-roll, screen captures)
2. Lower third suggestions
3. Chapter markers
4. Filler words to cut

Usage:
    ./tools/analyze.py <transcript.json> [--api anthropic|openai|local]
    ./tools/analyze.py 03-project/ai-analysis/video.json

Requires:
    - anthropic (pip install anthropic) for Claude API
    - openai (pip install openai) for OpenAI API
    - ollama running locally for local mode
"""

import json
import sys
import os
import argparse
from pathlib import Path
from datetime import timedelta

# API clients (imported conditionally)
anthropic_client = None
openai_client = None


def format_timestamp(seconds: float) -> str:
    """Convert seconds to MM:SS or HH:MM:SS format."""
    td = timedelta(seconds=seconds)
    total_seconds = int(td.total_seconds())
    hours, remainder = divmod(total_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)

    if hours > 0:
        return f"{hours}:{minutes:02d}:{seconds:02d}"
    return f"{minutes}:{seconds:02d}"


def load_transcript(json_path: str) -> dict:
    """Load Whisper JSON transcript."""
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)


def extract_text_with_timestamps(transcript: dict) -> list:
    """Extract segments with timestamps from Whisper output."""
    segments = []

    if 'segments' in transcript:
        for seg in transcript['segments']:
            segments.append({
                'start': seg['start'],
                'end': seg['end'],
                'text': seg['text'].strip(),
                'words': seg.get('words', [])
            })

    return segments


def build_analysis_prompt(segments: list, content_type: str = "coding-tutorial") -> str:
    """Build prompt for AI analysis."""

    # Format transcript for analysis
    transcript_text = "\n".join([
        f"[{format_timestamp(s['start'])} - {format_timestamp(s['end'])}] {s['text']}"
        for s in segments
    ])

    prompt = f"""Analyze this video transcript and provide production recommendations.

Content Type: {content_type}

TRANSCRIPT:
{transcript_text}

---

Provide analysis in the following JSON format:

{{
    "summary": "Brief 2-3 sentence summary of the video content",

    "chapters": [
        {{"timestamp": "0:00", "title": "Introduction"}},
        {{"timestamp": "2:30", "title": "Section Title"}}
    ],

    "visual_recommendations": [
        {{
            "timestamp_start": "0:45",
            "timestamp_end": "1:20",
            "type": "INFOGRAPHIC|SCREEN|B_ROLL|GFX|LOWER_THIRD",
            "description": "What visual is needed",
            "reason": "Why this visual helps"
        }}
    ],

    "lower_thirds": [
        {{
            "timestamp": "0:15",
            "name": "Text to display",
            "subtitle": "Secondary text (optional)",
            "duration": 4
        }}
    ],

    "filler_words": [
        {{
            "timestamp_start": "1:23",
            "timestamp_end": "1:25",
            "text": "um, uh",
            "action": "CUT"
        }}
    ],

    "repetitions": [
        {{
            "timestamp_start": "3:10",
            "timestamp_end": "3:18",
            "text": "repeated phrase",
            "action": "CUT"
        }}
    ],

    "dead_air": [
        {{
            "timestamp_start": "5:00",
            "timestamp_end": "5:08",
            "action": "CUT|SPEEDUP|B_ROLL"
        }}
    ],

    "thumbnail_suggestions": [
        {{
            "timestamp": "4:30",
            "reason": "Good expression/visual moment"
        }}
    ],

    "title_suggestions": [
        "Title Option 1",
        "Title Option 2",
        "Title Option 3"
    ],

    "tags": ["tag1", "tag2", "tag3"]
}}

IMPORTANT:
- Use actual timestamps from the transcript
- For coding tutorials, identify moments needing screen capture
- Mark ALL filler words (um, uh, eh, jadi, ya kan, gitu, dll)
- Identify false starts and repetitions
- Suggest B-roll for long explanations without visual change
- Lower thirds for technical terms, names, URLs mentioned
- Be specific about what infographics/diagrams are needed
"""

    return prompt


def analyze_with_anthropic(prompt: str) -> dict:
    """Call Anthropic Claude API."""
    global anthropic_client

    if anthropic_client is None:
        import anthropic
        anthropic_client = anthropic.Anthropic()

    message = anthropic_client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )

    # Extract JSON from response
    response_text = message.content[0].text

    # Find JSON in response
    try:
        # Try to parse directly
        return json.loads(response_text)
    except json.JSONDecodeError:
        # Try to extract JSON from markdown code block
        import re
        json_match = re.search(r'```(?:json)?\s*([\s\S]*?)\s*```', response_text)
        if json_match:
            return json.loads(json_match.group(1))
        raise ValueError("Could not parse JSON from response")


def analyze_with_openai(prompt: str) -> dict:
    """Call OpenAI API."""
    global openai_client

    if openai_client is None:
        import openai
        openai_client = openai.OpenAI()

    response = openai_client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "user", "content": prompt}
        ],
        response_format={"type": "json_object"}
    )

    return json.loads(response.choices[0].message.content)


def analyze_with_ollama(prompt: str) -> dict:
    """Call local Ollama API."""
    import requests

    response = requests.post(
        "http://localhost:11434/api/generate",
        json={
            "model": "llama3.2",
            "prompt": prompt,
            "stream": False,
            "format": "json"
        },
        timeout=300
    )

    response.raise_for_status()
    result = response.json()

    return json.loads(result['response'])


def analyze_with_gemini(prompt: str) -> dict:
    """Call Google Gemini via gemini-cli."""
    import subprocess
    import tempfile

    # Write prompt to temp file
    with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as f:
        f.write(prompt)
        prompt_file = f.name

    try:
        # Call gemini-cli
        result = subprocess.run(
            ['gemini', '-p', prompt_file],
            capture_output=True,
            text=True,
            timeout=300
        )

        if result.returncode != 0:
            raise RuntimeError(f"gemini-cli failed: {result.stderr}")

        response_text = result.stdout

        # Extract JSON from response
        try:
            return json.loads(response_text)
        except json.JSONDecodeError:
            import re
            json_match = re.search(r'```(?:json)?\s*([\s\S]*?)\s*```', response_text)
            if json_match:
                return json.loads(json_match.group(1))
            raise ValueError("Could not parse JSON from gemini response")

    finally:
        os.unlink(prompt_file)


def save_prompt_for_manual_use(prompt: str, output_dir: Path, basename: str):
    """Save prompt to file for manual use with any AI."""
    prompt_path = output_dir / f"{basename}_analysis_prompt.md"

    content = f"""# Video Analysis Prompt

Copy this entire prompt and paste into your preferred AI:
- Claude Code (via this CLI)
- Claude.ai
- ChatGPT
- Gemini
- Any other LLM

---

{prompt}

---

## After getting the response:

1. Copy the JSON response
2. Save it to: `{output_dir}/analysis.json`
3. Run: `./tools/generate-outputs.py {output_dir}/analysis.json`

Or paste the JSON response back to Claude Code and ask to generate the output files.
"""

    with open(prompt_path, 'w') as f:
        f.write(content)

    print(f"\nPrompt saved to: {prompt_path}")
    print("\nYou can now:")
    print("  1. Open the prompt file and copy to any AI")
    print("  2. Or ask Claude Code: 'analyze the transcript at <path>'")

    return prompt_path


def generate_outputs(analysis: dict, output_dir: Path, basename: str):
    """Generate output files from analysis."""

    # 1. Visual recommendations markdown
    visual_md = f"# Visual Recommendations: {basename}\n\n"
    visual_md += f"## Summary\n\n{analysis.get('summary', 'N/A')}\n\n"
    visual_md += "## Visual Elements Needed\n\n"
    visual_md += "| Timestamp | Type | Description | Reason |\n"
    visual_md += "|-----------|------|-------------|--------|\n"

    for v in analysis.get('visual_recommendations', []):
        visual_md += f"| {v['timestamp_start']}-{v['timestamp_end']} | {v['type']} | {v['description']} | {v['reason']} |\n"

    with open(output_dir / "visual-recommendations.md", 'w') as f:
        f.write(visual_md)

    # 2. Lower thirds CSV
    lower_csv = "timestamp,name,subtitle,duration\n"
    for lt in analysis.get('lower_thirds', []):
        lower_csv += f"{lt['timestamp']},\"{lt['name']}\",\"{lt.get('subtitle', '')}\",{lt.get('duration', 4)}\n"

    with open(output_dir / "lower-thirds.csv", 'w') as f:
        f.write(lower_csv)

    # 3. Chapters for YouTube
    chapters_md = "# Chapters\n\n"
    chapters_md += "Copy this to YouTube description:\n\n```\n"
    for ch in analysis.get('chapters', []):
        chapters_md += f"{ch['timestamp']} {ch['title']}\n"
    chapters_md += "```\n"

    with open(output_dir / "chapters.md", 'w') as f:
        f.write(chapters_md)

    # 4. Cut list (filler words, repetitions, dead air)
    cuts_md = "# Suggested Cuts\n\n"

    cuts_md += "## Filler Words\n\n"
    cuts_md += "| Start | End | Text | Action |\n"
    cuts_md += "|-------|-----|------|--------|\n"
    for fw in analysis.get('filler_words', []):
        cuts_md += f"| {fw['timestamp_start']} | {fw['timestamp_end']} | {fw['text']} | {fw['action']} |\n"

    cuts_md += "\n## Repetitions\n\n"
    cuts_md += "| Start | End | Text | Action |\n"
    cuts_md += "|-------|-----|------|--------|\n"
    for rep in analysis.get('repetitions', []):
        cuts_md += f"| {rep['timestamp_start']} | {rep['timestamp_end']} | {rep['text']} | {rep['action']} |\n"

    cuts_md += "\n## Dead Air\n\n"
    cuts_md += "| Start | End | Action |\n"
    cuts_md += "|-------|-----|--------|\n"
    for da in analysis.get('dead_air', []):
        cuts_md += f"| {da['timestamp_start']} | {da['timestamp_end']} | {da['action']} |\n"

    with open(output_dir / "cuts.md", 'w') as f:
        f.write(cuts_md)

    # 5. SEO suggestions
    seo_md = "# SEO Suggestions\n\n"
    seo_md += "## Title Options\n\n"
    for i, title in enumerate(analysis.get('title_suggestions', []), 1):
        seo_md += f"{i}. {title}\n"

    seo_md += "\n## Tags\n\n"
    seo_md += ", ".join(analysis.get('tags', []))

    seo_md += "\n\n## Thumbnail Moments\n\n"
    for th in analysis.get('thumbnail_suggestions', []):
        seo_md += f"- {th['timestamp']}: {th['reason']}\n"

    with open(output_dir / "seo.md", 'w') as f:
        f.write(seo_md)

    # 6. Full analysis JSON
    with open(output_dir / "analysis.json", 'w') as f:
        json.dump(analysis, f, indent=2, ensure_ascii=False)

    print(f"\nOutput files generated in {output_dir}/:")
    print("  - visual-recommendations.md")
    print("  - lower-thirds.csv")
    print("  - chapters.md")
    print("  - cuts.md")
    print("  - seo.md")
    print("  - analysis.json")


def main():
    parser = argparse.ArgumentParser(description="AI analysis of video transcript")
    parser.add_argument("transcript", help="Path to Whisper JSON transcript")
    parser.add_argument("--api", choices=["anthropic", "openai", "gemini", "local", "prompt"],
                        default="prompt", help="API to use (default: prompt for manual use)")
    parser.add_argument("--content-type", default="coding-tutorial",
                        choices=["coding-tutorial", "vlog", "podcast", "shorts"],
                        help="Content type for context")
    parser.add_argument("--output-dir", help="Output directory (default: same as transcript)")
    parser.add_argument("--from-json", help="Generate outputs from existing analysis.json")

    args = parser.parse_args()

    # If generating from existing JSON
    if args.from_json:
        json_path = Path(args.from_json)
        if not json_path.exists():
            print(f"Error: JSON file not found: {json_path}")
            sys.exit(1)

        output_dir = Path(args.output_dir) if args.output_dir else json_path.parent
        basename = json_path.stem.replace('_analysis', '').replace('analysis', 'video')

        print(f"Loading analysis from: {json_path}")
        with open(json_path, 'r') as f:
            analysis = json.load(f)

        print("Generating output files...")
        generate_outputs(analysis, output_dir, basename)
        print("\nOutput files generated!")
        return

    transcript_path = Path(args.transcript)

    if not transcript_path.exists():
        print(f"Error: Transcript not found: {transcript_path}")
        sys.exit(1)

    output_dir = Path(args.output_dir) if args.output_dir else transcript_path.parent
    output_dir.mkdir(parents=True, exist_ok=True)

    basename = transcript_path.stem

    print(f"Loading transcript: {transcript_path}")
    transcript = load_transcript(transcript_path)
    segments = extract_text_with_timestamps(transcript)

    print(f"Found {len(segments)} segments")
    print(f"Building analysis prompt for content type: {args.content_type}")

    prompt = build_analysis_prompt(segments, args.content_type)

    # Prompt-only mode (default) - save prompt for manual use
    if args.api == "prompt":
        save_prompt_for_manual_use(prompt, output_dir, basename)
        return

    print(f"Analyzing with {args.api}...")

    if args.api == "anthropic":
        analysis = analyze_with_anthropic(prompt)
    elif args.api == "openai":
        analysis = analyze_with_openai(prompt)
    elif args.api == "gemini":
        analysis = analyze_with_gemini(prompt)
    else:  # local/ollama
        analysis = analyze_with_ollama(prompt)

    print("Generating output files...")
    generate_outputs(analysis, output_dir, basename)

    print("\nAnalysis complete!")
    print(f"\nNext step: Review recommendations and run autocut:")
    print(f"  ./tools/autocut.py {transcript_path} --cuts {output_dir}/analysis.json")


if __name__ == "__main__":
    main()
