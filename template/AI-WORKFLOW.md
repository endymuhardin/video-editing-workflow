# AI-Assisted Video Production Workflow

Guide for using AI tools throughout the video production pipeline.

## Overview

```
Planning          Production        Editing           Publishing
   │                  │                │                  │
   ▼                  ▼                ▼                  ▼
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ Claude  │     │ AI Image│     │ DaVinci │     │ Claude  │
│ ChatGPT │     │ Gen     │     │ AI      │     │ ChatGPT │
└─────────┘     └─────────┘     └─────────┘     └─────────┘
     │               │               │               │
     ▼               ▼               ▼               ▼
  Script          Graphics       Captions         Metadata
  Outline         B-Roll         Voice ISO        Descriptions
  Research        Thumbnails     Scene Cut        Social Posts
  Shotlist                       Magic Mask       SEO Tags
```

---

## Phase 1: Planning

### Script Generation

**Prompt template for tutorial scripts:**
```
I'm creating a programming tutorial video about [TOPIC].

Target audience: [beginner/intermediate/advanced] developers
Video length: [X] minutes
Style: [hands-on coding / conceptual explanation / project-based]

Please help me create:
1. A hook/intro (30 seconds) that explains why this matters
2. Prerequisites list
3. Main sections with:
   - Key points to cover
   - Code examples to demonstrate
   - Common mistakes to mention
4. Summary/outro with next steps

Focus on practical, actionable content. Avoid filler.
```

**Prompt for improving existing scripts:**
```
Review this tutorial script for:
1. Logical flow - does each section build on the previous?
2. Missing explanations - where might viewers get confused?
3. Unnecessary content - what can be cut?
4. Engagement - where might viewers drop off?

Script:
[PASTE SCRIPT]
```

### Outline Refinement

**Prompt for topic breakdown:**
```
I want to teach [TOPIC] in a YouTube tutorial.

Break this down into:
1. What concepts must be explained first (prerequisites)
2. Core concepts in learning order
3. Practical demonstration sequence
4. Edge cases worth mentioning
5. What to explicitly skip (scope boundaries)

Keep it focused - this is a [X] minute video, not a course.
```

### Research Assistance

**Prompt for technical accuracy:**
```
I'm explaining [CONCEPT] in a tutorial. Verify my understanding:

[YOUR EXPLANATION]

Point out any:
1. Technical inaccuracies
2. Outdated information
3. Missing important caveats
4. Better ways to explain this
```

**Prompt for code review:**
```
Review this code I'll demonstrate in a tutorial:

[CODE]

Check for:
1. Best practices violations
2. Security issues
3. Performance concerns
4. Clearer alternatives
5. Missing error handling viewers should know about
```

### Shot List Generation

**Prompt for footage planning:**
```
Based on this tutorial outline, suggest footage types for each section:

[OUTLINE]

Use these codes:
- TH = Talking Head (explaining concepts)
- SC = Screen Capture (showing code/browser)
- TH+SC = Picture-in-picture (guided walkthrough)
- BR = B-Roll (transitions, emphasis)
- GFX = Graphics/diagrams

Output as a table with: Section | Duration | Primary | Secondary | Notes
```

---

## Phase 2: Production

### Graphics Generation

**AI image tools:** Midjourney, DALL-E, Stable Diffusion, Ideogram

**Prompt for architecture diagrams:**
```
Create a clean, minimal technical diagram showing:
[DESCRIPTION]

Style: flat design, dark background (#1a1a2e), accent color (#4361ee)
No text labels (I'll add them in post)
Simple shapes, clear hierarchy
```

**Prompt for thumbnail concepts:**
```
YouTube thumbnail concept for: "[VIDEO TITLE]"

Elements needed:
- Main visual that represents [TOPIC]
- Space for text overlay (left or right third)
- High contrast, readable at small sizes
- Style: [modern/minimal/bold]

Suggest 3 different visual approaches.
```

### Code Snippet Preparation

**Prompt for demo code:**
```
Generate a minimal, working example demonstrating [CONCEPT].

Requirements:
- Remove all unnecessary code
- Add only essential comments
- Use clear variable names
- Should run without modification
- Include sample input/output

Language: [LANGUAGE]
```

---

## Phase 3: Editing

### DaVinci Resolve AI Features

**Built-in AI tools (no external AI needed):**

| Feature | Location | Use Case |
|---------|----------|----------|
| Auto Subtitle | Edit > Auto-Generate Subtitles | Generate captions from speech |
| Voice Isolation | Fairlight > Effects > Voice Isolation | Remove background noise |
| Scene Cut Detection | Right-click clip > Scene Cut Detection | Auto-split long recordings |
| IntelliTrack | Color > Tracker | Track objects for effects |
| Magic Mask | Color > Magic Mask | AI subject isolation |
| Super Scale | Project Settings > Super Scale | Upscale footage (Studio) |

**Auto Subtitle workflow:**
1. Select clip in timeline
2. Timeline > Auto-Generate Subtitles
3. Choose language and quality
4. Edit generated text in Subtitle track
5. Export as SRT: File > Export > Subtitle

**Voice Isolation settings:**
```
Amount: 50-80% (higher = more isolation, may sound artificial)
Use when: Background noise, room echo, keyboard sounds
```

### Caption Editing with AI

**Prompt for caption cleanup:**
```
Clean up these auto-generated captions:

[PASTE SRT CONTENT]

Fix:
1. Technical terms and code references
2. Punctuation and sentence breaks
3. Remove filler words (um, uh, like)
4. Fix timing for readability (max 2 lines, 42 chars/line)

Keep the SRT format with timestamps.
```

### Chapter Markers

**Prompt for YouTube chapters:**
```
Based on this video transcript, suggest YouTube chapter markers:

[TRANSCRIPT OR OUTLINE]

Format:
0:00 Intro
X:XX Section name
...

Rules:
- First chapter must be 0:00
- Minimum 10 seconds per chapter
- Chapter names max 100 characters
- At least 3 chapters total
```

---

## Phase 4: Publishing

### Title Generation

**Prompt for YouTube titles:**
```
Generate 5 YouTube title options for this tutorial:

Topic: [TOPIC]
Key benefit: [WHAT VIEWER LEARNS]
Target audience: [WHO]

Requirements:
- Under 60 characters
- Include primary keyword near start
- Create curiosity or promise value
- No clickbait - must deliver on promise

Current best-performing title style in my niche: [EXAMPLE]
```

### Description Writing

**Prompt for video description:**
```
Write a YouTube description for: "[VIDEO TITLE]"

Include:
1. First 2 lines: Hook + what they'll learn (visible before "Show more")
2. Timestamps/chapters (I'll provide)
3. Key topics covered (for SEO)
4. Links section placeholder
5. Brief about me (1 line)

Tone: Professional but approachable
Length: 200-300 words
Include relevant keywords naturally: [KEYWORDS]
```

### Tags and SEO

**Prompt for tags:**
```
Generate YouTube tags for: "[VIDEO TITLE]"

Primary topic: [MAIN KEYWORD]
Related topics: [RELATED KEYWORDS]
Tools/technologies shown: [TOOLS]

Output:
1. 5 high-volume tags (main keywords)
2. 5 medium-tail tags (specific phrases)
3. 5 long-tail tags (question-based)

Format as comma-separated list.
```

### Social Media Posts

**Prompt for Twitter/X thread:**
```
Create a Twitter thread announcing this video: "[VIDEO TITLE]"

Thread structure:
1. Hook tweet - problem or question
2. What the video covers (bullet points)
3. Key insight or tip from the video
4. CTA with video link placeholder [LINK]

Keep each tweet under 280 chars.
Tone: [casual/professional]
```

**Prompt for LinkedIn post:**
```
Write a LinkedIn post for: "[VIDEO TITLE]"

Structure:
- Hook line (problem statement)
- What I cover in the video (brief)
- Key takeaway
- CTA to watch

Tone: Professional, educational
Length: 150-200 words
No hashtag spam (max 3 relevant tags)
```

### Thumbnail Text

**Prompt for thumbnail copy:**
```
Suggest thumbnail text options for: "[VIDEO TITLE]"

Requirements:
- Maximum 4 words
- Creates curiosity or tension
- Readable at small size
- Complements (not duplicates) title

Give 5 options with different angles:
1. Problem-focused
2. Solution-focused
3. Curiosity gap
4. Number/statistic
5. Emotion-driven
```

---

## Workflow Integration

### Project Checklist with AI

Add to `PROJECT-INFO.md`:

```markdown
## AI Assistance Checklist

### Planning
- [ ] Script reviewed by AI for accuracy
- [ ] Outline validated for logical flow
- [ ] Code examples reviewed for best practices
- [ ] Shot list generated

### Production
- [ ] Graphics/diagrams generated
- [ ] Demo code prepared and tested

### Editing
- [ ] Auto-captions generated
- [ ] Captions cleaned up
- [ ] Chapter markers created

### Publishing
- [ ] Title options generated
- [ ] Description written
- [ ] Tags researched
- [ ] Social posts drafted
- [ ] Thumbnail text options
```

### Prompt Library Location

Store reusable prompts in:
```
00-planning/
└── prompts/          # Personal prompt templates
    ├── script.md
    ├── review.md
    ├── seo.md
    └── social.md
```

---

## Tool Recommendations

| Phase | Tool | Use |
|-------|------|-----|
| Planning | Claude, ChatGPT | Scripts, outlines, research |
| Graphics | Midjourney, DALL-E | Diagrams, thumbnails |
| Captions | DaVinci Auto-Subtitle | Initial generation |
| Caption Edit | Claude | Cleanup and formatting |
| SEO | VidIQ, TubeBuddy + AI | Keyword research |
| Social | Claude, ChatGPT | Post drafting |

---

## Tips

1. **Always verify AI output** - Especially technical content and code
2. **Maintain your voice** - Use AI as starting point, not final draft
3. **Save working prompts** - Build a personal prompt library
4. **Batch similar tasks** - Generate all social posts at once
5. **Iterate on prompts** - Refine based on output quality
