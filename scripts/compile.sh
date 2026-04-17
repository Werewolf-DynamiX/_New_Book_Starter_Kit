#!/bin/bash
# ============================================================
# compile.sh — Build manuscript to output formats
# Usage: bash scripts/compile.sh [all|md|epub|print|docx]
# Default target: all
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

TARGET="${1:-all}"

# --- Read slug from book.yaml (fallback: "manuscript") ---
SLUG="manuscript"
if [ -f "book.yaml" ]; then
    slug_line=$(grep -E '^slug:' book.yaml 2>/dev/null | head -1 || true)
    if [ -n "$slug_line" ]; then
        extracted=$(echo "$slug_line" | sed -E 's/^slug:[[:space:]]*"?([^"]*)"?[[:space:]]*$/\1/')
        [ -n "$extracted" ] && SLUG="$extracted"
    fi
fi

BUILD_DIR="build"
RELEASE_DIR="release"
MANUSCRIPT_MD="$RELEASE_DIR/$SLUG.md"
METADATA="$BUILD_DIR/metadata.yaml"

mkdir -p "$RELEASE_DIR"

# --- Pandoc check (required for epub/print/docx, not md) ---
require_pandoc() {
    if ! command -v pandoc >/dev/null 2>&1; then
        echo "ERROR: pandoc not found. Install pandoc first (https://pandoc.org/installing.html)"
        exit 1
    fi
}

# --- Compile the merged markdown manuscript ---
compile_md() {
    echo "1. Compiling manuscript markdown..."
    : > "$MANUSCRIPT_MD"

    # Front matter (sorted filenames)
    if [ -d "manuscript/front_matter" ]; then
        for f in $(find manuscript/front_matter -maxdepth 1 -name "*.md" -type f | sort); do
            cat "$f" >> "$MANUSCRIPT_MD"
            printf '\n\n' >> "$MANUSCRIPT_MD"
        done
    fi

    # Chapters: canonical override if present, else sorted glob
    if [ -f "$BUILD_DIR/canonical_chapters.txt" ]; then
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            case "$line" in \#*) continue ;; esac
            f="manuscript/chapters/$line"
            if [ -f "$f" ]; then
                cat "$f" >> "$MANUSCRIPT_MD"
                printf '\n\n' >> "$MANUSCRIPT_MD"
            else
                echo "   WARN: canonical_chapters.txt references missing file: $f"
            fi
        done < "$BUILD_DIR/canonical_chapters.txt"
    else
        for f in $(find manuscript/chapters -maxdepth 1 -name "*.md" -type f | sort); do
            cat "$f" >> "$MANUSCRIPT_MD"
            printf '\n\n' >> "$MANUSCRIPT_MD"
        done
    fi

    # Back matter (sorted filenames)
    if [ -d "manuscript/back_matter" ]; then
        for f in $(find manuscript/back_matter -maxdepth 1 -name "*.md" -type f | sort); do
            cat "$f" >> "$MANUSCRIPT_MD"
            printf '\n\n' >> "$MANUSCRIPT_MD"
        done
    fi

    lines=$(wc -l < "$MANUSCRIPT_MD")
    echo "   - $MANUSCRIPT_MD ($lines lines)"
}

compile_epub() {
    require_pandoc
    echo "2. Building EPUB..."
    pandoc "$MANUSCRIPT_MD" \
        -o "$RELEASE_DIR/$SLUG.epub" \
        --metadata-file="$METADATA" \
        --css="$BUILD_DIR/epub.css" \
        --toc --toc-depth=1
    echo "   - $RELEASE_DIR/$SLUG.epub"
}

compile_print() {
    require_pandoc
    echo "3. Building PDF (6x9 trade paperback)..."
    pandoc "$MANUSCRIPT_MD" \
        --pdf-engine=lualatex \
        --include-in-header="$BUILD_DIR/print.latex" \
        --metadata-file="$METADATA" \
        --top-level-division=chapter \
        -V documentclass=book \
        -V classoption=openany \
        -V fontsize=11pt \
        -V mainfont="TeX Gyre Pagella" \
        -V mainfontoptions="Ligatures=TeX,Numbers=OldStyle" \
        -V sansfont="TeX Gyre Heros" \
        -V sansfontoptions="Ligatures=TeX,Scale=MatchLowercase" \
        -V monofont="DejaVu Sans Mono" \
        -V monofontoptions="Scale=MatchLowercase" \
        -V linestretch=1.08 \
        -V microtype=true \
        -V microtypeoptions="activate={true,nocompatibility},final,tracking=true,protrusion=true,expansion=true,factor=1100,stretch=10,shrink=10" \
        -V geometry="paperwidth=6in,paperheight=9in,inner=0.75in,outer=0.5in,top=0.75in,bottom=0.75in" \
        -V colorlinks=true \
        -V linkcolor=linkgray \
        -V toccolor=linkgray \
        -V urlcolor=linkgray \
        -V lang=en-US \
        --from=markdown+smart+raw_html+raw_tex \
        -o "$RELEASE_DIR/$SLUG.pdf"
    echo "   - $RELEASE_DIR/$SLUG.pdf"
}

compile_docx() {
    require_pandoc
    echo "4. Building DOCX..."
    pandoc "$MANUSCRIPT_MD" \
        -o "$RELEASE_DIR/$SLUG.docx" \
        --metadata-file="$METADATA" \
        --toc --toc-depth=1
    echo "   - $RELEASE_DIR/$SLUG.docx"
}

case "$TARGET" in
    md)    compile_md ;;
    epub)  compile_md; compile_epub ;;
    print) compile_md; compile_print ;;
    docx)  compile_md; compile_docx ;;
    all)   compile_md; compile_epub; compile_print; compile_docx ;;
    *)     echo "Usage: $0 [all|md|epub|print|docx]"; exit 1 ;;
esac

echo ""
echo "Build complete. Artifacts in $RELEASE_DIR/"
