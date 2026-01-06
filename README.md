# Video Editing Workflow

Streamlined video production workflow for programming tutorial videos. Optimized for MacBook Pro M1, Nikon ZFC camera, and DaVinci Resolve 20.x.

## Features

- Folder structure template for consistent project organization
- OBS multi-source recording setup (screen + camera)
- Auto-editor integration for automated silence removal
- DaVinci Resolve project settings and export presets
- Fusion lower third templates
- Multi-platform export (YouTube, Instagram Reels, TikTok)

## Requirements

- macOS (Apple Silicon)
- OBS Studio
- DaVinci Resolve 20.x
- Python 3.x (for auto-editor)
- Elgato Cam Link 4K (or similar HDMI capture)

## Installation

```bash
git clone https://github.com/endymuhardin/video-editing-workflow.git
cd video-editing-workflow
pip install auto-editor
```

## Quick Start

### 1. Create New Project

```bash
./new-project.sh PROJECT_CODE "Project Description"

# Example:
./new-project.sh SPRING01 "Spring Boot Tutorial Part 1"
```

### 2. Configure OBS

See `template/OBS-SETUP.md` for:
- Scene configuration (talking head, screen+camera, screen only)
- M1 optimized recording settings
- CamLink setup for Nikon ZFC

### 3. Record

```
F1 - Talking head (full camera)
F2 - Screen + camera overlay
F3 - Screen only
F9 - Start recording
F10 - Stop recording
```

### 4. Process with Auto-Editor

```bash
cd projects/YYYY-MM-DD_PROJECT_CODE
./auto-edit.sh                    # Remove silences, export DaVinci XML
./auto-edit.sh --preview          # Preview cuts first
./auto-edit.sh --threshold 6%     # More aggressive cutting
```

### 5. Edit in DaVinci Resolve

1. Import XML timeline: File > Import > Timeline
2. Link media from `01-raw/`
3. Fine-tune edits
4. Add lower thirds from `04-assets/lower-thirds/`
5. Export using presets (see `DAVINCI-SETTINGS.md`)

### 6. Export for Multiple Platforms

```
05-exports/
├── master/          # YouTube (1920x1080)
└── shorts/
    ├── youtube/     # YouTube Shorts (1080x1920)
    ├── instagram/   # Instagram Reels (1080x1920)
    └── tiktok/      # TikTok (1080x1920)
```

## Project Structure

```
video-editing-workflow/
├── new-project.sh           # Create new project from template
├── projects/                # Your video projects
└── template/
    ├── 01-raw/              # Raw footage (camera, screen, audio)
    ├── 02-proxy/            # Proxy/cache files
    ├── 03-project/          # DaVinci + auto-editor files
    ├── 04-assets/           # Lower thirds, bumpers, graphics
    ├── 05-exports/          # Final exports
    ├── 06-captions/         # SRT/VTT subtitles
    ├── 07-archive/          # Completed project archives
    ├── auto-edit.sh         # Silence removal script
    ├── DAVINCI-SETTINGS.md  # Resolve 20.x settings
    ├── OBS-SETUP.md         # Recording setup guide
    └── README.md            # Template documentation
```

## Documentation

| File | Description |
|------|-------------|
| `template/README.md` | Workflow checklist and naming conventions |
| `template/OBS-SETUP.md` | OBS scenes, M1 encoding, CamLink setup |
| `template/DAVINCI-SETTINGS.md` | Project settings, export presets, AI features |
| `template/04-assets/lower-thirds/README.md` | Fusion template usage |

## Hardware Setup

```
Nikon ZFC → HDMI → Cam Link 4K → MacBook Pro M1 (USB-C direct)
                                       ↓
                               OBS Studio (recording)
                                       ↓
                               DaVinci Resolve (editing)
```

## Workflow Diagram

```
Record (OBS)
    ↓
Auto-Editor (silence removal)
    ↓
DaVinci Resolve (edit, color, graphics)
    ↓
Export Master (1080p)
    ↓
Create Shorts (vertical 9:16)
    ↓
Upload (YouTube, Instagram, TikTok)
```

## License

MIT License - see [LICENSE](LICENSE)

## Author

Endy Muhardin - [youtube.com/artivisi](https://youtube.com/artivisi)
