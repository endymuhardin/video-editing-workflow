# Lower Third Fusion Templates

## Available Templates

### 1. LowerThird_Simple.setting
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

**Editable Controls:**
- Name (text)
- Title (text)
- Bar Color (RGB)
- Animation Offset

**Animation:** Slides in from left (frames 0-15), holds, slides out (frames 135-150)

### 2. LowerThird_Minimal.setting
Clean design with accent bar, staggered fade-in animation.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ▌ Endy Muhardin                                               │
│   ▌ artivisi.com                                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Editable Controls:**
- Name (text)
- Title (text)
- Accent Color (RGB)

**Animation:**
- Accent bar fades in (frames 0-10)
- Name fades in + slides (frames 5-18)
- Title fades in + slides (frames 10-23)
- Reverse out (frames 127-150)

---

## Installation

### Method 1: Drag and Drop (Per Project)
1. Open DaVinci Resolve
2. Go to Fusion page
3. Drag `.setting` file into the Fusion node graph
4. Connect MediaIn to your clip, MediaOut to output

### Method 2: Install to Fusion Templates (Global)
1. Copy `.setting` files to:
   - **Mac:** `~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Templates/Edit/Titles/`
   - **Windows:** `%APPDATA%\Blackmagic Design\DaVinci Resolve\Fusion\Templates\Edit\Titles\`
2. Restart DaVinci Resolve
3. Access from: Effects > Toolbox > Titles

### Method 3: Power Bins (Recommended)
1. Edit page > Media Pool
2. Right-click > Show Power Bins
3. Create bin: "Lower Thirds"
4. Drag template clips into Power Bin
5. Available across all projects

---

## Usage

### In Edit Page (Timeline)
1. Add template as Fusion Clip above your video
2. Right-click > Open in Fusion Page
3. Select the Group node (LowerThird or LowerThirdMinimal)
4. In Inspector panel, edit:
   - Name
   - Title
   - Colors

### Adjusting Duration
Default duration: 150 frames (5 seconds at 30fps)

To change:
1. In Fusion, select all keyframed nodes
2. Open Spline Editor (Shift+Space > Spline)
3. Select all keyframes
4. Scale to desired duration

### Changing Position
1. Select the Rectangle/Mask node
2. Adjust Center X/Y values
3. Or use Transform node for global position

---

## Customization

### Change Font
1. Select NameText or TitleText node
2. Inspector > Font dropdown
3. Select your font

Recommended fonts:
- **Mac:** SF Pro Display, Helvetica Neue
- **Cross-platform:** Roboto, Inter, Open Sans
- **Monospace (code):** JetBrains Mono, Fira Code

### Change Colors
In the Group controls:
- Bar Color / Accent Color: Main brand color
- Text colors: Edit in individual Text+ nodes

### Add Drop Shadow
1. Select Text+ node
2. Inspector > Shading > Element 2
3. Enable, set as Shadow
4. Adjust offset, softness, opacity

### Add Background Blur (frosted glass effect)
1. Add Background node before rectangle mask
2. Set to transparent
3. Add Blur after Merge
4. Mask blur to rectangle area

---

## Creating Your Own

### Basic Structure
```
MediaIn → Background → Text+ → Merge → Transform (animate) → Merge → Output
              ↓
           Mask (shape)
```

### Save as Reusable Macro
1. Select all nodes in your lower third
2. Right-click > Macro > Create Macro
3. Expose desired controls (name, title, colors)
4. Save as `.setting` file

### Animation Tips
- Use BezierSpline for smooth easing
- Stagger animations 5-10 frames for polish
- Keep total animation under 1 second in/out
- Match timing to your video's pacing

---

## Troubleshooting

### Text Not Showing
- Check Text+ node is connected
- Verify font is installed
- Check opacity/blend values

### Animation Not Playing
- Ensure keyframes exist on Spline
- Check timeline range matches keyframe range
- Verify Animation Offset is 0

### Colors Look Wrong
- Check project color management
- Ensure values are 0-1 range (not 0-255)
- Verify alpha channel settings
