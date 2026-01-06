# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Video editing workflow system for programming tutorial videos on MacBook Pro M1. Complete pipeline from recording (OBS) through auto-editing to multi-platform export (YouTube, Instagram Reels, TikTok).

## Commands

### Project Creation
```bash
./new-project.sh PROJECT_CODE "Project Description"
# Creates: projects/YYYY-MM-DD_PROJECT_CODE/ with full template structure
```

### Auto-Editor (Silence Removal)
```bash
cd projects/YYYY-MM-DD_PROJECT_CODE

./auto-edit.sh                              # Default: export DaVinci XML
./auto-edit.sh --preview                    # Preview cuts only
./auto-edit.sh --margin 0.08sec --threshold 5%  # Aggressive removal
./auto-edit.sh --export video               # MP4 re-encode
./auto-edit.sh --export premiere            # Premiere Pro XML
./auto-edit.sh --export fcpxml              # Final Cut Pro XML
```

### Python Environment
```bash
source venv/bin/activate
pip install auto-editor
```

## Architecture

### Directory Structure
```
template/
├── 01-raw/          # Immutable source (camera/, screen/, audio/)
├── 02-proxy/        # Temp cache/proxies (gitignored)
├── 03-project/      # DaVinci .drp + auto-editor output
├── 04-assets/       # Fusion templates (bumpers/, lower-thirds/)
├── 05-exports/      # Final renders (master/, shorts/)
├── 06-captions/     # SRT/VTT subtitles
└── 07-archive/      # Completed archives (gitignored)
```

### Processing Pipeline
```
OBS Recording → auto-editor (silence removal) → DaVinci Resolve → Export
                      ↓
               03-project/auto-editor/*.xml
```

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

## Export Targets
- **Master:** 1920x1080, H.265, 25Mbps
- **YouTube Shorts:** 1080x1920, H.264, 15Mbps
- **Instagram Reels:** 1080x1920, H.264, 12Mbps
- **TikTok:** 1080x1920, H.264, 10Mbps

## Git Tracking
Tracked: scripts, templates, documentation, Fusion settings
Ignored: video files, images, cache, proxies, exports, archives, venv/
