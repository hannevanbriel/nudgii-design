#!/usr/bin/env python3
"""
nudgii token build pipeline (POC).

Reads system/tokens.json (single source of truth) and generates:
  - system/tokens.css       CSS custom properties for all HTML files
  - build/tokens.dart       Flutter color/spacing/radius constants
  - build/tokens-report.md  Human-readable summary for CLAUDE.md inclusion

Usage:
    python3 tools/build-tokens.py

No dependencies beyond the Python stdlib.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOKENS_JSON = ROOT / "system" / "tokens.json"
OUT_CSS = ROOT / "system" / "tokens.css"
OUT_DART = ROOT / "build" / "tokens.dart"
OUT_REPORT = ROOT / "build" / "tokens-report.md"


def kebab(name: str) -> str:
    return name.replace("_", "-").lower()


def camel(name: str) -> str:
    parts = re.split(r"[-_]", name)
    return parts[0] + "".join(p.capitalize() for p in parts[1:])


def load_tokens() -> dict:
    with TOKENS_JSON.open() as f:
        return json.load(f)["nudgii"]


def iter_colors(tokens: dict):
    """Yield (group, name, hex, description) for every color token (skip _legacy)."""
    for group, entries in tokens.items():
        if group.startswith("_") or group in {"spacing", "radius", "typography"}:
            continue
        for name, entry in entries.items():
            if name.startswith("_"):
                continue
            if entry.get("type") != "color":
                continue
            yield group, name, entry["value"], entry.get("description", "")


def iter_scalars(tokens: dict, key: str, kind: str):
    for name, entry in tokens.get(key, {}).items():
        if name.startswith("_"):
            continue
        if entry.get("type") != kind:
            continue
        yield name, entry["value"], entry.get("description", "")


def build_css(tokens: dict) -> str:
    lines: list[str] = [
        "/* ═══════════════════════════════════════════════════════════════",
        "   nudgii · generated token stylesheet",
        "   DO NOT EDIT — generated from system/tokens.json by",
        "   tools/build-tokens.py. Run the script to regenerate.",
        "   ═══════════════════════════════════════════════════════════════ */",
        "",
        ":root {",
    ]

    # ── v10.5 core color tokens (cream/ink/cta/plum/sage/red/amber etc) ──
    lines.append("  /* ── v10.5 core colors ── */")
    for group, name, hex_value, desc in iter_colors(tokens):
        if group == "color":
            var_name = f"--{kebab(name)}"
            comment = f" /* {desc} */" if desc else ""
            lines.append(f"  {var_name}: {hex_value};{comment}")

    # ── v10.5 category (solid pastel) ──
    lines.append("")
    lines.append("  /* ── v10.5 category (solid pastel) ── */")
    for group, name, hex_value, _desc in iter_colors(tokens):
        if group == "category":
            lines.append(f"  --cat-{kebab(name)}: {hex_value};")

    # ── Precision Warmth core ──
    # These use the exact names referenced in s09-today-hifi etc:
    #   --surface, --surface-low, --surface-high, --surface-lowest, --ink,
    #   --mid, --hint, --outline-var, --primary, --apricot, --yellow, --overdue-bg
    # Some names (--ink, --mid, --hint) collide with v10.5. The PW values WIN
    # because they are emitted after — that is intentional: PW is the current system.
    lines.append("")
    lines.append("  /* ── Precision Warmth (current) ── */")
    for group, name, hex_value, _desc in iter_colors(tokens):
        if group == "pw":
            lines.append(f"  --{kebab(name)}: {hex_value};")

    # ── Precision Warmth category highlights (light) ──
    lines.append("")
    lines.append("  /* ── PW category highlights (light) ── */")
    for group, name, hex_value, _desc in iter_colors(tokens):
        if group == "pw-category":
            lines.append(f"  --{kebab(name)}: {hex_value};")

    lines.append("")
    lines.append("  /* ── spacing ── */")
    for name, value, _desc in iter_scalars(tokens, "spacing", "spacing"):
        lines.append(f"  --space-{name}: {value}px;")

    lines.append("")
    lines.append("  /* ── radius ── */")
    for name, value, _desc in iter_scalars(tokens, "radius", "borderRadius"):
        lines.append(f"  --radius-{kebab(name)}: {value}px;")

    # Typography family shortcuts
    typo = tokens.get("typography", {})
    font_serif = typo.get("font-serif", {}).get("value", "DM Serif Display")
    font_sans = typo.get("font-sans", {}).get("value", "DM Sans")
    lines.append("")
    lines.append("  /* ── typography families ── */")
    lines.append(f"  --font-serif: '{font_serif}', serif;")
    lines.append(f"  --font-sans: '{font_sans}', sans-serif;")

    lines.append("}")
    lines.append("")

    # ── Dark mode ─────────────────────────────────────────────────────────
    lines.append("[data-theme='dark'] {")

    # v10.5 dark — mapped onto v10.5 semantic names (cream, ink, surface, cat-*)
    lines.append("  /* v10.5 dark remaps */")
    dark = tokens.get("dark", {})
    if "bg" in dark:
        lines.append(f"  --cream: {dark['bg']['value']};")
    if "nav" in dark:
        lines.append(f"  --surface: {dark['nav']['value']};")
    for cat in ("home", "garden", "vehicle", "subscriptions", "health", "pets"):
        dark_key = f"{cat}-bg"
        if dark_key in dark:
            lines.append(f"  --cat-{cat}-bg: {dark[dark_key]['value']};")

    # Precision Warmth dark — overrides every PW token with its dark equivalent
    lines.append("")
    lines.append("  /* Precision Warmth dark (overrides PW tokens) */")
    for group, name, hex_value, _desc in iter_colors(tokens):
        if group == "pw-dark":
            lines.append(f"  --{kebab(name)}: {hex_value};")

    lines.append("}")
    lines.append("")

    return "\n".join(lines)


def build_dart(tokens: dict) -> str:
    lines: list[str] = [
        "// ═══════════════════════════════════════════════════════════════",
        "// nudgii · generated Flutter tokens",
        "// DO NOT EDIT — generated from system/tokens.json by",
        "// tools/build-tokens.py. Run the script to regenerate.",
        "// ═══════════════════════════════════════════════════════════════",
        "",
        "import 'package:flutter/material.dart';",
        "",
        "class NudgiiColors {",
        "  NudgiiColors._();",
        "",
    ]

    def hex_to_dart(h: str) -> str | None:
        """Convert #RRGGBB or rgba(...) to Dart Color literal. Returns None for unsupported."""
        h = h.strip()
        if h.startswith("#") and len(h) == 7:
            return f"Color(0xFF{h[1:].upper()})"
        if h.startswith("rgba"):
            m = re.match(r"rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)", h)
            if m:
                r, g, b, a = int(m.group(1)), int(m.group(2)), int(m.group(3)), float(m.group(4))
                alpha = int(round(a * 255))
                return f"Color(0x{alpha:02X}{r:02X}{g:02X}{b:02X})"
        return None

    def emit_color_block(header: str, group: str):
        lines.append(f"  // ── {header} ──")
        for g, name, hex_value, desc in iter_colors(tokens):
            if g != group:
                continue
            const = camel(name)
            dart_literal = hex_to_dart(hex_value)
            if dart_literal is None:
                lines.append(f"  // {const}: unsupported value {hex_value}")
                continue
            if desc:
                lines.append(f"  /// {desc}")
            lines.append(f"  static const {const} = {dart_literal};")
        lines.append("")

    emit_color_block("v10.5 core", "color")
    emit_color_block("v10.5 category (light)", "category")
    emit_color_block("v10.5 dark", "dark")
    emit_color_block("Precision Warmth (current)", "pw")
    emit_color_block("Precision Warmth category (light)", "pw-category")
    emit_color_block("Precision Warmth dark", "pw-dark")

    lines.append("}")
    lines.append("")

    # Spacing + radius as int constants
    lines.append("class NudgiiSpacing {")
    lines.append("  NudgiiSpacing._();")
    for name, value, _desc in iter_scalars(tokens, "spacing", "spacing"):
        lines.append(f"  static const s{name} = {value};")
    lines.append("}")
    lines.append("")

    lines.append("class NudgiiRadius {")
    lines.append("  NudgiiRadius._();")
    for name, value, _desc in iter_scalars(tokens, "radius", "borderRadius"):
        const = camel(name)
        lines.append(f"  static const {const} = {value};")
    lines.append("}")
    lines.append("")

    return "\n".join(lines)


def build_report(tokens: dict) -> str:
    lines = [
        "# nudgii tokens (generated)",
        "",
        "Generated by `tools/build-tokens.py` from `system/tokens.json`. ",
        "Do not edit this file. Edit `tokens.json` and re-run the script.",
        "",
        "## Core colors",
        "",
        "| Token | Value | Description |",
        "| --- | --- | --- |",
    ]
    for group, name, hex_value, desc in iter_colors(tokens):
        if group == "color":
            lines.append(f"| `--{kebab(name)}` | `{hex_value}` | {desc} |")
    lines.append("")
    lines.append("## Category (light)")
    lines.append("")
    lines.append("| Token | Value | Description |")
    lines.append("| --- | --- | --- |")
    for group, name, hex_value, desc in iter_colors(tokens):
        if group == "category":
            lines.append(f"| `--cat-{kebab(name)}` | `{hex_value}` | {desc} |")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    tokens = load_tokens()

    css = build_css(tokens)
    dart = build_dart(tokens)
    report = build_report(tokens)

    OUT_CSS.parent.mkdir(parents=True, exist_ok=True)
    OUT_DART.parent.mkdir(parents=True, exist_ok=True)

    OUT_CSS.write_text(css)
    OUT_DART.write_text(dart)
    OUT_REPORT.write_text(report)

    core_count = sum(1 for g, _, _, _ in iter_colors(tokens) if g == "color")
    cat_count = sum(1 for g, _, _, _ in iter_colors(tokens) if g == "category")
    dark_count = sum(1 for g, _, _, _ in iter_colors(tokens) if g == "dark")

    print(f"✓ tokens.css   ({OUT_CSS.relative_to(ROOT)})")
    print(f"✓ tokens.dart  ({OUT_DART.relative_to(ROOT)})")
    print(f"✓ tokens-report.md")
    print(f"  core colors:     {core_count}")
    print(f"  category colors: {cat_count}")
    print(f"  dark colors:     {dark_count}")


if __name__ == "__main__":
    main()
