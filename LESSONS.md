# Lessons accumulated across autonomous sessions

Tech notes that don't belong in `CONTRIBUTING.md` (which is read at
the start of every session) but *would* save the next session time
if it lands in similar territory.

**How to use this file.** *Do not* read this file by default. Read
it on demand when:

- you are about to write or modify a widget → see "Widget build
  notes";
- you are about to run the source-ingestion `download.sh` for any
  text → see "Source ingestion";
- a `git push`, `apt`, or browser-launch fails in unexpected ways →
  see "Sandbox / environment";
- you need a headless-browser smoke-test recipe → see "Headless
  testing".

**How to maintain this file.** When you learn something that would
have saved you an hour, add it under the relevant heading. Keep
entries terse: rule first, then the *why* in one sentence. Delete
entries that have been resolved upstream (e.g., a script change
making a workaround obsolete).

---

## Widget build notes

### Default widget format

Single-file standalone `.html`. D3 v7, d3-contour v4, KaTeX 0.16
loaded from `cdn.jsdelivr.net`. No build step. The first widget
that uses this pattern is
`texts/slt/chapters/dslt1-rlct-effective-dimension/widgets/01-bayes-loss-landscape.html`
— fork it for the next widget instead of starting from scratch.

Escalate to a static site under `texts/<slug>/site/` or to a
React/Vite project only if you need a real bundle (Three.js scene,
multi-route navigation, etc.). The single-file pattern is enough
for everything in DSLT 1's module breakdown.

### KaTeX gotcha: load synchronously, not deferred

If you load `katex.min.js` and `auto-render.min.js` with `defer`,
the deferred scripts run *after* your inline `<script>` block.
`renderMathInElement` calls in your inline script then silently
no-op on first paint, leaving raw `\[ … \]` in the DOM. Load both
KaTeX scripts without `defer` so they are ready by the time your
script runs.

The auto-render `onload="renderMathInElement(...)"` handler is also
brittle because backslash-escaping differs between HTML attributes
and JS strings; calling `renderMathInElement` in JS with explicit
`delimiters: [{left:'\\[', right:'\\]', display:true}, ...]`
removes that whole class of bugs.

### `d3.contours` coordinate system

`d3.contours` returns coordinates in image space (y goes *down*
with index, origin at top-left of the grid). If your math plot has
y increasing upward, you need a flipped projection when handing
the contour features to `d3.geoPath`:

```js
const projection = d3.geoTransform({
  point(x, y) {
    this.stream.point(
      PAD + x * pxPerCellX,
      (PLOT_H - PAD) - y * pxPerCellY,   // flip y
    );
  },
});
const path = d3.geoPath(projection);
```

Without the flip the plot renders mirrored top-to-bottom. Easy to
miss because contours of a symmetric `K` (e.g., `K = w₁² + w₂²`)
look right anyway.

### 1D `K(w)` plots: don't scale y to `kMax`

Polynomials like $(w+1)^2 (w-1)^4$ have $K \approx 81$ at the
boundary of `[-2, 2]` but the only interior local max is
$K(-1/3) \approx 1.4$. Scaling the y-axis to `kMax` squashes both
zeros into the bottom 2% of the plot.

Heuristic that has worked: cap y at `max(p80(K) * 2, kMax * 0.05)`,
where `p80(K)` is the 80th-percentile of the sampled K-values. Clip
the curve path to a `<clipPath>` rectangle so the steep boundary
behaviour doesn't draw outside the frame.

### Trust-but-verify the render, not just the syntax

A `node --check` pass means your JS parses. It says nothing about
whether the widget renders. Always:

1. Open the file in a real browser (Playwright works headless,
   see below).
2. Take a screenshot of the SVG element directly
   (`await (await page.$('#plot')).screenshot(...)`), not the full
   page; full-page is usually too zoomed-out to judge plot
   quality.
3. `Read` the PNG back from the assistant tool to actually look at
   it.

A widget that "loads with no console errors" can still be
rendering empty SVG, mirrored axes, or a formula box of literal
backslashes.

---

## Headless testing

### Use Playwright, not Puppeteer (on aarch64)

Matthew's autonomous-session sandbox at the time of writing is
aarch64 (orbstack on Apple Silicon). Puppeteer's bundled Chromium
is x86_64 only and crashes with:

```
OrbStack ERROR: Dynamic loader not found: /lib64/ld-linux-x86-64.so.2
```

Playwright ships an aarch64 Chromium build that works out of the
box:

```bash
cd /tmp
npm install playwright
npx playwright install chromium
```

Then a quick smoke test for any single-file `.html` widget:

```js
const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1000, height: 900 } });
  page.on('pageerror', e => console.error('pageerror:', e.message));
  page.on('console', m => { if (m.type() === 'error') console.error('console.error:', m.text()); });
  await page.goto('file://' + ABSOLUTE_PATH, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);  // give KaTeX/D3 a beat
  // Assert SVG has paths/circles/lines you expect, then screenshot.
  await (await page.$('#plot')).screenshot({ path: '/tmp/widget.png' });
  await browser.close();
})();
```

Don't bother trying to install `chromium-browser` via `apt` on this
sandbox; the package mirrors are flaky and usually 404 on at least
one transitive dependency.

---

## Source ingestion

### Required apt packages

Run on a fresh sandbox before `download.sh` for any text:

```bash
sudo apt-get install -y poppler-utils pandoc
```

`poppler-utils` provides `pdftotext`; `pandoc` is needed for
HTML → Markdown conversion. The download scripts tolerate the
absence of either (skipping the post-processing step) but the
`.txt` and `.md` extractions are usually what you actually want
for grep / quote-by-line.

### Make `download.sh` tolerate partial network failures

`set -u` only, never `set -e`. Each fetch should `|| true` and
log `FAILED:` lines rather than abort. Sources drift, sandbox
firewalls move, and partial population is a valid state.

### Sandbox network egress is not stable

Successive autonomous sessions on what *should* be the same
machine have reported drastically different egress profiles. The
2026-05-05 ~12:00 SLT session reported every source host
firewalled; the 2026-05-05 ~05:54 session that immediately
followed had egress to all of them. Don't assume either profile;
just run `download.sh` and let the `|| true` machinery do its
job.

### Blog mirrors drift their slugs

Specific finding (2026-05-05): `timaeus.co/blog/dslt/2023-06-17-dslt-1/`
and `timaeus.co/blog/dslt/2023-06-22-dslt-4/` 404, while the other
DSLT post slugs in `texts/slt/source/download.sh` resolve. The
LessWrong / Alignment Forum copies are the source of record so
this is not project-blocking, but if a session needs the Timaeus
rendering specifically, browse `https://timaeus.co/blog/` for the
current slug and update `download.sh`.

---

## Sandbox / environment

### `git push` to GitHub: token-based HTTPS auth

As of session 2026-05-05 (fourth on this repo), Matthew configured
a fine-grained Personal Access Token at `~/.git-credentials` with
`credential.helper=store` (set globally in `~/.gitconfig`). `git
push` from the sandbox now works.

If a future session sees `could not read Username for
'https://github.com'`:

- Check `~/.git-credentials` exists and is `chmod 600`.
- Check `git config --global credential.helper` returns `store`.
- If the file is gone or the token was rotated, ask Matthew for a
  new one rather than improvising.

If `git push` returns `Permission ... denied to AMindToThink` (HTTP
403) even though the token authenticates: the token is a
fine-grained PAT and is missing **Repository permissions →
Contents → Read and write**. The `permissions` block returned by
`GET /repos/...` reports the *user's* role on the repo (which is
admin for AMindToThink), not what the token itself may do; you
need to inspect the token's own scopes via the GitHub UI. Ask
Matthew to update the token; the same `~/.git-credentials` entry
will then start working.

The token is stored *outside* the repo (in `$HOME`) so it cannot
be accidentally committed. Don't ever write the token into a
file under the repo tree.

### apt mirror flakiness

`apt-get install` on this image sometimes 404s on transitive
dependencies of large packages (e.g., `chromium-browser` pulls
`libcap2-bin` whose specific patch version isn't in the mirror).
Stick to the smaller packages you actually need (`poppler-utils`,
`pandoc`) rather than meta-packages.

### Architecture is aarch64

Apple Silicon under OrbStack. Anything that ships only x86_64
binaries via npm/pip will crash with the dynamic-loader error
quoted above. Prefer tools that ship multi-arch wheels: Playwright
yes, Puppeteer no.
