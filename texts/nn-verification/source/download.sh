#!/usr/bin/env bash
# Reconstruct texts/nn-verification/source/ on a fresh checkout.
#
# This script is the "lockfile" for the Albarghouthi NN-verification
# companion's source corpus. Idempotent; survives partial network failures.
#
# Source-ingestion conventions are documented in CONTRIBUTING.md
# ("Source ingestion"). Highlights:
#   - source/ is gitignored. Run this script locally to populate it.
#   - LaTeX is preferred over PDF.
#   - Primary source is arXiv:2109.10317 (also hosted at
#     verifieddeeplearning.com); secondary tooling sources are GitHub repos.
#
# Layout produced:
#   source/
#     book/                      # arXiv:2109.10317 LaTeX e-print + PDF + .txt
#     alpha-beta-CROWN/          # Verified-Intelligence/alpha-beta-CROWN
#     auto_LiRPA/                # Verified-Intelligence/auto_LiRPA
#     marabou/                   # NeuralNetworkVerification/Marabou
#     README.md                  # this directory's pinned README
#
# Usage:
#   bash texts/nn-verification/source/download.sh

set -u
# Note: not using `set -e`; we want to continue past individual failures.

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

mkdir -p book alpha-beta-CROWN auto_LiRPA marabou

log() { printf '[download.sh] %s\n' "$*"; }

fetch() {
  # fetch URL OUTPATH
  local url="$1" out="$2"
  if [ -s "$out" ]; then
    log "skip $out (already present)"
    return 0
  fi
  log "fetch $url -> $out"
  if curl -fsSL --retry 3 --retry-delay 2 \
       -A 'Mozilla/5.0 (math-explainers download.sh)' \
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
# 1. Albarghouthi, *Introduction to Neural Network Verification*
#    arXiv:2109.10317. The single primary source.
# ---------------------------------------------------------------------
BOOK_TAR="book/2109.10317.tar.gz"
if [ ! -f book/main.tex ] && [ ! -d book/extracted ]; then
  if fetch "https://arxiv.org/e-print/2109.10317" "$BOOK_TAR"; then
    mkdir -p book/extracted
    extract_arxiv_tarball "$BOOK_TAR" book/extracted
    # Promote the .tex with \documentclass to book/main.tex if unique.
    main="$(grep -l '\\documentclass' book/extracted/*.tex 2>/dev/null | head -n1 || true)"
    if [ -n "$main" ] && [ -f "$main" ]; then
      cp "$main" book/main.tex
      log "promoted $main -> book/main.tex"
    fi
  fi
else
  log "skip book/ (already extracted)"
fi

# Also grab the arXiv PDF as a fallback (figures + reference rendering).
fetch "https://arxiv.org/pdf/2109.10317.pdf" "book/2109.10317.pdf"

# And the author-hosted PDF in case the arXiv version drifts.
fetch "https://verifieddeeplearning.com/Intro_to_neural_network_verification_Albarghouthi.pdf" \
      "book/verifieddeeplearning.pdf" \
  || log "verifieddeeplearning.com fetch failed (non-fatal; arXiv PDF is canonical)"

if [ -s book/2109.10317.pdf ] && command -v pdftotext >/dev/null 2>&1; then
  if [ ! -s book/2109.10317.txt ]; then
    pdftotext -layout book/2109.10317.pdf book/2109.10317.txt \
      && log "pdftotext: 2109.10317.pdf -> .txt" \
      || log "pdftotext failed on Albarghouthi PDF"
  fi
fi

# ---------------------------------------------------------------------
# 2. α,β-CROWN — current SOTA complete verifier (VNN-COMP winner).
#    Repo: Verified-Intelligence/alpha-beta-CROWN
# ---------------------------------------------------------------------
if [ -d alpha-beta-CROWN/.git ]; then
  log "alpha-beta-CROWN already cloned; pulling latest"
  ( cd alpha-beta-CROWN && git pull --ff-only ) \
    || log "alpha-beta-CROWN git pull failed"
else
  rm -rf alpha-beta-CROWN
  log "cloning Verified-Intelligence/alpha-beta-CROWN"
  git clone --depth 1 \
    https://github.com/Verified-Intelligence/alpha-beta-CROWN.git \
    alpha-beta-CROWN \
    || log "git clone of alpha-beta-CROWN failed"
fi

# ---------------------------------------------------------------------
# 3. auto_LiRPA — linear-relaxation perturbation analysis library.
#    Repo: Verified-Intelligence/auto_LiRPA
# ---------------------------------------------------------------------
if [ -d auto_LiRPA/.git ]; then
  log "auto_LiRPA already cloned; pulling latest"
  ( cd auto_LiRPA && git pull --ff-only ) \
    || log "auto_LiRPA git pull failed"
else
  rm -rf auto_LiRPA
  log "cloning Verified-Intelligence/auto_LiRPA"
  git clone --depth 1 \
    https://github.com/Verified-Intelligence/auto_LiRPA.git \
    auto_LiRPA \
    || log "git clone of auto_LiRPA failed"
fi

# ---------------------------------------------------------------------
# 4. Marabou — SMT-style complete verifier (Reluplex's successor).
#    Repo: NeuralNetworkVerification/Marabou
# ---------------------------------------------------------------------
if [ -d marabou/.git ]; then
  log "marabou already cloned; pulling latest"
  ( cd marabou && git pull --ff-only ) || log "marabou git pull failed"
else
  rm -rf marabou
  log "cloning NeuralNetworkVerification/Marabou"
  git clone --depth 1 \
    https://github.com/NeuralNetworkVerification/Marabou.git \
    marabou \
    || log "git clone of marabou failed"
fi

log "done. Inspect texts/nn-verification/source/ — see README.md for layout."
