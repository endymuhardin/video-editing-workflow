# Shorts Bumpers

Bumpers for vertical short-form content (YouTube Shorts, Instagram Reels, Facebook Reels).

## Format Specifications

| Platform | Resolution | Max Duration | Safe Zones |
|----------|------------|--------------|------------|
| YouTube Shorts | 1080x1920 | 60 sec | Bottom 15% for UI |
| Instagram Reels | 1080x1920 | 90 sec | Bottom 20% for UI |
| Facebook Reels | 1080x1920 | 90 sec | Bottom 15% for UI |

## Style Guidelines

- **Tone:** Punchy, attention-grabbing, fast
- **Duration:** Intro 1-2 sec MAX, Outro 2-3 sec
- **Colors:** High contrast, vibrant
- **Typography:** Large, bold, readable on mobile
- **Animation:** Quick, impactful

## Key Differences from Landscape

1. **Vertical composition** - Design for 9:16
2. **Mobile-first** - Text must be large and readable
3. **No dead space** - Every frame should be engaging
4. **Quick branding** - Logo watermark often better than intro bumper
5. **CTA placement** - Avoid bottom 20% (platform UI overlap)

## Suggested Templates

### YouTube Shorts
```
shorts/youtube/
├── Intro_YTShorts.setting      # 1.5 sec quick brand
├── Outro_YTShorts.setting      # 2 sec follow CTA
└── Watermark_YTShorts.setting  # Corner logo overlay
```

### Instagram Reels
```
shorts/instagram/
├── Intro_IGReels.setting       # 1 sec quick hook
├── Outro_IGReels.setting       # 3 sec follow + like
└── Watermark_IGReels.setting   # Subtle corner brand
```

### Facebook Reels
```
shorts/facebook/
├── Intro_FBReels.setting       # 1 sec
├── Outro_FBReels.setting       # 2 sec follow CTA
└── Watermark_FBReels.setting   # Corner brand
```

## Typical Structure

**Intro (optional, often skipped):**
```
[Quick logo flash]
[Topic text hook]
```

**Watermark (preferred):**
```
[Small corner logo throughout video]
[@handle text]
```

**Outro:**
```
[Follow for more]
[@handle]
[Arrow pointing to follow button area]
```

## Safe Zone Template

```
┌────────────────────┐
│                    │  ← Safe for text/logo
│                    │
│                    │
│    MAIN CONTENT    │
│                    │
│                    │
│                    │
├────────────────────┤
│  ⚠️ PLATFORM UI    │  ← Avoid text here
│  (buttons, handle) │     Bottom 15-20%
└────────────────────┘
```

## Color Palette (High Contrast)

```
Background:         #000000 / RGB(0, 0, 0)
Primary accent:     #ff0050 / RGB(1.0, 0, 0.31) - TikTok-style
Alt accent:         #00f2ea / RGB(0, 0.95, 0.92)
Text:               #ffffff / RGB(1, 1, 1)
```

## Platform-Specific Notes

### YouTube Shorts
- Can link to full video at end
- Subscribe button appears at bottom
- Hashtags in description, not burned in

### Instagram Reels
- Profile link at bottom left
- Audio attribution at bottom
- Can add "Collab" tags

### Facebook Reels
- Share/like buttons on right
- Profile at bottom
- Cross-posts to Instagram possible

## Export Settings

All platforms accept same specs:
```
Resolution:     1080 x 1920
Frame rate:     30 fps
Codec:          H.264
Bitrate:        10-15 Mbps
Audio:          AAC 128kbps
```
