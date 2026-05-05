#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["playwright>=1.48"]
# ///
"""Interactive integration test for widget 3 (Fisher / singularity).

Loads the widget, then for every model preset and every $w^{(0)}$ in its
dropdown, clicks through to a rank choice and verifies the reveal panel
renders without console errors. Exits non-zero on the first error.
"""

from __future__ import annotations

import sys
from pathlib import Path

from playwright.sync_api import ConsoleMessage, sync_playwright


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    widget = repo_root / "texts/slt/chapters/dslt1-rlct-effective-dimension/widgets/03-fisher-degeneracy.html"

    errors: list[str] = []

    def on_console(msg: ConsoleMessage) -> None:
        if msg.type in {"error", "warning"}:
            errors.append(f"[console.{msg.type}] {msg.text}")

    def on_page_error(exc: Exception) -> None:
        errors.append(f"[pageerror] {exc}")

    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_context().new_page()
        page.on("console", on_console)
        page.on("pageerror", on_page_error)

        page.goto(widget.absolute().as_uri(), wait_until="networkidle", timeout=15_000)
        page.wait_for_timeout(400)

        model_buttons = page.locator("#model-buttons button")
        n_models = model_buttons.count()
        print(f"::: {n_models} models")

        for mi in range(n_models):
            model_buttons.nth(mi).click()
            page.wait_for_timeout(150)
            name = model_buttons.nth(mi).text_content() or f"#{mi}"
            options = page.locator("#w0-select option")
            for oi in range(options.count()):
                label = options.nth(oi).text_content() or "?"
                page.locator("#w0-select").select_option(index=oi)
                page.wait_for_timeout(120)
                # Click first choice to trigger reveal (we don't care if "right" or
                # "wrong" — we just want the panel to render).
                page.locator("#choices button").first.click()
                page.wait_for_timeout(120)
                reveal_text = (page.locator("#reveal").text_content() or "").strip()
                if not reveal_text:
                    errors.append(f"[empty reveal] model={name!r} w0={label!r}")
                else:
                    print(f"   {name!r:50s} {label!r:14s} -> {len(reveal_text):4d} chars revealed")

        browser.close()

    if errors:
        print("\nERRORS:")
        for e in errors:
            print(f"  {e}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
