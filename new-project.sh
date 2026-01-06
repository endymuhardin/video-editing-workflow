#!/bin/bash

# Create new video project from template
# Usage: ./new-project.sh PROJECT_CODE [DESCRIPTION]
# Example: ./new-project.sh SPRING01 "Spring Boot Tutorial Part 1"

if [ -z "$1" ]; then
    echo "Error: Project code required"
    echo "Usage: ./new-project.sh PROJECT_CODE [DESCRIPTION]"
    echo "Example: ./new-project.sh SPRING01 \"Spring Boot Tutorial Part 1\""
    exit 1
fi

PROJECT_CODE="$1"
DESCRIPTION="${2:-No description}"
DATE=$(date +%Y-%m-%d)
PROJECT_DIR="projects/${DATE}_${PROJECT_CODE}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if project already exists
if [ -d "$SCRIPT_DIR/$PROJECT_DIR" ]; then
    echo "Error: Project directory already exists: $PROJECT_DIR"
    exit 1
fi

# Create project from template
echo "Creating project: $PROJECT_DIR"
cp -r "$SCRIPT_DIR/template" "$SCRIPT_DIR/$PROJECT_DIR"

# Create project info file
cat > "$SCRIPT_DIR/$PROJECT_DIR/PROJECT-INFO.md" << EOF
# Project: $PROJECT_CODE

- **Created**: $DATE
- **Description**: $DESCRIPTION
- **Status**: In Progress

## Notes

[Add production notes here]

## Publish Checklist

- [ ] YouTube (long-form)
- [ ] YouTube Shorts
- [ ] Instagram Reels
- [ ] TikTok
EOF

# Update OBS recording path placeholder
sed -i '' "s|/path/to/project|$SCRIPT_DIR/$PROJECT_DIR|g" "$SCRIPT_DIR/$PROJECT_DIR/OBS-SETUP.md" 2>/dev/null || true

echo "Project created: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "1. Configure OBS recording path to: $SCRIPT_DIR/$PROJECT_DIR/01-raw/"
echo "2. Start recording"
echo ""
ls -la "$SCRIPT_DIR/$PROJECT_DIR"
