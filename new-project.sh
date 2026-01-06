#!/bin/bash

# Create new video project from template
# Usage: ./new-project.sh PROJECT_CODE [CONTENT_TYPE] [DESCRIPTION]
# Example: ./new-project.sh SPRING01 coding-tutorial "Spring Boot Tutorial Part 1"

VALID_TYPES=("coding-tutorial" "vlog" "podcast" "shorts")

show_usage() {
    echo "Usage: ./new-project.sh PROJECT_CODE [CONTENT_TYPE] [DESCRIPTION]"
    echo ""
    echo "Content types:"
    echo "  coding-tutorial  - Programming tutorials (dark, professional)"
    echo "  vlog             - Personal vlogs (warm, casual)"
    echo "  podcast          - Video podcasts (branded, broadcast)"
    echo "  shorts           - Vertical short-form (YouTube/IG/FB)"
    echo ""
    echo "Examples:"
    echo "  ./new-project.sh SPRING01 coding-tutorial \"Spring Boot Tutorial\""
    echo "  ./new-project.sh BALI01 vlog \"Bali Trip Day 1\""
    echo "  ./new-project.sh EP42 podcast \"Interview with Dr. Smith\""
    echo "  ./new-project.sh TIP01 shorts \"Quick Git Tip\""
}

if [ -z "$1" ]; then
    echo "Error: Project code required"
    echo ""
    show_usage
    exit 1
fi

PROJECT_CODE="$1"
CONTENT_TYPE="$2"
DESCRIPTION="${3:-No description}"
DATE=$(date +%Y-%m-%d)
PROJECT_DIR="projects/${DATE}_${PROJECT_CODE}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Interactive content type selection if not provided
if [ -z "$CONTENT_TYPE" ]; then
    echo "Select content type:"
    echo ""
    echo "  1) coding-tutorial  - Programming tutorials"
    echo "  2) vlog             - Personal vlogs"
    echo "  3) podcast          - Video podcasts"
    echo "  4) shorts           - Vertical short-form"
    echo ""
    read -p "Enter choice [1-4]: " choice

    case $choice in
        1) CONTENT_TYPE="coding-tutorial" ;;
        2) CONTENT_TYPE="vlog" ;;
        3) CONTENT_TYPE="podcast" ;;
        4) CONTENT_TYPE="shorts" ;;
        *)
            echo "Error: Invalid choice"
            exit 1
            ;;
    esac

    # Ask for description if not provided
    if [ "$DESCRIPTION" = "No description" ]; then
        read -p "Enter project description: " DESCRIPTION
        [ -z "$DESCRIPTION" ] && DESCRIPTION="No description"
    fi
fi

# Validate content type
is_valid=false
for type in "${VALID_TYPES[@]}"; do
    if [ "$CONTENT_TYPE" = "$type" ]; then
        is_valid=true
        break
    fi
done

if [ "$is_valid" = false ]; then
    echo "Error: Invalid content type '$CONTENT_TYPE'"
    echo ""
    show_usage
    exit 1
fi

# Check if project already exists
if [ -d "$SCRIPT_DIR/$PROJECT_DIR" ]; then
    echo "Error: Project directory already exists: $PROJECT_DIR"
    exit 1
fi

# Create project from template
echo "Creating project: $PROJECT_DIR"
echo "Content type: $CONTENT_TYPE"
cp -r "$SCRIPT_DIR/template" "$SCRIPT_DIR/$PROJECT_DIR"

# Set publish checklist based on content type
case $CONTENT_TYPE in
    coding-tutorial)
        PUBLISH_CHECKLIST="- [ ] YouTube (long-form)
- [ ] YouTube Shorts (clips)
- [ ] Twitter/X announcement
- [ ] LinkedIn post"
        ;;
    vlog)
        PUBLISH_CHECKLIST="- [ ] YouTube (long-form)
- [ ] YouTube Shorts (highlights)
- [ ] Instagram Reels
- [ ] TikTok"
        ;;
    podcast)
        PUBLISH_CHECKLIST="- [ ] YouTube (full episode)
- [ ] Spotify
- [ ] Apple Podcasts
- [ ] YouTube Shorts (clips)
- [ ] Instagram Reels (clips)"
        ;;
    shorts)
        PUBLISH_CHECKLIST="- [ ] YouTube Shorts
- [ ] Instagram Reels
- [ ] TikTok
- [ ] Facebook Reels"
        ;;
esac

# Set metadata based on content type
case $CONTENT_TYPE in
    coding-tutorial)
        TARGET_LENGTH="10-20 minutes"
        TARGET_PLATFORM="YouTube (primary), YouTube Shorts (clips)"
        RESOLUTION="1920x1080 (master), 1080x1920 (shorts)"
        TONE="Professional, educational, technical"
        ;;
    vlog)
        TARGET_LENGTH="5-15 minutes"
        TARGET_PLATFORM="YouTube, Instagram Reels, TikTok"
        RESOLUTION="1920x1080 (master), 1080x1920 (shorts)"
        TONE="Personal, casual, authentic"
        ;;
    podcast)
        TARGET_LENGTH="30-60 minutes"
        TARGET_PLATFORM="YouTube, Spotify, Apple Podcasts"
        RESOLUTION="1920x1080"
        TONE="Conversational, informative, branded"
        ;;
    shorts)
        TARGET_LENGTH="15-60 seconds"
        TARGET_PLATFORM="YouTube Shorts, Instagram Reels, TikTok, Facebook Reels"
        RESOLUTION="1080x1920 (vertical)"
        TONE="Punchy, attention-grabbing, concise"
        ;;
esac

# Create project info file
cat > "$SCRIPT_DIR/$PROJECT_DIR/PROJECT-INFO.md" << EOF
# Project: $PROJECT_CODE

## Metadata

| Field | Value |
|-------|-------|
| Created | $DATE |
| Content Type | $CONTENT_TYPE |
| Description | $DESCRIPTION |
| Status | In Progress |
| Target Length | $TARGET_LENGTH |
| Target Platform | $TARGET_PLATFORM |
| Resolution | $RESOLUTION |
| Tone | $TONE |

## Topic

**Main Topic:** [What is this video about?]

**Key Points:**
- [Point 1]
- [Point 2]
- [Point 3]

**Target Audience:** [Who is this for?]

**Prerequisites:** [What should viewers know beforehand?]

## Planning

- [ ] Script/outline completed (00-planning/script/)
- [ ] Shot list prepared (00-planning/shotlist/)
- [ ] Demo code tested (00-planning/demo-code/)
- [ ] Graphics/diagrams prepared (04-assets/graphics/)

## Production

- [ ] Recording completed (01-raw/)
- [ ] Auto-editor silence removal (03-project/auto-editor/)
- [ ] DaVinci project created (03-project/davinci/)

## Post-Production

- [ ] Rough cut completed
- [ ] Lower thirds added (04-assets/lower-thirds/$CONTENT_TYPE/)
- [ ] Intro/outro bumpers (04-assets/bumpers/$CONTENT_TYPE/)
- [ ] B-roll/cutaways added
- [ ] Color grading applied
- [ ] Audio levels balanced
- [ ] Captions generated (06-captions/)
- [ ] Thumbnail created (04-assets/thumbnails/$CONTENT_TYPE/)

## Publish

$PUBLISH_CHECKLIST

## SEO (for YouTube)

**Title:** [Max 100 chars, keyword near start]

**Description:** [First 2 lines visible before "Show more"]

**Tags:** [Comma-separated keywords]

**Chapters:**
- 0:00 Intro
- [Add timestamps]

## Notes

[Add production notes, lessons learned, ideas for future videos]
EOF

# Update OBS recording path placeholder
sed -i '' "s|/path/to/project|$SCRIPT_DIR/$PROJECT_DIR|g" "$SCRIPT_DIR/$PROJECT_DIR/OBS-SETUP.md" 2>/dev/null || true

echo ""
echo "Project created: $PROJECT_DIR"
echo "Content type: $CONTENT_TYPE"
echo ""
echo "Assets ready in 04-assets/:"
echo "  - bumpers/$CONTENT_TYPE/"
echo "  - lower-thirds/$CONTENT_TYPE/"
echo "  - thumbnails/$CONTENT_TYPE/"
echo ""
echo "Next steps:"
echo "1. Plan in 00-planning/ (script, outline, shotlist)"
echo "2. Configure OBS recording path to: $SCRIPT_DIR/$PROJECT_DIR/01-raw/"
echo "3. Start recording"
