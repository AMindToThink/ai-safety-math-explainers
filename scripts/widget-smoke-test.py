#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["playwright>=1.48"]
# ///
"""Headless render check for widgets.

For each HTML file given on the command line (or all widgets under
texts/*/chapters/*/widgets if none given), this:

  1. opens the file in chromium,
  2. waits for KaTeX to finish (or 3s, whichever is shorter),
  3. captures any console errors / page errors,
  4. saves a screenshot next to the widget as ``<name>.smoke.png``.

Exit status is non-zero if *any* widget produces a console / page error.
This is a smoke test, not a visual regression test &mdash; it catches the
"undefined variable" / "import broken" / "KaTeX never ran" class of bug,
not "this contour line moved by 2 pixels".

Run from repo root::

    uv run scripts/widget-smoke-test.py
    uv run scripts/widget-smoke-test.py texts/slt/chapters/.../01-foo.html
"""

from __future__ import annotations

import sys
from pathlib import Path

from playwright.sync_api import ConsoleMessage, Page, sync_playwright


def find_default_widgets(repo_root: Path) -> list[Path]:
    return sorted(repo_root.glob("texts/*/chapters/*/widgets/*.html"))


def check_widget(page: Page, widget: Path) -> list[str]:
    errors: list[str] = []

    def on_console(msg: ConsoleMessage) -> None:
        if msg.type in {"error", "warning"}:
            errors.append(f"[console.{msg.type}] {msg.text}")

    def on_page_error(exc: Exception) -> None:
        errors.append(f"[pageerror] {exc}")

    page.on("console", on_console)
    page.on("pageerror", on_page_error)

    page.goto(widget.absolute().as_uri(), wait_until="networkidle", timeout=15_000)
    # Give KaTeX/D3 a moment after networkidle for any deferred work.
    page.wait_for_timeout(800)

    shot_path = widget.with_suffix(".smoke.png")
    page.screenshot(path=str(shot_path), full_page=True)

    return errors


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    if len(sys.argv) > 1:
        widgets = [Path(p).resolve() for p in sys.argv[1:]]
    else:
        widgets = find_default_widgets(repo_root)

    if not widgets:
        print("no widgets found", file=sys.stderr)
        return 1

    any_failed = False
    with sync_playwright() as p:
        browser = p.chromium.launch()
        ctx = browser.new_context()
        for widget in widgets:
            page = ctx.new_page()
            print(f"::: {widget.relative_to(repo_root)}")
            errors = check_widget(page, widget)
            if errors:
                any_failed = True
                for e in errors:
                    print(f"   {e}")
            else:
                print("   ok")
            page.close()
        browser.close()

    return 1 if any_failed else 0


if __name__ == "__main__":
    sys.exit(main())
