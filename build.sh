#!/bin/bash

# Exit on error
set -e

# Setup cleanup trap to ensure temporary files are removed on exit/failure
cleanup() {
    rm -f output/merged.md "$TEMP_METADATA" "$TEMP_METADATA.tmp"
}
trap cleanup EXIT

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Asset Downloader Function (for Metadata) ---
# Note: Chapter images are now handled by __scripts/download-images.lua
download_asset() {
    local url=$1
    local extension="${url##*.}"
    if command -v md5sum >/dev/null 2>&1; then
        local safe_name=$(echo -n "$url" | md5sum | cut -d' ' -f1)
    else
        local safe_name=$(echo -n "$url" | md5)
    fi
    local local_path=".cache/images/${safe_name}.${extension}"

    if [ ! -f "$local_path" ]; then
        echo -e "  📥 Downloading (Metadata): $url" >&2
        curl -s -L "$url" -o "$local_path" || { echo -e "${RED}❌ Failed to download $url${NC}" >&2; return 1; }
    fi
    echo "$local_path"
}

echo -e "${BLUE}${BOLD}🚀 Starting book build process...${NC}"

# Create required directories
mkdir -p output
mkdir -p .cache/images

# --- Handle remote images in metadata.yml ---
TEMP_METADATA="output/metadata.tmp.yml"
cp metadata.yml "$TEMP_METADATA"

REMOTE_URLS=$(grep -oE 'https?://[^" ]+\.(png|jpg|jpeg|pdf)' metadata.yml | sort -u)

for url in $REMOTE_URLS; do
    local_path=$(download_asset "$url")
    sed "s|$url|$local_path|g" "$TEMP_METADATA" > "$TEMP_METADATA.tmp" && mv "$TEMP_METADATA.tmp" "$TEMP_METADATA"
done
# --------------------------------------------

# --- Meta Page Handler Function ---
# Adds a meta page to FILES array, prioritizing .tex over .md if both exist
add_meta_page() {
    local page=$1
    if [ -f "meta/${page}.tex" ]; then
        FILES+=("meta/${page}.tex")
        echo -e "  📄 Adding ${page}.tex"
    elif [ -f "meta/${page}.md" ]; then
        FILES+=("meta/${page}.md")
        echo -e "  📄 Adding ${page}.md"
    fi
}

# Initialize FILES array conditionally based on existing meta pages
FILES=()
PREAMBLE_PAGES="cover title-copyright dedication toc preface introduction"

echo -e "${YELLOW}📁 Processing Pre-amble...${NC}"
for page in $PREAMBLE_PAGES; do
    add_meta_page "$page"
done

# Dynamically find all chapters and their markdown files in order
# ... (rest of the chapter discovery logic remains)
for chapter in $(ls -d chapters/chapter-* 2>/dev/null | sort -V); do
  echo -e "${YELLOW}📁 Processing $(basename "$chapter")...${NC}"
  for file in $(ls "$chapter"/*.md 2>/dev/null | sort -V); do
    FILES+=("$file")
    echo -e "  📄 Adding $(basename "$file")"
  done
done

# Add closing pages
echo -e "${YELLOW}📁 Processing Post-amble...${NC}"
POSTAMBLE_PAGES="conclusion about-author"
for page in $POSTAMBLE_PAGES; do
    add_meta_page "$page"
done

echo -e "\n${BLUE}🔄 Merging files and fixing image paths...${NC}"

# Merge all files and fix relative assets paths (../../assets -> assets)
# Remote chapter images are now handled by the Lua filter during Pandoc execution
for f in "${FILES[@]}"; do
  cat "$f"
  echo -e "\n"
done | sed 's/\.\.\/\.\.\/assets/assets/g' > output/merged.md

echo -e "${BLUE}🎨 Converting to PDF using Pandoc & Eisvogel template...${NC}"

# --- Extract and Sanitize Title for Filename ---
TITLE=$(grep '^title:' metadata.yml | head -n 1 | sed 's/title: //;s/"//g;s/'"'"'//g')
if [ -z "$TITLE" ]; then
    BOOK_FILENAME="book.pdf"
else
    # Convert to lowercase, replace spaces with hyphens, remove special characters
    BOOK_FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | tr -cd '[:alnum:]-').pdf
fi

# Run pandoc to convert to PDF
# We use the download-images.lua filter to intelligently handle remote content images
pandoc output/merged.md \
  --metadata-file="$TEMP_METADATA" \
  --filter ./node_modules/.bin/mermaid-filter \
  --lua-filter ./__scripts/download-images.lua \
  --template=templates/eisvogel.tex \
  --syntax-highlighting=breezedark \
  --top-level-division=chapter \
  --number-sections \
  -o "output/$BOOK_FILENAME"

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✨ Build complete!${NC}"
    echo -e "${GREEN}📖 The PDF has been created at: ${BOLD}output/$BOOK_FILENAME${NC}\n"
else
    echo -e "\n${RED}${BOLD}❌ Build failed!${NC}"
    echo -e "${RED}Check the error messages above for details.${NC}\n"
    exit 1
fi
