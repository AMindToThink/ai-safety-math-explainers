#!/usr/bin/env bash
# Reconstruct texts/logical-induction/source/ on a fresh checkout.
#
# This script is the "lockfile" for the Logical Induction (LI) companion's
# source corpus. Re-running it must be idempotent and survive partial
# network failures.
#
# Source-ingestion conventions are documented in CONTRIBUTING.md
# ("Source ingestion"). Highlights:
#   - source/ is gitignored. Run this script locally to populate it.
#   - LaTeX is preferred over HTML, which is preferred over PDF.
#   - All sources here are arXiv + AlignmentForum/LessWrong + GitHub —
#     no copyrighted-book gymnastics needed.
#
# Layout produced:
#   source/
#     paper/                # arXiv:1609.03543 LaTeX e-print, extracted
#     scherlis/             # arXiv:2205.12879 LaTeX e-print, extracted
#     scherlis-code/        # epistax-is/logical-induction Python repo
#     demski/               # Demski's intuitive-guide posts (HTML + .md)
#     embedded-agency/      # Demski + Garrabrant's Embedded Agency posts
#     README.md             # this directory's pinned README
#
# Usage:
#   bash texts/logical-induction/source/download.sh

set -u
# Note: not using `set -e`; we want to continue past individual failures.

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

mkdir -p paper scherlis scherlis-code demski embedded-agency

log() { printf '[download.sh] %s\n' "$*"; }
fetch() {
  # fetch URL OUTPATH
  local url="$1" out="$2"
  if [ -s "$out" ]; then
    log "skip $out (already present)"
    return 0
  fi
  log "fetch $url -> $out"
  if curl -fsSL --retry 3 --retry-delay 2 -A 'Mozilla/5.0 (math-explainers download.sh)' \
       "$url" -o "$out.part"; then
    mv "$out.part" "$out"
  else
    log "FAILED: $url"
    rm -f "$out.part"
    return 1
  fi
}

extract_arxiv_tarball() {
  # extract_arxiv_tarball TAR DIR
  local tar="$1" dir="$2"
  if tar -xzf "$tar" -C "$dir" 2>/dev/null; then
    log "extracted $tar -> $dir"
    return 0
  fi
  # arxiv sometimes serves a bare .tex, single .gz, or .pdf
  local ftype
  ftype="$(file -b "$tar" 2>/dev/null || echo unknown)"
  log "tar failed; saw '$ftype'."
  case "$ftype" in
    *gzip*)
      gunzip -c "$tar" > "$dir/main.tex" 2>/dev/null \
        && log "treated as bare .tex.gz; wrote $dir/main.tex" \
        || log "gunzip also failed"
      ;;
    *PDF*)
      cp "$tar" "$dir/paper.pdf"
      log "treated as PDF; wrote $dir/paper.pdf"
      ;;
    *)
      log "leaving raw at $tar"
      ;;
  esac
}

# ---------------------------------------------------------------------
# 1. Garrabrant et al., *Logical Induction* (arXiv:1609.03543)
#    The single primary source. Pin v3 (2020-09).
# ---------------------------------------------------------------------
PAPER_TAR="paper/1609.03543.tar.gz"
if [ ! -f paper/main.tex ] && [ ! -d paper/extracted ]; then
  if fetch "https://arxiv.org/e-print/1609.03543v3" "$PAPER_TAR"; then
    mkdir -p paper/extracted
    extract_arxiv_tarball "$PAPER_TAR" paper/extracted
    # Bring the top-level .tex up to paper/main.tex if there's a single
    # main file. Heuristic: pick the .tex with `\documentclass`.
    main="$(grep -l '\\documentclass' paper/extracted/*.tex 2>/dev/null | head -n1 || true)"
    if [ -n "$main" ] && [ -f "$main" ]; then
      cp "$main" paper/main.tex
      log "promoted $main -> paper/main.tex"
    fi
  fi
else
  log "skip paper/ (already extracted)"
fi

# Also grab the PDF as a fallback (figures + reference rendering).
fetch "https://arxiv.org/pdf/1609.03543v3.pdf" "paper/1609.03543v3.pdf"
if [ -s paper/1609.03543v3.pdf ] && command -v pdftotext >/dev/null 2>&1; then
  if [ ! -s paper/1609.03543v3.txt ]; then
    pdftotext -layout paper/1609.03543v3.pdf paper/1609.03543v3.txt \
      && log "pdftotext: 1609.03543v3.pdf -> .txt" \
      || log "pdftotext failed on Garrabrant et al. PDF"
  fi
fi

# ---------------------------------------------------------------------
# 2. Scherlis, *Logical Induction for Software Engineers*
#    arXiv:2205.12879. Algorithmic detail + runnable pseudocode.
# ---------------------------------------------------------------------
SCH_TAR="scherlis/2205.12879.tar.gz"
if [ ! -f scherlis/main.tex ] && [ ! -d scherlis/extracted ]; then
  if fetch "https://arxiv.org/e-print/2205.12879" "$SCH_TAR"; then
    mkdir -p scherlis/extracted
    extract_arxiv_tarball "$SCH_TAR" scherlis/extracted
    main="$(grep -l '\\documentclass' scherlis/extracted/*.tex 2>/dev/null | head -n1 || true)"
    if [ -n "$main" ] && [ -f "$main" ]; then
      cp "$main" scherlis/main.tex
      log "promoted $main -> scherlis/main.tex"
    fi
  fi
else
  log "skip scherlis/ (already extracted)"
fi

fetch "https://arxiv.org/pdf/2205.12879.pdf" "scherlis/2205.12879.pdf"
if [ -s scherlis/2205.12879.pdf ] && command -v pdftotext >/dev/null 2>&1; then
  if [ ! -s scherlis/2205.12879.txt ]; then
    pdftotext -layout scherlis/2205.12879.pdf scherlis/2205.12879.txt \
      && log "pdftotext: 2205.12879.pdf -> .txt" \
      || log "pdftotext failed on Scherlis PDF"
  fi
fi

# ---------------------------------------------------------------------
# 3. Scherlis's accompanying Python code
#    https://github.com/epistax-is/logical-induction (MIT)
#    Used as ground truth for runnable LIA-toy semantics.
# ---------------------------------------------------------------------
if [ -d scherlis-code/.git ]; then
  log "scherlis-code already cloned; pulling latest"
  ( cd scherlis-code && git pull --ff-only ) || log "scherlis-code git pull failed"
else
  rm -rf scherlis-code
  log "cloning epistax-is/logical-induction"
  git clone --depth 1 https://github.com/epistax-is/logical-induction.git scherlis-code \
    || log "git clone of scherlis-code failed"
fi

# ---------------------------------------------------------------------
# 4. Demski's intuitive-guide / untrollable-mathematician posts
#    LessWrong primary, AlignmentForum mirror, GreaterWrong tertiary.
#
# Each entry is "<post-id>  <slug>".
# ---------------------------------------------------------------------
declare -a DEMSKI_POSTS=(
  "3SG4WbNPoP8fsuZgs  an-intuitive-guide-to-logical-induction"
  "Zi7nmBSGdsdfBxgWE  an-untrollable-mathematician-illustrated"
  "WnvSBkgwbPvevTjLs  logical-uncertainty-reading-list"
)
for entry in "${DEMSKI_POSTS[@]}"; do
  id="$(echo "$entry" | awk '{print $1}')"
  slug="$(echo "$entry" | awk '{print $2}')"
  out="demski/${slug}.html"
  fetch "https://www.lesswrong.com/posts/${id}/${slug}" "$out" \
    || fetch "https://www.alignmentforum.org/posts/${id}/${slug}" "$out" \
    || fetch "https://www.greaterwrong.com/posts/${id}/${slug}" "$out" \
    || log "all mirrors failed for $slug"
done

if command -v pandoc >/dev/null 2>&1; then
  for h in demski/*.html; do
    [ -f "$h" ] || continue
    md="${h%.html}.md"
    [ -s "$md" ] && continue
    pandoc -f html -t gfm-raw_html --wrap=preserve "$h" -o "$md" \
      && log "pandoc: $h -> $md" || log "pandoc failed on $h"
  done
else
  log "pandoc not installed; skipping HTML->Markdown for demski/."
fi

# ---------------------------------------------------------------------
# 5. Embedded Agency (Demski + Garrabrant)
#    Background motivation; not load-bearing for the math.
# ---------------------------------------------------------------------
declare -a EA_POSTS=(
  "i3BTagvt3HbPMx6PN  embedded-agents"
  "p7x32SEt43ZMC9r7r  embedded-agency-full-text-version"
)
for entry in "${EA_POSTS[@]}"; do
  id="$(echo "$entry" | awk '{print $1}')"
  slug="$(echo "$entry" | awk '{print $2}')"
  out="embedded-agency/${slug}.html"
  fetch "https://www.lesswrong.com/posts/${id}/${slug}" "$out" \
    || fetch "https://www.alignmentforum.org/posts/${id}/${slug}" "$out" \
    || fetch "https://www.greaterwrong.com/posts/${id}/${slug}" "$out" \
    || log "all mirrors failed for $slug"
done

if command -v pandoc >/dev/null 2>&1; then
  for h in embedded-agency/*.html; do
    [ -f "$h" ] || continue
    md="${h%.html}.md"
    [ -s "$md" ] && continue
    pandoc -f html -t gfm-raw_html --wrap=preserve "$h" -o "$md" \
      && log "pandoc: $h -> $md" || log "pandoc failed on $h"
  done
fi

log "done. Inspect texts/logical-induction/source/ — see README.md for layout."
