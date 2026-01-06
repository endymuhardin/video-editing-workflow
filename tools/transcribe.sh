#!/bin/bash

# Transcribe video using Whisper
# Usage: ./tools/transcribe.sh <video_file> [output_dir]
# Requires: whisper (pip install openai-whisper) or whisper.cpp

set -e

if [ -z "$1" ]; then
    echo "Usage: ./tools/transcribe.sh <video_file> [output_dir]"
    echo ""
    echo "Example:"
    echo "  ./tools/transcribe.sh 01-raw/camera/video.mov"
    echo "  ./tools/transcribe.sh 01-raw/camera/video.mov 03-project/ai-analysis"
    exit 1
fi

VIDEO_FILE="$1"
OUTPUT_DIR="${2:-03-project/ai-analysis}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Check if video file exists
if [ ! -f "$VIDEO_FILE" ]; then
    echo "Error: Video file not found: $VIDEO_FILE"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Extract filename without extension
BASENAME=$(basename "$VIDEO_FILE" | sed 's/\.[^.]*$//')

echo "Transcribing: $VIDEO_FILE"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Check for whisper installation
if command -v whisper &> /dev/null; then
    echo "Using OpenAI Whisper..."

    # Run whisper with word-level timestamps
    whisper "$VIDEO_FILE" \
        --model medium \
        --language id \
        --output_dir "$OUTPUT_DIR" \
        --output_format all \
        --word_timestamps True \
        --verbose False

    echo ""
    echo "Transcription complete!"
    echo "Output files:"
    echo "  - $OUTPUT_DIR/${BASENAME}.txt   (plain text)"
    echo "  - $OUTPUT_DIR/${BASENAME}.srt   (subtitles)"
    echo "  - $OUTPUT_DIR/${BASENAME}.json  (word-level timestamps)"
    echo "  - $OUTPUT_DIR/${BASENAME}.vtt   (web subtitles)"

elif command -v whisper-cpp &> /dev/null; then
    echo "Using whisper.cpp..."

    # Extract audio first
    AUDIO_FILE="$OUTPUT_DIR/${BASENAME}.wav"
    ffmpeg -i "$VIDEO_FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$AUDIO_FILE" -y -loglevel error

    # Run whisper.cpp
    whisper-cpp -m /usr/local/share/whisper/ggml-medium.bin \
        -f "$AUDIO_FILE" \
        -l id \
        -otxt -osrt -ojson \
        -of "$OUTPUT_DIR/$BASENAME"

    # Cleanup temp audio
    rm "$AUDIO_FILE"

    echo ""
    echo "Transcription complete!"

else
    echo "Error: Whisper not found."
    echo ""
    echo "Install options:"
    echo "  1. OpenAI Whisper: pip install openai-whisper"
    echo "  2. whisper.cpp:    brew install whisper-cpp"
    echo ""
    echo "Or use the API version: ./tools/transcribe-api.sh"
    exit 1
fi

echo ""
echo "Next step: ./tools/analyze.py $OUTPUT_DIR/${BASENAME}.json"
