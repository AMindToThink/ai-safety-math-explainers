#!/usr/bin/env bash
# Reconstruct texts/slt/source/ on a fresh checkout.
#
# This script is the "lockfile" for the SLT companion's source corpus.
# Re-running it must be idempotent and survive partial network failures.
#
# Source-ingestion conventions are documented in CONTRIBUTING.md
# ("Source ingestion"). Highlights:
#   - source/ is gitignored. Run this script locally to populate it.
#   - LaTeX/Markdown is preferred over HTML, which is preferred over PDF.
#   - Copyrighted books (Watanabe Grey/Green) are NOT downloaded; this
#     script only prints instructions for placing them by hand.
#
# Layout produced:
#   source/
#     watanabe/                 # PLACE PDFs MANUALLY (gitignored)
#     dslt/                     # Carroll's DSLT 0-4 blog posts
#     carroll-thesis/           # Carroll's MSc thesis (PDF)
#     timaeus-blog/             # Timaeus / DevInterp blog posts
#     devinterp/                # `git clone` of timaeus-research/devinterp
#     arxiv/                    # arXiv preprints (LaTeX where possible)
#     metauni/                  # links / pointers to seminar materials
#     README.md                 # this directory's pinned README
#
# Usage:
#   bash texts/slt/source/download.sh

set -u
# Note: not using `set -e`; we want to continue past individual failures.

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

mkdir -p watanabe dslt carroll-thesis timaeus-blog devinterp arxiv metauni

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

# ---------------------------------------------------------------------
# 1. Watanabe Grey + Green books (NOT auto-downloaded; copyright)
# ---------------------------------------------------------------------
cat > watanabe/README.md <<'EOF'
# Watanabe books — manual placement required

These two monographs are the spine of SLT but are copyrighted and not
freely redistributable. Obtain them through a library, institutional
subscription, or purchase, and place the PDFs here as:

  watanabe/grey-book.pdf
    Watanabe (2009), *Algebraic Geometry and Statistical Learning Theory*,
    Cambridge University Press.
    https://www.cambridge.org/core/books/algebraic-geometry-and-statistical-learning-theory/9C8FD1BDC817E2FC79117027B6B7CFD0

  watanabe/green-book.pdf
    Watanabe (2018), *Mathematical Theory of Bayesian Statistics*,
    CRC Press / Chapman & Hall.
    https://www.routledge.com/Mathematical-Theory-of-Bayesian-Statistics/Watanabe/p/book/9780367734817

Then run `pdftotext -layout` on each so prose is greppable:

  pdftotext -layout grey-book.pdf  grey-book.txt
  pdftotext -layout green-book.pdf green-book.txt

Both files (PDFs and .txt extractions) are gitignored. They live on
your local machine, never the commit history.
EOF
log "wrote watanabe/README.md (manual placement notes)"

# ---------------------------------------------------------------------
# 2. Carroll DSLT 0-4 (HTML; LessWrong primary, AlignmentForum mirror)
#
# AF and LW serve the same posts; we hit LW (cleaner) and fall back to
# AF. Saved as raw HTML — pandoc to markdown locally if you want.
# ---------------------------------------------------------------------
declare -a DSLT_POSTS=(
  "xRWsfGfvDAjRWXcnG dslt-0-distilling-singular-learning-theory"
  "4eZtmwaqhAgdJQDEg dslt-1-the-rlct-measures-the-effective-dimension-of-neural"
  "CZHwwDd7t9aYra5HN dslt-2-why-neural-networks-obey-occam-s-razor"
  "tZwaGp5wMQqKh3krz dslt-3-neural-networks-are-singular"
  "aKBAYN5LpaQMrPqMj dslt-4-phase-transitions-in-neural-networks"
)
for entry in "${DSLT_POSTS[@]}"; do
  id="${entry%% *}"
  slug="${entry#* }"
  out="dslt/${slug}.html"
  fetch "https://www.lesswrong.com/posts/${id}/${slug}" "$out" \
    || fetch "https://www.alignmentforum.org/posts/${id}/${slug}" "$out" \
    || fetch "https://www.greaterwrong.com/posts/${id}/${slug}" "$out" \
    || log "all DSLT mirrors failed for $slug"
done

# Optional: convert to markdown if pandoc is installed.
if command -v pandoc >/dev/null 2>&1; then
  for h in dslt/*.html; do
    [ -f "$h" ] || continue
    md="${h%.html}.md"
    [ -s "$md" ] && continue
    pandoc -f html -t gfm-raw_html --wrap=preserve "$h" -o "$md" \
      && log "pandoc: $h -> $md" || log "pandoc failed on $h"
  done
else
  log "pandoc not installed; leaving DSLT as HTML. Install pandoc to get .md too."
fi

# ---------------------------------------------------------------------
# 3. Carroll MSc thesis (PDF, freely posted on therisingsea.org)
# ---------------------------------------------------------------------
fetch "http://therisingsea.org/notes/MSc-Carroll.pdf" \
      "carroll-thesis/MSc-Carroll.pdf"

if [ -s carroll-thesis/MSc-Carroll.pdf ] && command -v pdftotext >/dev/null 2>&1; then
  if [ ! -s carroll-thesis/MSc-Carroll.txt ]; then
    pdftotext -layout carroll-thesis/MSc-Carroll.pdf carroll-thesis/MSc-Carroll.txt \
      && log "pdftotext: MSc-Carroll.pdf -> .txt" \
      || log "pdftotext failed on Carroll thesis"
  fi
fi

# ---------------------------------------------------------------------
# 4. Timaeus / DevInterp blog mirror of DSLT + SLT exercises
# ---------------------------------------------------------------------
declare -a TIMAEUS_POSTS=(
  "blog/dslt/2023-06-16-dslt-0/  dslt-0.html"
  "blog/dslt/2023-06-17-dslt-1/  dslt-1.html"
  "blog/dslt/2023-06-18-dslt-2/  dslt-2.html"
  "blog/dslt/2023-06-20-dslt-3/  dslt-3.html"
  "blog/dslt/2023-06-22-dslt-4/  dslt-4.html"
  "blog/slt/2024-08-30-exercises/ slt-exercises.html"
)
for entry in "${TIMAEUS_POSTS[@]}"; do
  path="$(echo "$entry" | awk '{print $1}')"
  fname="$(echo "$entry" | awk '{print $2}')"
  out="timaeus-blog/${fname}"
  # Try timaeus.co first, then devinterp.com (older URL host).
  fetch "https://timaeus.co/${path}"   "$out" \
    || fetch "https://devinterp.com/${path}" "$out" \
    || log "timaeus mirror failed for ${path}"
done

# Note: Timaeus blog post slugs may change. If a slug 404s, search
# https://timaeus.co/blog/ and update the array above.

# ---------------------------------------------------------------------
# 5. devinterp Python library (MIT-licensed; full clone)
# ---------------------------------------------------------------------
if [ -d devinterp/.git ]; then
  log "devinterp already cloned; pulling latest"
  ( cd devinterp && git pull --ff-only ) || log "devinterp git pull failed"
else
  rm -rf devinterp
  log "cloning timaeus-research/devinterp"
  git clone --depth 1 https://github.com/timaeus-research/devinterp.git devinterp \
    || log "git clone of devinterp failed"
fi

# ---------------------------------------------------------------------
# 6. arXiv DevInterp / SLT papers (LaTeX e-prints)
#
# Add IDs as they become relevant to the chapters being built. Each
# entry is "<arxiv-id> <local-name>". Using arxiv.org/e-print/<id>
# returns a tarball; we save it as .tar.gz and extract.
#
# Seed list (small; expand as needed):
# ---------------------------------------------------------------------
declare -a ARXIV_PAPERS=(
  # Lau, Murfet, Wei - Quantifying degeneracy in singular models...
  "2308.12108  lau-llc-2023"
  # Hoogland et al. - Developmental landscape of in-context learning
  "2402.02364  hoogland-devlandscape-2024"
  # Chen et al. - Dynamical versus Bayesian Phase Transitions
  "2310.06301  chen-phase-transitions-2023"
)
for entry in "${ARXIV_PAPERS[@]}"; do
  id="$(echo "$entry" | awk '{print $1}')"
  name="$(echo "$entry" | awk '{print $2}')"
  tarout="arxiv/${name}.tar.gz"
  dir="arxiv/${name}"
  [ -d "$dir" ] && { log "skip arxiv:$id (already extracted)"; continue; }
  if fetch "https://arxiv.org/e-print/${id}" "$tarout"; then
    mkdir -p "$dir"
    if tar -xzf "$tarout" -C "$dir" 2>/dev/null; then
      log "extracted arxiv:$id -> $dir"
    else
      # arxiv sometimes serves a bare .tex or .pdf; inspect file type.
      ftype="$(file -b "$tarout" 2>/dev/null || echo unknown)"
      log "tar failed; saw '$ftype'. Leaving raw at $tarout"
    fi
  fi
done

# ---------------------------------------------------------------------
# 7. metauni SLT seminar pointers (no auto-download; just URLs)
# ---------------------------------------------------------------------
cat > metauni/README.md <<'EOF'
# metauni SLT seminar materials

Seminar series + exercises live at:

- https://metauni.org/slt/
- https://timaeus.co/blog/slt/2024-08-30-exercises/  (Furman exercises)
- Watanabe homepage:
  - https://sites.google.com/view/sumiowatanabe/home/singular-learning-theory
  - http://watanabe-www.math.dis.titech.ac.jp/users/swatanab/singular-learning-theory.html

These are linked but not auto-downloaded; the seminar videos are too
large and the exercise pages change often enough that pinning here is
not worth it.
EOF
log "wrote metauni/README.md (pointers)"

log "done. Inspect texts/slt/source/ — see README.md for layout."
