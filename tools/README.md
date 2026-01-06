# Video Processing Tools

AI-assisted video processing pipeline for transcription, analysis, and auto-cutting.

## Pipeline Overview

```
Video → Transcribe → AI Analysis → Auto-cut → DaVinci Resolve
         (Whisper)    (Claude/GPT)   (EDL/XML)
              ↓            ↓             ↓
         transcript   visual recs    edit timeline
           .json      cuts.md        .edl/.fcpxml
                      chapters.md
                      lower-thirds.csv
```

## Quick Start

### Full Pipeline (Recommended)

```bash
# Run entire pipeline
./tools/process.sh 01-raw/camera/video.mov coding-tutorial

# Content types: coding-tutorial, vlog, podcast, shorts
```

### Individual Steps

```bash
# 1. Transcribe only
./tools/transcribe.sh 01-raw/camera/video.mov

# 2. AI Analysis only
./tools/analyze.py 03-project/ai-analysis/video.json --content-type coding-tutorial

# 3. Auto-cut only
./tools/autocut.py 01-raw/camera/video.mov \
    --transcript 03-project/ai-analysis/video.json \
    --analysis 03-project/ai-analysis/analysis.json
```

## Requirements

### Transcription (choose one)

```bash
# Option 1: OpenAI Whisper (recommended)
pip install openai-whisper

# Option 2: whisper.cpp (faster, needs model)
brew install whisper-cpp
```

### AI Analysis (choose one)

```bash
# Option 1: Anthropic Claude (recommended)
pip install anthropic
export ANTHROPIC_API_KEY="your-key"

# Option 2: OpenAI
pip install openai
export OPENAI_API_KEY="your-key"

# Option 3: Local (Ollama)
# Install Ollama and pull a model
ollama pull llama3.2
```

### Auto-cut

```bash
# ffprobe for video duration detection
brew install ffmpeg
```

## Output Files

After running `process.sh`, you'll get:

```
03-project/ai-analysis/
├── video.txt               # Plain text transcript
├── video.srt               # Subtitles (for captions)
├── video.json              # Word-level timestamps
├── analysis.json           # Full AI analysis
├── visual-recommendations.md   # Graphics/b-roll needed
├── lower-thirds.csv        # Lower third timings
├── chapters.md             # YouTube chapters
├── cuts.md                 # Suggested cuts list
├── seo.md                  # Title/tags suggestions
├── video.edl               # Edit decision list
├── video.fcpxml            # Final Cut Pro XML
└── video_cuts_report.md    # Cut summary report
```

## Workflow Integration

### 1. After Recording

```bash
cd projects/2026-01-06_PROJECT

# Process video
./tools/process.sh 01-raw/camera/video.mov coding-tutorial
```

### 2. Review Recommendations

```bash
# Open in editor
code 03-project/ai-analysis/visual-recommendations.md
```

Example output:
```markdown
| Timestamp | Type | Description |
|-----------|------|-------------|
| 0:45-1:20 | INFOGRAPHIC | Request/Response flow diagram |
| 2:30-3:00 | SCREEN | IDE: Creating new project |
| 5:00-5:10 | B_ROLL | Typing close-up (transition) |
```

### 3. Prepare Assets

Based on recommendations:
- Create infographics in Figma/Canva
- Record screen captures
- Find/record b-roll footage

### 4. Import to DaVinci Resolve

1. Open DaVinci Resolve
2. File → Import → Timeline → `video.edl` or `video.fcpxml`
3. Link media when prompted
4. Review auto-cuts
5. Add prepared visuals at recommended timestamps

### 5. Add Lower Thirds

Use `lower-thirds.csv`:
```csv
timestamp,name,subtitle,duration
0:15,"Endy Muhardin","Software Architect",4
3:30,"Spring Boot","Framework",3
```

### 6. Copy Chapters to YouTube

From `chapters.md`:
```
0:00 Introduction
2:30 Project Setup
5:00 Creating Entity
...
```

## Configuration

### Whisper Language

Edit `transcribe.sh` line 37:
```bash
--language id    # Indonesian
--language en    # English
--language auto  # Auto-detect
```

### Silence Threshold

Edit `autocut.py` call:
```bash
--silence-threshold 0.5   # Cut silences > 0.5s (default)
--silence-threshold 1.0   # Only cut silences > 1s
```

### AI Model

Edit `analyze.py` call:
```bash
--api anthropic   # Claude (default)
--api openai      # GPT-4
--api local       # Ollama (free, local)
```

## Troubleshooting

### "Whisper not found"

```bash
# Check installation
which whisper

# If using venv
source venv/bin/activate
pip install openai-whisper
```

### "No API key found"

```bash
# Add to shell profile (~/.zshrc or ~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."

# Or for OpenAI
export OPENAI_API_KEY="sk-..."

# Reload
source ~/.zshrc
```

### "ffprobe not found"

```bash
brew install ffmpeg
```

### EDL not importing correctly

- Check frame rate matches (default 30fps)
- Use XML format instead: `--format xml`
- Try File → Import → Timeline instead of drag-drop

## Tips

1. **Review before importing** - AI cuts are suggestions, not perfect
2. **Keep original** - EDL/XML is non-destructive
3. **Batch process** - Run overnight for long videos
4. **GPU acceleration** - Whisper uses GPU if available
5. **Local = free** - Ollama works offline, no API costs
