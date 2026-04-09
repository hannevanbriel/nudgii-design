#!/usr/bin/env python3
"""
Raw hex color lint — pre-commit hook.

Scans staged .html files under screens/ and system/ for raw #rrggbb values
that should be replaced with var(--token). Existing files get a "soft"
baseline (pre-existing hex allowed), but NEWLY INTRODUCED hex in staged
diffs is flagged.

Philosophy: don't block the team on old drift, block new drift.

Exclusions:
  - screens/archived/ and screens/archive/ (legacy, untouched)
  - system/design-system.html, system/pricing-tiers.html (swatch demos)
  - system/tokens.css (generated from tokens.json)
  - system/poc-token-demo.html (POC demo, no tokens yet)
  - inline comment lines (/* ... */ and // ...)

Usage:
    python3 tools/check-hex.py             # lint staged changes
    python3 tools/check-hex.py --all       # lint every tracked file (CI mode)

Exit codes:
    0 clean, 1 violations found
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

EXCLUDE_PATHS = {
    "system/design-system.html",
    "system/pricing-tiers.html",
    "system/tokens.css",
    "system/poc-token-demo.html",
}
EXCLUDE_PREFIXES = (
    "screens/archived/",
    "screens/archive/",
    "screens/old/",
    "system/old/",
)
INCLUDE_DIRS = ("screens/", "system/")

HEX_PATTERN = re.compile(r"#(?:[0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b")


def staged_files() -> list[str]:
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only", "--diff-filter=AM"],
        capture_output=True,
        text=True,
        cwd=ROOT,
    )
    return [f for f in result.stdout.strip().splitlines() if f]


def is_target(path: str) -> bool:
    if path in EXCLUDE_PATHS:
        return False
    if any(path.startswith(p) for p in EXCLUDE_PREFIXES):
        return False
    if not path.endswith(".html"):
        return False
    return any(path.startswith(d) for d in INCLUDE_DIRS)


def extract_added_hex(path: str) -> list[tuple[int, str, str]]:
    """For a staged file, return list of (line_number, hex, full_line)
    for lines that were ADDED in the staged diff and contain raw hex."""
    result = subprocess.run(
        ["git", "diff", "--cached", "-U0", "--", path],
        capture_output=True,
        text=True,
        cwd=ROOT,
    )
    hits: list[tuple[int, str, str]] = []
    line_no = 0
    for raw in result.stdout.splitlines():
        if raw.startswith("@@"):
            m = re.match(r"@@ -\d+(?:,\d+)? \+(\d+)", raw)
            if m:
                line_no = int(m.group(1)) - 1
            continue
        if raw.startswith("+++") or raw.startswith("---"):
            continue
        if raw.startswith("+"):
            line_no += 1
            line = raw[1:]
            # Skip comment-only lines: block and line comments
            stripped = line.strip()
            if stripped.startswith("/*") or stripped.startswith("*"):
                continue
            if stripped.startswith("//"):
                continue
            # Skip lines that are purely inside HTML comments
            if stripped.startswith("<!--") and stripped.endswith("-->"):
                continue
            for hex_val in HEX_PATTERN.findall(line):
                hits.append((line_no, hex_val, line.rstrip()))
        elif not raw.startswith("-"):
            line_no += 1
    return hits


def lint_full_file(path: str) -> list[tuple[int, str, str]]:
    p = ROOT / path
    if not p.exists():
        return []
    hits: list[tuple[int, str, str]] = []
    for i, line in enumerate(p.read_text().splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("/*") or stripped.startswith("*"):
            continue
        if stripped.startswith("//"):
            continue
        for hex_val in HEX_PATTERN.findall(line):
            hits.append((i, hex_val, line.rstrip()))
    return hits


def main() -> int:
    check_all = "--all" in sys.argv

    if check_all:
        result = subprocess.run(
            ["git", "ls-files"] + list(INCLUDE_DIRS),
            capture_output=True,
            text=True,
            cwd=ROOT,
        )
        files = [f for f in result.stdout.splitlines() if is_target(f)]
        extract = lint_full_file
    else:
        files = [f for f in staged_files() if is_target(f)]
        extract = extract_added_hex

    if not files:
        return 0

    violations: dict[str, list[tuple[int, str, str]]] = {}
    for f in files:
        hits = extract(f)
        if hits:
            violations[f] = hits

    if not violations:
        return 0

    mode = "every tracked file" if check_all else "newly added lines"
    print(f"raw hex color lint — scanning {mode}\n")
    total = 0
    for path, hits in violations.items():
        print(f"  {path}")
        for line_no, hex_val, line in hits[:10]:
            trimmed = line.strip()[:100]
            print(f"    L{line_no}: {hex_val}  →  {trimmed}")
            total += 1
        if len(hits) > 10:
            print(f"    ... and {len(hits) - 10} more")
            total += len(hits) - 10
        print()

    print(f"{total} raw hex value(s) found.")
    print("Replace with var(--token) references from system/tokens.css,")
    print("or extend system/tokens.json with a new token and rerun")
    print("python3 tools/build-tokens.py.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
