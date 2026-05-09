#!/usr/bin/env bash
# Reconstruct texts/tensor-programs/source/ on a fresh checkout.
#
# This script is the "lockfile" for the Tensor Programs companion's
# source corpus. Re-running must be idempotent; partial network
# failures are tolerated (no `set -e`).
#
# Source-ingestion conventions: see CONTRIBUTING.md ("Source ingestion").
# Highlights:
#   - source/ is gitignored. Run this script locally to populate.
#   - LaTeX from arXiv is the canonical format.
#
# Layout produced:
#   source/
#     arxiv/
#       tp1-1910.12478/         # TP I — formalism + GP correspondence
#       tp2b-2105.03703/        # TP IIb — NTK universality
#       tp4-2011.14522/         # TP IV — feature learning + abc-class + muP
#       tp4b-2308.01814/        # TP IVb — Adam in infinite width
#       tp5-2203.03466/         # TP V — muTransfer
#       tp6-2310.02244/         # TP VI — Depth-muP
#       spectral-2310.17813/    # Spectral Condition for Feature Learning
#     blog/
#       eleuther-mutransfer.html
#       cerebras-mutransfer.html
#       msr-mutransfer.html
#     code/
#       nanoGPT-mup/            # git clone of EleutherAI/nanoGPT-mup
#     README.md                 # this directory's pinned README
#
# Usage:
#   bash texts/tensor-programs/source/download.sh

set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

mkdir -p arxiv blog code

log() { printf '[download.sh] %s\n' "$*"; }

fetch_arxiv() {
  # fetch_arxiv ARXIV_ID OUTDIR_NAME
  local id="$1" out="arxiv/$2"
  if [ -d "$out" ] && [ -n "$(ls -A "$out" 2>/dev/null)" ]; then
    log "skip $out (already populated)"
    return 0
  fi
  mkdir -p "$out"
  local tarball="$out/source.tar.gz"
  log "fetching arXiv $id -> $out"
  if ! curl -fsSL "https://arxiv.org/e-print/$id" -o "$tarball"; then
    log "  FAILED to fetch $id; leaving $out empty"
    return 1
  fi
  if ! tar -xzf "$tarball" -C "$out" 2>/dev/null; then
    # Some arXiv submissions are bare .tex (gzip, not tar.gz). Try gunzip.
    if gunzip -c "$tarball" > "$out/main.tex" 2>/dev/null; then
      log "  extracted as bare gzipped .tex"
    else
      log "  WARNING: extraction failed; raw blob left at $tarball"
    fi
  fi
  rm -f "$tarball"
}

fetch_url() {
  # fetch_url URL OUTPATH
  local url="$1" out="$2"
  if [ -s "$out" ]; then
    log "skip $out (already exists)"
    return 0
  fi
  log "fetching $url -> $out"
  curl -fsSL "$url" -o "$out" || log "  FAILED $url"
}

# --- arXiv LaTeX sources ---------------------------------------------------

fetch_arxiv 1910.12478 tp1-1910.12478
fetch_arxiv 2105.03703 tp2b-2105.03703
fetch_arxiv 2011.14522 tp4-2011.14522
fetch_arxiv 2308.01814 tp4b-2308.01814
fetch_arxiv 2203.03466 tp5-2203.03466
fetch_arxiv 2310.02244 tp6-2310.02244
fetch_arxiv 2310.17813 spectral-2310.17813

# --- Blog posts (HTML) -----------------------------------------------------

fetch_url "https://blog.eleuther.ai/mutransfer/" \
          "blog/eleuther-mutransfer.html"
fetch_url "https://www.cerebras.ai/blog/the-practitioners-guide-to-the-maximal-update-parameterization" \
          "blog/cerebras-mutransfer.html"
fetch_url "https://www.microsoft.com/en-us/research/blog/%C2%B5transfer-a-technique-for-hyperparameter-tuning-of-enormous-neural-networks/" \
          "blog/msr-mutransfer.html"

# --- Reference code --------------------------------------------------------

if [ ! -d code/nanoGPT-mup ]; then
  log "cloning EleutherAI/nanoGPT-mup"
  git clone --depth 1 https://github.com/EleutherAI/nanoGPT-mup code/nanoGPT-mup \
    || log "  FAILED to clone nanoGPT-mup"
else
  log "skip code/nanoGPT-mup (already present)"
fi

if [ ! -d code/mup ]; then
  log "cloning microsoft/mup (the original mup library)"
  git clone --depth 1 https://github.com/microsoft/mup code/mup \
    || log "  FAILED to clone microsoft/mup"
else
  log "skip code/mup (already present)"
fi

log "done. Inspect $HERE for what landed."
