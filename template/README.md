# Video Production Template

## Folder Structure

```
template/
├── 01-raw/              # Original unedited footage
│   ├── camera/          # Nikon ZFC footage via CamLink
│   ├── screen/          # Screen recordings
│   └── audio/           # External audio (if any)
├── 02-proxy/            # Proxy files for smoother editing
├── 03-project/          # Project files
│   ├── davinci/         # DaVinci Resolve project files (.drp)
│   └── auto-editor/     # Auto-editor output (EDL/XML)
├── 04-assets/           # Reusable assets
│   ├── lower-thirds/    # Name cards, titles
│   ├── bumpers/         # Intro/outro clips
│   ├── thumbnails/      # YouTube thumbnail source files
│   └── graphics/        # Icons, overlays, b-roll
├── 05-exports/          # Final rendered files
│   ├── master/          # Full-length 1080p exports
│   └── shorts/          # Short-form content
│       ├── youtube/     # YouTube Shorts (9:16, <60s)
│       ├── instagram/   # Reels (9:16, <90s)
│       └── tiktok/      # TikTok (9:16, <3min)
├── 06-captions/         # SRT/VTT subtitle files
├── 07-archive/          # Completed project archives
├── auto-edit.sh         # Auto-editor script
├── DAVINCI-SETTINGS.md  # DaVinci Resolve 20.x project settings
├── OBS-SETUP.md         # Screen recording setup (M1)
├── SYNC-WORKFLOW.md     # Camera + screen sync guide
└── README.md            # This file
```

## Documentation

- **README.md** - Workflow overview and checklist
- **OBS-SETUP.md** - Screen recording setup (M1 optimized)
- **DAVINCI-SETTINGS.md** - Project settings, export presets, AI features (Resolve 20.x)
- **SYNC-WORKFLOW.md** - Syncing separate camera + screen recordings

## Naming Convention

```
[DATE]_[PROJECT-CODE]_[TYPE]_[SEQUENCE].[ext]

Examples:
- 2026-01-06_SPRING01_CAM_001.mov      # Camera footage
- 2026-01-06_SPRING01_SCR_001.mov      # Screen recording
- 2026-01-06_SPRING01_MASTER_v1.mp4    # Master export
- 2026-01-06_SPRING01_SHORT_01.mp4     # Short clip
```

## Auto-Editor Usage

Activate venv first (from project root):
```bash
source ../../venv/bin/activate
```

Basic usage (removes silences, exports DaVinci XML):
```bash
./auto-edit.sh
```

Options:
```bash
./auto-edit.sh --margin 0.2sec      # More padding around cuts (default: 0.1sec)
./auto-edit.sh --threshold 6%       # Higher = more aggressive cutting (default: 4%)
./auto-edit.sh --preview            # Preview cuts without exporting
./auto-edit.sh --export video       # Export as re-encoded MP4 instead of XML
./auto-edit.sh --export premiere    # Export for Premiere Pro
./auto-edit.sh --export fcpxml      # Export for Final Cut Pro
```

Presets by content type:
```bash
# Talking head (aggressive silence removal)
./auto-edit.sh --margin 0.08sec --threshold 5%

# Screen recording with narration (preserve more pauses)
./auto-edit.sh --margin 0.2sec --threshold 3%

# Mixed content (balanced)
./auto-edit.sh --margin 0.12sec --threshold 4%
```

Output goes to: `03-project/auto-editor/`

## Workflow Checklist

1. [ ] Copy raw footage to 01-raw/
2. [ ] Run `./auto-edit.sh` on raw files
3. [ ] Import XML timeline to DaVinci Resolve (File > Import > Timeline)
4. [ ] Fine-tune edits, add lower thirds
5. [ ] Add bumper (intro/outro)
6. [ ] Export master to 05-exports/master/
7. [ ] Generate shorts using OpusClip/Vizard
8. [ ] Add captions in CapCut
9. [ ] Export shorts to respective folders
10. [ ] Upload and schedule
11. [ ] Archive project when complete
