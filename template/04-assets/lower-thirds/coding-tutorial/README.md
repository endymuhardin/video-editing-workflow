# Coding Tutorial Lower Thirds

Lower thirds for programming tutorial content using ArtiVisi brand palette.

## Templates

| Template | Style | Use Case |
|----------|-------|----------|
| LowerThird_Simple.setting | Solid bar + slide | Standard name/title |
| LowerThird_Minimal.setting | Clean + accent bar | Subtle identification |

## ArtiVisi Color Palette

```
Primary (Deep Blue):    #2e3192 / RGB(0.18, 0.19, 0.57)
Secondary (Green):      #58c034 / RGB(0.35, 0.75, 0.20)
Text (Dark):            #1a1a2e / RGB(0.10, 0.10, 0.18)
Text (Light):           #ffffff / RGB(1, 1, 1)
Text (Muted):           #6b7280 / RGB(0.42, 0.45, 0.50)
Background:             #f8f9fc / RGB(0.97, 0.98, 0.99)
```

## Typography

```
Primary Font:    Inter (system-ui fallback)
Monospace:       Fira Code
Name Weight:     700 (Bold)
Role Weight:     500 (Medium)
```

## Style Guidelines

- **Tone:** Professional, clean, tech-focused
- **Duration:** 3-5 seconds on screen
- **Position:** Bottom left, safe zone compliant
- **Animation:** Slide in from left, hold, fade out

## Layout Specifications

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│                     VIDEO CONTENT                      │
│                                                        │
│                                                        │
├──────────────────────────────────────────────────────┬─┤
│ ▌ Endy Muhardin                                      │ │
│ ▌ Software Architect                                 │ │
└──────────────────────────────────────────────────────┴─┘
  ↑                                                    ↑
  Accent bar (4px, primary→secondary gradient)         Safe margin
```

**Dimensions:**
- Width: ~500-600px (flexible)
- Height: 80-100px
- Accent bar: 4-6px gradient
- Margin from edge: 48px left, 64px bottom
- Corner radius: 8px

## Suggested Lower Third Types

| Type | Name Field | Secondary Field |
|------|------------|-----------------|
| Speaker | Full name | Role/Title |
| Topic | Topic title | Section number |
| Code Reference | File name | Line numbers |
| URL | Website | Description |
| Social | @handle | Platform |

## Animation Timing

```
0.0s - 0.3s: Slide in (ease-out)
0.3s - 4.5s: Hold
4.5s - 5.0s: Fade out
```

## Matching OBS Overlay

These templates match the ArtiVisi live stream overlay style from:
`/Users/endymuhardin/workspace/video-editing/live-stream-overlay`

Consistent elements:
- Same color palette
- Same typography (Inter)
- Same accent bar gradient style
- Same shadow depth
