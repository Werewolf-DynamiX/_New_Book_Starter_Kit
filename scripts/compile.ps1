# ============================================================
# compile.ps1 - Build manuscript to output formats (Windows/PowerShell)
# Usage: powershell -File scripts/compile.ps1 [all|md|epub|print|docx]
# ============================================================
param(
    [Parameter(Position=0)]
    [ValidateSet("all", "md", "epub", "print", "docx")]
    [string]$Target = "all"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

# --- Read slug from book.yaml (fallback: "manuscript") ---
$Slug = "manuscript"
if (Test-Path "book.yaml") {
    $m = Select-String -Path "book.yaml" -Pattern '^slug:\s*"?([^"]+)"?' | Select-Object -First 1
    if ($m) { $Slug = $m.Matches[0].Groups[1].Value.Trim() }
}

$BuildDir = "build"
$ReleaseDir = "release"
$MdOut = "$ReleaseDir/$Slug.md"
$Metadata = "$BuildDir/metadata.yaml"

New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null

function Require-Pandoc {
    if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
        Write-Host "ERROR: pandoc not found. Install pandoc first (https://pandoc.org/installing.html)"
        exit 1
    }
}

function Compile-Md {
    Write-Host "1. Compiling manuscript markdown..."
    $parts = @()

    if (Test-Path "manuscript/front_matter") {
        $parts += (Get-ChildItem "manuscript/front_matter/*.md" | Sort-Object Name)
    }

    if (Test-Path "$BuildDir/canonical_chapters.txt") {
        $lines = Get-Content "$BuildDir/canonical_chapters.txt" | Where-Object {
            $_ -and -not $_.TrimStart().StartsWith("#")
        }
        foreach ($line in $lines) {
            $path = "manuscript/chapters/$($line.Trim())"
            if (Test-Path $path) { $parts += (Get-Item $path) }
            else { Write-Host "   WARN: canonical_chapters.txt references missing file: $path" }
        }
    } else {
        $parts += (Get-ChildItem "manuscript/chapters/*.md" | Sort-Object Name)
    }

    if (Test-Path "manuscript/back_matter") {
        $parts += (Get-ChildItem "manuscript/back_matter/*.md" | Sort-Object Name)
    }

    $content = @()
    foreach ($f in $parts) {
        $content += Get-Content $f.FullName
        $content += ""
    }
    $content | Set-Content $MdOut
    Write-Host "   - $MdOut"
}

function Compile-Epub {
    Require-Pandoc
    Write-Host "2. Building EPUB..."
    pandoc $MdOut `
        -o "$ReleaseDir/$Slug.epub" `
        --metadata-file=$Metadata `
        --css="$BuildDir/epub.css" `
        --toc --toc-depth=1
    if ($LASTEXITCODE -ne 0) { throw "EPUB build failed" }
    Write-Host "   - $ReleaseDir/$Slug.epub"
}

function Compile-Print {
    Require-Pandoc
    Write-Host "3. Building PDF (6x9 trade paperback)..."
    pandoc $MdOut `
        --pdf-engine=lualatex `
        --include-in-header="$BuildDir/print.latex" `
        --metadata-file=$Metadata `
        --top-level-division=chapter `
        -V documentclass=book `
        -V classoption=openany `
        -V fontsize=11pt `
        -V mainfont="TeX Gyre Pagella" `
        -V "mainfontoptions=Ligatures=TeX,Numbers=OldStyle" `
        -V sansfont="TeX Gyre Heros" `
        -V "sansfontoptions=Ligatures=TeX,Scale=MatchLowercase" `
        -V monofont="DejaVu Sans Mono" `
        -V "monofontoptions=Scale=MatchLowercase" `
        -V linestretch=1.08 `
        -V microtype=true `
        -V "geometry=paperwidth=6in,paperheight=9in,inner=0.75in,outer=0.5in,top=0.75in,bottom=0.75in" `
        -V colorlinks=true `
        -V linkcolor=linkgray `
        -V toccolor=linkgray `
        -V urlcolor=linkgray `
        -V lang=en-US `
        --from=markdown+smart+raw_html+raw_tex `
        -o "$ReleaseDir/$Slug.pdf"
    if ($LASTEXITCODE -ne 0) { throw "PDF build failed" }
    Write-Host "   - $ReleaseDir/$Slug.pdf"
}

function Compile-Docx {
    Require-Pandoc
    Write-Host "4. Building DOCX..."
    pandoc $MdOut `
        -o "$ReleaseDir/$Slug.docx" `
        --metadata-file=$Metadata `
        --toc --toc-depth=1
    if ($LASTEXITCODE -ne 0) { throw "DOCX build failed" }
    Write-Host "   - $ReleaseDir/$Slug.docx"
}

switch ($Target) {
    "md"    { Compile-Md }
    "epub"  { Compile-Md; Compile-Epub }
    "print" { Compile-Md; Compile-Print }
    "docx"  { Compile-Md; Compile-Docx }
    "all"   { Compile-Md; Compile-Epub; Compile-Print; Compile-Docx }
}

Write-Host ""
Write-Host "Build complete. Artifacts in $ReleaseDir/"
