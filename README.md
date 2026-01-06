# Video Editing Workflow

AI-assisted video production workflow for programming tutorials, vlogs, podcasts, and shorts. Optimized for MacBook Pro M1, Nikon ZFC camera, and DaVinci Resolve.

## Features

- **AI-Powered Pipeline**: Transcription → Visual recommendations → Auto-cut
- **Transcript-Aware Editing**: Cut filler words, repetitions, dead air (not just silence)
- **Visual Recommendations**: AI suggests where to add graphics, b-roll, screen captures
- **Auto-Generated Assets**: Lower third timings, YouTube chapters, SEO suggestions
- **Content Type Templates**: Coding tutorials, vlogs, podcasts, shorts
- **Multi-Platform Export**: YouTube, Instagram Reels, TikTok, Facebook Reels

## Requirements

- macOS (Apple Silicon)
- Python 3.x
- DaVinci Resolve 20.x
- Elgato Cam Link 4K (or similar HDMI capture)
- API key (Anthropic or OpenAI) for AI analysis

## Installation

```bash
git clone https://github.com/endymuhardin/video-editing-workflow.git
cd video-editing-workflow

# Setup Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install AI pipeline dependencies
pip install openai-whisper    # Transcription
pip install anthropic         # AI analysis (or: pip install openai)

# Optional: Legacy silence-only removal
pip install auto-editor
```

Set API key:
```bash
export ANTHROPIC_API_KEY="your-key"   # For Claude
# OR
export OPENAI_API_KEY="your-key"      # For GPT-4
```

## Quick Start

### 1. Create New Project

```bash
./new-project.sh PROJECT_CODE [CONTENT_TYPE] "Description"

# Interactive (prompts for content type):
./new-project.sh SPRING01

# Direct:
./new-project.sh SPRING01 coding-tutorial "Spring Boot REST API"
./new-project.sh BALI01 vlog "Bali Trip Day 1"
./new-project.sh EP42 podcast "Interview with Dr. Smith"
./new-project.sh TIP01 shorts "Quick Git Tip"
```

Content types: `coding-tutorial`, `vlog`, `podcast`, `shorts`

### 2. Record

Using Nikon ZFC + Hollyland Lark M2 → OBS:

```
F1 - Talking head (full camera)
F2 - Screen + camera overlay
F3 - Screen only
F9 - Start recording
F10 - Stop recording
```

### 3. AI Processing Pipeline

```bash
cd projects/YYYY-MM-DD_PROJECT_CODE

# Run full pipeline
./tools/process.sh 01-raw/camera/video.mov coding-tutorial
```

This automatically:
1. **Transcribes** video (Whisper)
2. **Analyzes** transcript for visual recommendations
3. **Generates** EDL/XML with intelligent cuts

Output in `03-project/ai-analysis/`:
```
├── video.srt                   # Subtitles
├── visual-recommendations.md   # Graphics/b-roll needed
├── lower-thirds.csv            # Lower third timings
├── chapters.md                 # YouTube chapters
├── cuts.md                     # What to cut (filler, repetitions)
├── seo.md                      # Title/tags suggestions
├── video.edl                   # Import to DaVinci
└── video.fcpxml                # Alternative format
```

### 4. Review & Prepare Assets

```bash
cat 03-project/ai-analysis/visual-recommendations.md
```

Example output:
```
| Timestamp | Type        | Description                      |
|-----------|-------------|----------------------------------|
| 0:45-1:20 | INFOGRAPHIC | Request/Response flow diagram    |
| 2:30-3:00 | SCREEN      | Show IDE creating new project    |
| 5:00-5:10 | B_ROLL      | Typing close-up (transition)     |
```

Prepare:
- Create infographics (Figma/Canva)
- Record screen captures
- Find/record b-roll footage

### 5. Edit in DaVinci Resolve

1. **Import timeline**: File → Import → Timeline → `video.edl`
2. **Link media** from `01-raw/`
3. **Review auto-cuts** (filler words, repetitions already removed)
4. **Add visuals** at recommended timestamps
5. **Add lower thirds** from `04-assets/lower-thirds/[content-type]/`
6. **Add bumpers** from `04-assets/bumpers/[content-type]/`

### 6. Export & Publish

```bash
# Copy subtitles
cp 03-project/ai-analysis/video.srt 06-captions/

# Copy chapters to YouTube description
cat 03-project/ai-analysis/chapters.md
```

Export targets:
- **Master**: 1920×1080, H.265, 25Mbps
- **YouTube Shorts**: 1080×1920, H.264, 15Mbps
- **Instagram/TikTok**: 1080×1920, H.264, 10-12Mbps

## Project Structure

```
video-editing-workflow/
├── new-project.sh              # Create new project
├── tools/                      # AI processing pipeline
│   ├── process.sh              # Full pipeline
│   ├── transcribe.sh           # Whisper transcription
│   ├── analyze.py              # AI visual recommendations
│   └── autocut.py              # Transcript-aware cutting
├── projects/                   # Your video projects
└── template/
    ├── 00-planning/            # Script, outline, shotlist
    ├── 01-raw/                 # Raw footage
    ├── 02-proxy/               # Cache/proxy files
    ├── 03-project/
    │   ├── davinci/            # DaVinci project files
    │   └── ai-analysis/        # AI pipeline output
    ├── 04-assets/
    │   ├── bumpers/            # By content type
    │   ├── lower-thirds/       # By content type
    │   └── thumbnails/         # By content type
    ├── 05-exports/             # Final renders
    ├── 06-captions/            # Subtitles
    ├── 07-archive/             # Completed archives
    └── AI-WORKFLOW.md          # Detailed AI workflow guide
```

## Workflow Diagram

```
┌──────────────────────────────────────────────────────────────────────┐
│                        AUTOMATED (tools/)                            │
│                                                                      │
│   Record → Transcribe → AI Analyze → Auto-cut → EDL/XML              │
│              (Whisper)    (Claude)                                   │
│                  │           │                                       │
│                  ▼           ▼                                       │
│             .srt file   visual-recommendations.md                    │
│                         lower-thirds.csv                             │
│                         chapters.md                                  │
│                         cuts.md                                      │
└──────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   DaVinci Resolve   │
                         │   + effects         │
                         │   + bumpers         │
                         │   + lower thirds    │
                         └─────────────────────┘
                                    │
                                    ▼
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
               YouTube        Instagram        TikTok
               + Shorts         Reels          + FB Reels
```

## Documentation

| File | Description |
|------|-------------|
| `AI-WORKFLOW.md` | Complete AI-assisted workflow with prompts |
| `tools/README.md` | AI processing pipeline documentation |
| `OBS-SETUP.md` | Recording setup guide |
| `DAVINCI-SETTINGS.md` | Export presets, AI features |
| `CLAUDE.md` | Instructions for Claude Code |

## Hardware Setup

```
Nikon ZFC (HDMI) → Cam Link 4K → MacBook Pro M1
                                        │
Hollyland Lark M2 (USB-C) ──────────────┘
        │
        ▼
   OBS Studio → DaVinci Resolve
```

## Content Types

| Type | Bumper | Lower Third | Thumbnail |
|------|--------|-------------|-----------|
| coding-tutorial | 3-4s dark | 3-5s pro | Code/logo |
| vlog | 2-3s warm | 2-4s casual | Face/emotion |
| podcast | 5-8s branded | 5-8s broadcast | Host+guest |
| shorts | 1-2s bold | 2-3s mobile | Action frame |

## ArtiVisi Brand

```
Primary:    #2e3192 (Deep Blue)
Secondary:  #58c034 (Green)
Fonts:      Inter, Fira Code
```

## License

MIT License - see [LICENSE](LICENSE)

## Author

Endy Muhardin - [youtube.com/artivisi](https://youtube.com/artivisi)
