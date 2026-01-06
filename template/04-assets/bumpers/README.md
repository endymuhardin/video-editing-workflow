# Bumper Fusion Templates

## Intro Templates

### 1. IntroBumper_Modern.setting

Dark themed bumper with animated elements.

```
┌─────────────────────────────────────────┐
│                                         │
│            ════════════                 │
│              ArtiVisi                   │
│         Programming Tutorials           │
│                                         │
│     (subtle particle background)        │
│     (vignette effect)                   │
└─────────────────────────────────────────┘
```

**Duration:** 4 seconds (120 frames @ 30fps)

**Animation sequence:**
- Frame 0-25: Accent line animates in
- Frame 10-30: Channel name fades in + scales
- Frame 20-45: Tagline fades in
- Frame 85-120: All elements fade out

**Editable Controls:**
- Channel Name
- Tagline
- Background Color (dark)
- Accent Color (line)

**Elements:**
- Animated horizontal accent line
- Large channel name with tracking
- Smaller tagline below
- Subtle animated noise/particle background
- Vignette overlay

### 2. IntroBumper_Minimal.setting

Clean, light themed bumper.

```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│              ArtiVisi                   │
│         youtube.com/artivisi            │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

**Duration:** 3 seconds (90 frames @ 30fps)

**Animation sequence:**
- Frame 0-20: Channel name fades in + slides up
- Frame 8-28: URL fades in + slides up (staggered)
- Frame 62-90: All elements fade out

**Editable Controls:**
- Channel Name
- URL/Tagline
- Background Color (white)
- Text Color (dark)

---

## Installation

### Method 1: Drag and Drop
1. Open DaVinci Resolve
2. Create new Fusion Composition (Effects > Generate > Fusion Composition)
3. Open in Fusion page
4. Drag `.setting` file into node graph
5. Connect to MediaOut

### Method 2: Install to Templates
```bash
# Mac
cp *.setting ~/Library/Application\ Support/Blackmagic\ Design/DaVinci\ Resolve/Fusion/Templates/Edit/Generators/
```

### Method 3: Power Bins (Recommended)
1. Create Fusion Clip with bumper
2. Set duration (3-4 seconds)
3. Drag to Power Bins > "Bumpers"
4. Reuse across all projects

---

## Usage

### Adding to Timeline

1. Edit page > Effects > Generators > Fusion Composition
2. Drag to beginning of timeline
3. Set duration to 3-4 seconds
4. Right-click > Open in Fusion Page
5. Drag bumper template into composition
6. Connect to MediaOut1
7. Edit text in Inspector

### Customization

**Change text:**
1. Select IntroBumper group
2. Inspector > Controls
3. Edit Channel Name, Tagline

**Change colors:**
1. Select IntroBumper group
2. Inspector > Controls
3. Adjust Background Color, Accent Color

**Change duration:**

Default durations:
- Modern: 120 frames (4 sec @ 30fps)
- Minimal: 90 frames (3 sec @ 30fps)

To adjust:
1. Open Spline Editor (Shift+Space > Spline)
2. Select all keyframes
3. Scale to desired duration
4. Update GlobalOut on all nodes

---

## Creating Variations

### Dark Mode (from Minimal)
```
Background: RGB(0.08, 0.08, 0.1)
Text Color: RGB(1, 1, 1)
```

### Brand Colors
```
ArtiVisi blue accent: RGB(0.2, 0.6, 0.9)
```

### Add Logo
1. Import logo as MediaIn
2. Merge above text
3. Animate with Transform node

---

## Outro Templates

### 1. OutroBumper_EndScreen.setting

Full outro with YouTube end screen placeholders (20 seconds).

```
┌─────────────────────────────────────────┐
│     Subscribe for more tutorials        │
│   youtube.com/artivisi • github.com/... │
│                                         │
│   ┌─────────────┐   ┌─────────────┐     │
│   │             │   │             │     │
│   │  Video 1    │   │  Video 2    │     │
│   │  (YouTube   │   │  (YouTube   │     │
│   │  End Card)  │   │  End Card)  │     │
│   │             │   │             │     │
│   └─────────────┘   └─────────────┘     │
│                                         │
│         Thanks for watching!            │
│            ════════════                 │
│              ArtiVisi                   │
└─────────────────────────────────────────┘
```

**Duration:** 20 seconds (600 frames @ 30fps)

**YouTube End Screen compatible:**
- Two placeholder areas for video/playlist cards
- Safe zones positioned for YouTube's end screen editor
- Add end screen elements in YouTube Studio after upload

**Editable Controls:**
- Thank You Text
- Channel Name
- CTA Text (Subscribe message)
- Social Links
- Background Color
- Accent Color

**Animation sequence:**
- Frame 0-25: Thank you text fades in
- Frame 15-40: Channel name fades in
- Frame 25-55: Accent bar animates
- Frame 45-70: Subscribe text fades in
- Frame 60-85: Social links fade in
- Frame 545-600: All elements fade out

### 2. OutroBumper_Simple.setting

Short outro with subscribe button animation (5 seconds).

```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│          Thanks for watching            │
│              ArtiVisi                   │
│                                         │
│         ┌──────────────────┐            │
│         │  Like & Subscribe │           │
│         └──────────────────┘            │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

**Duration:** 5 seconds (150 frames @ 30fps)

**Editable Controls:**
- Message (Thanks text)
- Channel Name
- Call to Action (button text)
- Background Color
- Button Color (YouTube red default)

**Animation sequence:**
- Frame 0-20: Thanks text fades in + slides
- Frame 10-30: Channel name fades in + slides
- Frame 25-65: Subscribe button scales in with bounce
- Frame 35-60: CTA text fades in
- Frame 115-150: All elements fade out

---

## Outro Usage Tips

### YouTube End Screen Setup
1. Export video with OutroBumper_EndScreen
2. Upload to YouTube
3. YouTube Studio > Video details > End screen
4. Add elements in the placeholder areas
5. Position matches template safe zones

### Recommended End Screen Elements
- Subscribe button (centered)
- Latest video (left placeholder)
- Best for viewer / playlist (right placeholder)

---

## Audio

Bumpers work best with:
- Short whoosh/transition sound
- Subtle music swell
- Logo sound effect

Recommended: Add audio in Edit page after rendering bumper.

Free sound sources:
- YouTube Audio Library
- Freesound.org
- Pixabay

---

## Export as Video (Optional)

For faster timeline performance, pre-render bumper:

1. Create new timeline with just bumper
2. Deliver page > ProRes 4444 (with alpha) or PNG sequence
3. Save to `04-assets/bumpers/rendered/`
4. Use rendered version in projects

ProRes 4444 settings:
```
Format:         QuickTime
Codec:          Apple ProRes 4444
Resolution:     1920x1080
Frame rate:     30
Alpha:          Straight
```
