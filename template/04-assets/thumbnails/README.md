# Thumbnail Templates

Guidelines for creating thumbnails by content type.

## Structure

```
thumbnails/
├── coding-tutorial/    # Tech tutorials (code focus, logos)
├── vlog/               # Personal vlogs (face, emotion)
├── podcast/            # Interviews (guest photos, branding)
└── shorts/             # Vertical covers (bold, scroll-stopping)
```

## Specifications

| Platform | Resolution | Aspect | Format |
|----------|------------|--------|--------|
| YouTube | 1280×720 | 16:9 | PNG/JPG |
| YouTube Shorts | Auto or custom | 9:16 | - |
| Instagram Reels | 1080×1920 | 9:16 | PNG/JPG |
| Facebook Reels | 1080×1920 | 9:16 | PNG/JPG |
| TikTok | Frame select | 9:16 | - |

## Content Type Summary

| Type | Key Element | Text Amount | Style |
|------|-------------|-------------|-------|
| Coding Tutorial | Code/logo + face | 3-5 words | Professional |
| Vlog | Expressive face | 1-4 words | Personal |
| Podcast | Host + guest | Episode info | Branded |
| Shorts | Action frame | 1-3 words | Bold |

## ArtiVisi Palette

```
Primary:        #2e3192 (Deep Blue)
Secondary:      #58c034 (Green)
Text:           #ffffff (White on dark)
```

## Quick Tips

1. **Readable at small size** - Test at 150×84px (YouTube sidebar)
2. **Face = higher CTR** - Human faces attract attention
3. **Contrast is key** - Text must pop from background
4. **Consistency** - Same style across series
5. **No clickbait** - Thumbnail must match content

## File Naming

```
[PROJECT-CODE]_thumb_v[VERSION].png

Examples:
SPRING01_thumb_v1.png       # Tutorial
BALI01_thumb_v2.png         # Vlog
DEVTALK_EP42_thumb_v1.png   # Podcast
TIP01_cover_instagram.png   # Shorts
```

## Tools

| Tool | Best For | Platform |
|------|----------|----------|
| Canva | Quick templates | Web |
| Figma | Reusable components | Web/Desktop |
| Photoshop | Advanced editing | Desktop |
| DaVinci | Frame extraction | Desktop |

## Workflow

1. Export key frame from video (if using video still)
2. Open template in design tool
3. Replace placeholder with your image
4. Customize text (title, episode, etc.)
5. Export as PNG, max 2MB
6. Test readability at small size
7. Save to project's `04-assets/thumbnails/`
