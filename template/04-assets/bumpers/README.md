# Bumper Templates

Organized by content type. Each folder contains Fusion templates and style guidelines.

## Structure

```
bumpers/
├── coding-tutorial/    # Programming tutorials (dark theme, professional)
│   ├── IntroBumper_Modern.setting
│   ├── IntroBumper_Minimal.setting
│   ├── OutroBumper_EndScreen.setting
│   └── OutroBumper_Simple.setting
├── vlog/               # Personal vlogs (warm, casual)
├── podcast/            # Video podcasts (branded, audio-focused)
└── shorts/             # Vertical short-form
    ├── youtube/        # YouTube Shorts
    ├── instagram/      # Instagram Reels
    └── facebook/       # Facebook Reels
```

## Content Type Summary

| Type | Intro | Outro | Style |
|------|-------|-------|-------|
| Coding Tutorial | 3-4 sec | 5-20 sec | Dark, professional, tech |
| Vlog | 2-3 sec | 5-10 sec | Warm, personal, energetic |
| Podcast | 5-8 sec | 10-15 sec | Branded, audio-centric |
| Shorts | 1-2 sec | 2-3 sec | Punchy, high contrast, vertical |

## Quick Start

1. Choose content type folder
2. Read folder's README for style guidelines
3. Copy template to project's `04-assets/bumpers/`
4. Customize in Fusion (text, colors)

## Installation Methods

### Method 1: Drag and Drop
1. Open DaVinci Resolve
2. Create Fusion Composition (Effects > Generate > Fusion Composition)
3. Open in Fusion page
4. Drag `.setting` file into node graph
5. Connect to MediaOut

### Method 2: Install to Templates
```bash
# Mac - install all templates
cp -r coding-tutorial/*.setting ~/Library/Application\ Support/Blackmagic\ Design/DaVinci\ Resolve/Fusion/Templates/Edit/Generators/
```

### Method 3: Power Bins (Recommended)
1. Create Fusion Clip with bumper
2. Set duration
3. Drag to Power Bins > "Bumpers"
4. Reuse across projects

## Customization

**Change text:**
1. Select bumper group in Fusion
2. Inspector > Controls
3. Edit Channel Name, Tagline, etc.

**Change colors:**
1. Select bumper group
2. Inspector > Controls
3. Adjust Background Color, Accent Color

**Change duration:**
1. Open Spline Editor (Shift+Space > Spline)
2. Select all keyframes
3. Scale to desired duration
4. Update GlobalOut on all nodes

## Pre-rendering (Optional)

For faster timeline performance:

```
Format:         QuickTime
Codec:          Apple ProRes 4444
Resolution:     1920x1080 (landscape) / 1080x1920 (shorts)
Frame rate:     30
Alpha:          Straight
```

Save to `bumpers/rendered/` for reuse.

## Audio

Add audio in Edit page after placing bumper:
- Whoosh/transition sound
- Music swell
- Logo sound effect

Free sources: YouTube Audio Library, Freesound.org, Pixabay
