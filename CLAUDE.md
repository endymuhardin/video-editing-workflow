# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Video editing workflow system for programming tutorial videos on MacBook Pro M1. Complete pipeline from recording (OBS) through auto-editing to multi-platform export (YouTube, Instagram Reels, TikTok).

## Commands

### Project Creation
```bash
./new-project.sh PROJECT_CODE [CONTENT_TYPE] "Description"

# Interactive mode (prompts for content type):
./new-project.sh SPRING01

# Direct mode:
./new-project.sh SPRING01 coding-tutorial "Spring Boot Tutorial"
./new-project.sh BALI01 vlog "Bali Trip Day 1"
./new-project.sh EP42 podcast "Interview with Dr. Smith"
./new-project.sh TIP01 shorts "Quick Git Tip"
```

### AI Processing Pipeline (Recommended)
```bash
cd projects/YYYY-MM-DD_PROJECT_CODE

# Full pipeline: transcribe → analyze → autocut
./tools/process.sh 01-raw/camera/video.mov coding-tutorial

# Individual steps:
./tools/transcribe.sh 01-raw/camera/video.mov           # Whisper transcription
./tools/analyze.py 03-project/ai-analysis/video.json    # AI visual recommendations
./tools/autocut.py 01-raw/camera/video.mov \            # Generate EDL/XML
    --transcript 03-project/ai-analysis/video.json \
    --analysis 03-project/ai-analysis/analysis.json
```

Output in `03-project/ai-analysis/`:
- `video.srt` - Subtitles
- `visual-recommendations.md` - Graphics/b-roll needed
- `lower-thirds.csv` - Lower third timings
- `chapters.md` - YouTube chapters
- `cuts.md` - Filler words, repetitions
- `seo.md` - Title/tags suggestions
- `video.edl` / `video.fcpxml` - Import to DaVinci

### Legacy Auto-Editor (Silence Only)
```bash
./auto-edit.sh                              # Silence removal → DaVinci XML
./auto-edit.sh --preview                    # Preview cuts only
```

### Python Environment
```bash
source venv/bin/activate
pip install openai-whisper anthropic       # For AI pipeline
pip install auto-editor                     # For legacy auto-edit
```

## Architecture

### Directory Structure
```
template/
├── 00-planning/     # Pre-production (script/, outline/, shotlist/, demo-code/, prompts/)
├── 01-raw/          # Immutable source (camera/, screen/, audio/)
├── 02-proxy/        # Temp cache/proxies (gitignored)
├── 03-project/      # DaVinci .drp + ai-analysis/ output
│   └── ai-analysis/ # Transcripts, recommendations, EDL/XML
├── 04-assets/       # Fusion templates (bumpers/, lower-thirds/, thumbnails/)
├── 05-exports/      # Final renders (master/, shorts/)
├── 06-captions/     # SRT/VTT subtitles
└── 07-archive/      # Completed archives (gitignored)

tools/               # AI processing scripts (repo root)
├── process.sh       # Full pipeline
├── transcribe.sh    # Whisper transcription
├── analyze.py       # AI visual recommendations
└── autocut.py       # Transcript-aware cutting
```

### Footage Types (for shotlist planning)
- **TH** = Talking Head (camera only, OBS F1)
- **SC** = Screen Capture (OBS F3)
- **TH+SC** = Picture-in-picture (OBS F2)
- **BR** = B-Roll (cutaways, close-ups)
- **GFX** = Graphics/Infographic

### Processing Pipeline
```
Plan → Record → Transcribe → AI Analyze → Auto-cut → DaVinci Edit → Export → Publish
  │       │          │            │           │            │           │         │
  ▼       ▼          ▼            ▼           ▼            ▼           ▼         ▼
script  video    transcript   visual recs   EDL/XML    + effects    render   metadata
outline          + .srt       cuts.md                  + bumpers             title/desc
shotlist                      chapters.md              + lower 3rds          chapters
                              lower-thirds.csv                               social
```

**Automated steps** (via `./tools/process.sh`): Transcribe → AI Analyze → Auto-cut

See `AI-WORKFLOW.md` for detailed workflow and prompts.

### Hardware Setup
```
Nikon ZFC (HDMI) → Cam Link 4K → MacBook M1 USB-C
Hollyland Lark M2 (USB-C receiver, needs 15cm extension cable)
```

## Naming Convention
```
[DATE]_[PROJECT-CODE]_[TYPE]_[SEQUENCE].[ext]
Example: 2026-01-06_SPRING01_CAM_001.mov
```

## Content Types

Assets organized by content type in `04-assets/bumpers/`, `lower-thirds/`, `thumbnails/`:

| Type | Bumper | Lower Third | Thumbnail | Style |
|------|--------|-------------|-----------|-------|
| coding-tutorial | 3-4 sec | 3-5 sec | Code/logo focus | Dark, professional |
| vlog | 2-3 sec | 2-4 sec | Expressive face | Warm, casual |
| podcast | 5-8 sec | 5-8 sec | Host + guest | Branded, broadcast |
| shorts/* | 1-2 sec | 2-3 sec | Action frame | Vertical 9:16, bold |

Shorts subfolders: `youtube/`, `instagram/`, `facebook/`

## ArtiVisi Brand Palette

```
Primary:    #2e3192 (Deep Blue)
Secondary:  #58c034 (Green)
Text:       #1a1a2e (Dark)
Fonts:      Inter, Fira Code (mono)
```

Matches OBS overlay: `/Users/endymuhardin/workspace/video-editing/live-stream-overlay`

## Export Targets
- **Master:** 1920x1080, H.265, 25Mbps
- **YouTube Shorts:** 1080x1920, H.264, 15Mbps
- **Instagram Reels:** 1080x1920, H.264, 12Mbps
- **TikTok/Facebook:** 1080x1920, H.264, 10Mbps

## Git Tracking
Tracked: scripts, templates, documentation, Fusion settings
Ignored: video files, images, cache, proxies, exports, archives, venv/
