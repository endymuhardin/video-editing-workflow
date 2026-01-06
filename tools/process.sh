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

# Determine API to use
API_FLAG=""
if [ -n "$ANTHROPIC_API_KEY" ]; then
    API_FLAG="--api anthropic"
elif [ -n "$OPENAI_API_KEY" ]; then
    API_FLAG="--api openai"
elif command -v gemini &> /dev/null; then
    API_FLAG="--api gemini"
elif curl -s http://localhost:11434/api/tags &> /dev/null; then
    API_FLAG="--api local"
else
    # Default: generate prompt for manual use
    API_FLAG="--api prompt"
fi

python3 "$SCRIPT_DIR/analyze.py" "$TRANSCRIPT_JSON" \
    $API_FLAG \
    --content-type "$CONTENT_TYPE" \
    --output-dir "$OUTPUT_DIR"

ANALYSIS_JSON="$OUTPUT_DIR/analysis.json"

# If prompt mode, stop here and give instructions
if [ "$API_FLAG" = "--api prompt" ]; then
    echo ""
    echo "========================================"
    echo "Manual Analysis Required"
    echo "========================================"
    echo ""
    echo "No API key found. A prompt file has been generated."
    echo ""
    echo "Options:"
    echo "  1. Ask Claude Code to analyze the transcript:"
    echo "     'Analyze the transcript at $TRANSCRIPT_JSON for a $CONTENT_TYPE video'"
    echo ""
    echo "  2. Use gemini-cli (install: npm install -g @anthropic-ai/claude-cli):"
    echo "     gemini -p $OUTPUT_DIR/${BASENAME}_analysis_prompt.md > $ANALYSIS_JSON"
    echo ""
    echo "  3. Copy prompt to Claude.ai/ChatGPT/Gemini and save response to:"
    echo "     $ANALYSIS_JSON"
    echo ""
    echo "After getting analysis.json, run:"
    echo "  ./tools/analyze.py --from-json $ANALYSIS_JSON"
    echo "  ./tools/autocut.py $VIDEO_FILE -t $TRANSCRIPT_JSON -a $ANALYSIS_JSON"
    exit 0
fi

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
