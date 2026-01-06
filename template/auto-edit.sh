#!/bin/bash

# Auto-editor script for removing silences and filler
# Usage: ./auto-edit.sh [OPTIONS]
#
# Options:
#   --margin SECONDS    Padding around cuts (default: 0.1)
#   --threshold DB      Audio threshold for silence (default: 4%)
#   --preview           Preview without exporting
#   --export FORMAT     Export format: davinci, premiere, fcpxml (default: davinci)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RAW_DIR="$SCRIPT_DIR/01-raw"
OUTPUT_DIR="$SCRIPT_DIR/03-project/auto-editor"

# Find and activate venv
VENV_PATHS=(
    "$SCRIPT_DIR/../../venv/bin/activate"      # From project folder
    "$SCRIPT_DIR/../venv/bin/activate"         # From template folder
    "$SCRIPT_DIR/venv/bin/activate"            # Local venv
)

VENV_FOUND=false
for VENV_PATH in "${VENV_PATHS[@]}"; do
    if [ -f "$VENV_PATH" ]; then
        source "$VENV_PATH"
        VENV_FOUND=true
        break
    fi
done

if [ "$VENV_FOUND" = false ]; then
    echo "Warning: venv not found, using system Python"
fi

# Default settings
MARGIN="0.1sec"
THRESHOLD="4%"
EXPORT_FORMAT="davinci"
PREVIEW_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --margin)
            MARGIN="$2"
            shift 2
            ;;
        --threshold)
            THRESHOLD="$2"
            shift 2
            ;;
        --preview)
            PREVIEW_MODE=true
            shift
            ;;
        --export)
            EXPORT_FORMAT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if auto-editor is installed
if ! command -v auto-editor &> /dev/null; then
    echo "Error: auto-editor not installed"
    echo "Install with: pip install auto-editor"
    exit 1
fi

# Find all video files in raw directories
VIDEO_FILES=$(find "$RAW_DIR" -type f \( -name "*.mov" -o -name "*.mp4" -o -name "*.mkv" -o -name "*.avi" \) 2>/dev/null)

if [ -z "$VIDEO_FILES" ]; then
    echo "Error: No video files found in $RAW_DIR"
    echo "Supported formats: .mov, .mp4, .mkv, .avi"
    exit 1
fi

echo "=== Auto-Editor Processing ==="
echo "Margin: $MARGIN"
echo "Threshold: $THRESHOLD"
echo "Export format: $EXPORT_FORMAT"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Process each video file
for VIDEO in $VIDEO_FILES; do
    FILENAME=$(basename "$VIDEO")
    BASENAME="${FILENAME%.*}"

    echo "Processing: $FILENAME"

    if [ "$PREVIEW_MODE" = true ]; then
        # Preview mode - shows edit timeline without exporting
        auto-editor "$VIDEO" \
            --margin "$MARGIN" \
            --edit "audio:threshold=$THRESHOLD" \
            --preview
    else
        # Export mode
        case $EXPORT_FORMAT in
            davinci)
                # Export as XML for DaVinci Resolve
                auto-editor "$VIDEO" \
                    --margin "$MARGIN" \
                    --edit "audio:threshold=$THRESHOLD" \
                    --export davinci \
                    --output "$OUTPUT_DIR/${BASENAME}_edited.xml"
                echo "  -> Exported: ${BASENAME}_edited.xml"
                ;;
            premiere)
                # Export as XML for Premiere Pro
                auto-editor "$VIDEO" \
                    --margin "$MARGIN" \
                    --edit "audio:threshold=$THRESHOLD" \
                    --export premiere \
                    --output "$OUTPUT_DIR/${BASENAME}_edited.xml"
                echo "  -> Exported: ${BASENAME}_edited.xml"
                ;;
            fcpxml)
                # Export as FCPXML for Final Cut Pro
                auto-editor "$VIDEO" \
                    --margin "$MARGIN" \
                    --edit "audio:threshold=$THRESHOLD" \
                    --export final-cut-pro \
                    --output "$OUTPUT_DIR/${BASENAME}_edited.fcpxml"
                echo "  -> Exported: ${BASENAME}_edited.fcpxml"
                ;;
            video)
                # Export as new video file (re-encoded)
                auto-editor "$VIDEO" \
                    --margin "$MARGIN" \
                    --edit "audio:threshold=$THRESHOLD" \
                    --output "$OUTPUT_DIR/${BASENAME}_edited.mp4"
                echo "  -> Exported: ${BASENAME}_edited.mp4"
                ;;
            *)
                echo "Error: Unknown export format: $EXPORT_FORMAT"
                exit 1
                ;;
        esac
    fi

    echo ""
done

echo "=== Processing Complete ==="
echo ""
echo "Next steps:"
echo "1. Open DaVinci Resolve"
echo "2. File > Import > Timeline (or drag XML into Media Pool)"
echo "3. Import the original video files when prompted"
echo "4. Fine-tune the cuts as needed"
