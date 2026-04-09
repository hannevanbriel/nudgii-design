#!/usr/bin/env python3
"""
Tiny tokens.json file watcher.

Polls system/tokens.json once per second. Whenever its mtime changes,
re-runs tools/build-tokens.py. No external dependencies — pure stdlib so
you don't need pip install anything.

Usage:
    python3 tools/watch-tokens.py

Stop with Ctrl-C. Leave it running in a background terminal while you
edit tokens.json — every save triggers an automatic rebuild and you just
reload the browser.
"""

from __future__ import annotations

import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOKENS = ROOT / "system" / "tokens.json"
BUILD = ROOT / "tools" / "build-tokens.py"
POLL_INTERVAL = 1.0  # seconds


def now() -> str:
    return time.strftime("%H:%M:%S")


def run_build() -> None:
    print(f"[{now()}] tokens.json changed → rebuilding…")
    result = subprocess.run(
        [sys.executable, str(BUILD)],
        capture_output=True,
        text=True,
    )
    if result.stdout:
        for line in result.stdout.rstrip().splitlines():
            print(f"          {line}")
    if result.returncode != 0:
        print(f"[{now()}] build FAILED ({result.returncode})")
        if result.stderr:
            for line in result.stderr.rstrip().splitlines():
                print(f"          ! {line}")


def main() -> None:
    if not TOKENS.exists():
        print(f"tokens.json not found at {TOKENS}")
        sys.exit(1)
    if not BUILD.exists():
        print(f"build script not found at {BUILD}")
        sys.exit(1)

    print(f"[{now()}] watching {TOKENS.relative_to(ROOT)}")
    print(f"[{now()}] press Ctrl-C to stop")

    last_mtime = TOKENS.stat().st_mtime
    # Initial build so first run is consistent.
    run_build()

    try:
        while True:
            time.sleep(POLL_INTERVAL)
            try:
                mtime = TOKENS.stat().st_mtime
            except FileNotFoundError:
                continue
            if mtime != last_mtime:
                last_mtime = mtime
                run_build()
    except KeyboardInterrupt:
        print(f"\n[{now()}] stopped.")


if __name__ == "__main__":
    main()
