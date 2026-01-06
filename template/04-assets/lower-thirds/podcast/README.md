# Podcast Lower Thirds

Lower thirds for video podcast/interview content.

## Style Guidelines

- **Tone:** Professional, broadcast quality
- **Duration:** 5-8 seconds (longer for guest introductions)
- **Position:** Bottom, full width or speaker-aligned
- **Animation:** Smooth slide, professional broadcast style

## Color Palette

ArtiVisi brand colors:

```
Primary (Deep Blue):    #2e3192 / RGB(0.18, 0.19, 0.57)
Secondary (Green):      #58c034 / RGB(0.35, 0.75, 0.20)
Text (Dark):            #1a1a2e / RGB(0.10, 0.10, 0.18)
Text (Light):           #ffffff / RGB(1, 1, 1)
Background:             #ffffff @ 95% opacity
```

## Typography

```
Primary Font:    Inter
Name Weight:     700 (Bold)
Role Weight:     500 (Medium)
Size (Name):     28-32px
Size (Role):     18-22px
```

## Suggested Templates

| Template | Style | Use Case |
|----------|-------|----------|
| LowerThird_Host.setting | Left-aligned | Host identification |
| LowerThird_Guest.setting | Right-aligned | Guest introduction |
| LowerThird_Topic.setting | Center, full-width | Segment title |
| LowerThird_Quote.setting | Highlight style | Key quotes |

## Layout - Two Speaker

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│   ┌─────────────┐              ┌─────────────┐        │
│   │             │              │             │        │
│   │    HOST     │              │    GUEST    │        │
│   │             │              │             │        │
│   └─────────────┘              └─────────────┘        │
│                                                        │
├─────────────────────┬──────────────────────────────────┤
│ ▌ Endy Muhardin     │              Dr. Jane Smith    ▐ │
│ ▌ Host              │              AI Researcher     ▐ │
└─────────────────────┴──────────────────────────────────┘
  ↑                                                    ↑
  Host (left accent)                    Guest (right accent)
```

## Layout - Single Speaker

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│                   ┌─────────────┐                      │
│                   │             │                      │
│                   │   SPEAKER   │                      │
│                   │             │                      │
│                   └─────────────┘                      │
│                                                        │
├────────────────────────────────────────────────────────┤
│ ▌ Dr. Jane Smith                                       │
│ ▌ AI Researcher at Google DeepMind                     │
└────────────────────────────────────────────────────────┘
```

## Lower Third Types

| Type | Primary | Secondary | Tertiary |
|------|---------|-----------|----------|
| Host | Name | Role | Show name |
| Guest | Name | Title | Organization |
| Topic | Segment title | Episode info | - |
| Quote | Quote text | Speaker name | - |
| Social | @handle | Platform | - |

## Animation Timing (Broadcast Style)

```
0.0s - 0.4s: Slide in from left (ease-out-cubic)
0.4s - 7.0s: Hold
7.0s - 7.5s: Slide out to left
```

## Matching OBS Overlay

Consistent with podcast scene from live-stream-overlay:
- Two-speaker layout (900×748 each)
- Host at left (24, 120)
- Guest at right (996, 120)
- Lower third height: 80px
