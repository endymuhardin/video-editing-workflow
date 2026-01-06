# Lower Third Templates

Organized by content type with ArtiVisi brand palette.

## Structure

```
lower-thirds/
├── coding-tutorial/        # Programming tutorials
│   ├── LowerThird_Simple.setting
│   └── LowerThird_Minimal.setting
├── vlog/                   # Personal vlogs
├── podcast/                # Video podcasts
└── shorts/                 # Vertical short-form
```

## ArtiVisi Brand Palette

```
Primary (Deep Blue):    #2e3192
Secondary (Green):      #58c034
Text (Dark):            #1a1a2e
Text (Light):           #ffffff
Text (Muted):           #6b7280
Background:             #f8f9fc
```

**Fonts:** Inter (primary), Fira Code (monospace)

## Content Type Summary

| Type | Duration | Position | Style |
|------|----------|----------|-------|
| Coding Tutorial | 3-5 sec | Bottom left | Professional, clean |
| Vlog | 2-4 sec | Bottom left/center | Friendly, warm |
| Podcast | 5-8 sec | Bottom, speaker-aligned | Broadcast quality |
| Shorts | 2-3 sec | Middle-lower (NOT bottom) | Bold, mobile-readable |

## Available Templates

### coding-tutorial/LowerThird_Simple.setting

Solid color bar with rounded corners, slide-in animation.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ┌──────────────────────────────┐                              │
│   │  Endy Muhardin               │                              │
│   │  Software Architect          │                              │
│   └──────────────────────────────┘                              │
└─────────────────────────────────────────────────────────────────┘
```

**Controls:** Name, Title, Bar Color, Animation Offset
**Animation:** Slides in from left (0-15f), holds, slides out (135-150f)

### coding-tutorial/LowerThird_Minimal.setting

Clean design with accent bar, staggered fade-in animation.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ▌ Endy Muhardin                                               │
│   ▌ artivisi.com                                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Controls:** Name, Title, Accent Color
**Animation:** Staggered fade-in (0-23f), reverse out (127-150f)

---

## Installation

### Method 1: Drag and Drop
1. Open DaVinci Resolve > Fusion page
2. Drag `.setting` file into node graph
3. Connect to MediaOut

### Method 2: Install to Fusion Templates
```bash
# Mac
cp coding-tutorial/*.setting ~/Library/Application\ Support/Blackmagic\ Design/DaVinci\ Resolve/Fusion/Templates/Edit/Titles/
```

### Method 3: Power Bins (Recommended)
1. Create lower third Fusion clip
2. Customize with defaults
3. Drag to Power Bins > "Lower Thirds"
4. Reuse across projects

---

## Customization

### Text
1. Select Group node
2. Inspector > Controls
3. Edit Name, Title

### Colors
Use ArtiVisi palette values:
- Bar/Accent Color: `#2e3192` or `#58c034`
- Convert hex to 0-1 range for Fusion

### Duration
Default: 150 frames (5 sec @ 30fps)
1. Spline Editor > select all keyframes
2. Scale to desired duration

### Font
1. Select Text+ node
2. Inspector > Font
3. Recommended: Inter, SF Pro Display, Fira Code (mono)

---

## Matching OBS Overlay

These templates use the same ArtiVisi palette as:
`/Users/endymuhardin/workspace/video-editing/live-stream-overlay`

Ensures visual consistency between live streams and edited videos.
