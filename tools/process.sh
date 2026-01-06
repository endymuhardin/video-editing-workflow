#!/bin/bash

# Full AI-assisted video processing pipeline
# Usage: ./tools/process.sh <video_file> [content_type]
# Example: ./tools/process.sh 01-raw/camera/video.mov coding-tutorial

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$1" ]; then
    echo "AI-Assisted Video Processing Pipeline"
    echo ""
    echo "Usage: ./tools/process.sh <video_file> [content_type]"
    echo ""
    echo "Content types: coding-tutorial, vlog, podcast, shorts"
    echo ""
    echo "Example:"
    echo "  ./tools/process.sh 01-raw/camera/video.mov coding-tutorial"
    echo ""
    echo "Pipeline:"
    echo "  1. Transcribe (Whisper)"
    echo "  2. AI Analysis (visual recommendations, cuts)"
    echo "  3. Auto-cut (generate EDL/XML)"
    echo ""
    echo "Output: 03-project/ai-analysis/"
    exit 1
fi

VIDEO_FILE="$1"
CONTENT_TYPE="${2:-coding-tutorial}"
OUTPUT_DIR="03-project/ai-analysis"

# Validate video file
if [ ! -f "$VIDEO_FILE" ]; then
    echo "Error: Video file not found: $VIDEO_FILE"
    exit 1
fi

# Extract basename
BASENAME=$(basename "$VIDEO_FILE" | sed 's/\.[^.]*$//')

echo "========================================"
echo "AI-Assisted Video Processing Pipeline"
echo "========================================"
echo ""
echo "Video: $VIDEO_FILE"
echo "Content Type: $CONTENT_TYPE"
echo "Output: $OUTPUT_DIR"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Step 1: Transcription
echo "========================================"
echo "Step 1/3: Transcription (Whisper)"
echo "========================================"
"$SCRIPT_DIR/transcribe.sh" "$VIDEO_FILE" "$OUTPUT_DIR"

TRANSCRIPT_JSON="$OUTPUT_DIR/${BASENAME}.json"

if [ ! -f "$TRANSCRIPT_JSON" ]; then
    echo "Error: Transcription failed - no JSON output"
    exit 1
fi

echo ""

# Step 2: AI Analysis
echo "========================================"
echo "Step 2/3: AI Analysis"
echo "========================================"

# Check for API key
if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ]; then
    echo "Warning: No API key found (ANTHROPIC_API_KEY or OPENAI_API_KEY)"
    echo "Trying local Ollama..."
    API_FLAG="--api local"
else
    if [ -n "$ANTHROPIC_API_KEY" ]; then
        API_FLAG="--api anthropic"
    else
        API_FLAG="--api openai"
    fi
fi

python3 "$SCRIPT_DIR/analyze.py" "$TRANSCRIPT_JSON" \
    $API_FLAG \
    --content-type "$CONTENT_TYPE" \
    --output-dir "$OUTPUT_DIR"

ANALYSIS_JSON="$OUTPUT_DIR/analysis.json"

echo ""

# Step 3: Auto-cut
echo "========================================"
echo "Step 3/3: Auto-cut (EDL/XML generation)"
echo "========================================"

python3 "$SCRIPT_DIR/autocut.py" "$VIDEO_FILE" \
    --transcript "$TRANSCRIPT_JSON" \
    --analysis "$ANALYSIS_JSON" \
    --output-dir "$OUTPUT_DIR"

echo ""
echo "========================================"
echo "Pipeline Complete!"
echo "========================================"
echo ""
echo "Output files in $OUTPUT_DIR/:"
echo ""
ls -la "$OUTPUT_DIR/"
echo ""
echo "Next steps:"
echo "  1. Review visual-recommendations.md"
echo "  2. Prepare required graphics/b-roll"
echo "  3. Import ${BASENAME}.edl or ${BASENAME}.fcpxml into DaVinci Resolve"
echo "  4. Add lower thirds from lower-thirds.csv"
echo "  5. Use chapters.md for YouTube description"
