#!/usr/bin/env python3
"""Merge the repo copy of opencode.jsonc INTO the local opencode config.

Semantics (repo -> local):
  - same fields: repo value overwrites local
  - local-only fields: preserved
  - repo-only fields: inserted at the end
  - nested objects merged per-field; arrays replaced wholesale

Comments in the local file are stripped on write. A timestamped backup of the
local file is created before overwriting.
"""
import json
import os
import shutil
import sys
import time
from pathlib import Path


def strip_jsonc(text: str) -> str:
    """Remove // and /* */ comments while respecting string literals."""
    out, in_str, i, n = [], False, 0, len(text)
    while i < n:
        c, nxt = text[i], text[i + 1] if i + 1 < n else ""
        if in_str:
            out.append(c)
            if c == "\\":
                out.append(nxt)
                i += 2
                continue
            if c == '"':
                in_str = False
            i += 1
            continue
        if c == '"':
            in_str = True
            out.append(c)
            i += 1
            continue
        if c == "/" and nxt == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if c == "/" and nxt == "*":
            i += 2
            while i < n and not (text[i] == "*" and i + 1 < n and text[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(c)
        i += 1
    return "".join(out)


def deep_merge(target: dict, source: dict) -> None:
    """source wins per-field; target keeps key order, source-only keys appended."""
    for k, v in source.items():
        if k in target and isinstance(target[k], dict) and isinstance(v, dict):
            deep_merge(target[k], v)
        else:
            target[k] = v


def target_path() -> Path:
    if os.name == "nt":
        base = Path(os.environ["USERPROFILE"]) / ".config"
    else:
        base = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config")))
    return base / "opencode" / "opencode.jsonc"


def load(path: Path) -> dict:
    with open(path, encoding="utf-8") as f:
        return json.loads(strip_jsonc(f.read()))


def main(argv: list[str]) -> int:
    if argv[:1] == ["--test"]:
        return self_test()
    repo = Path(__file__).resolve().parent / "opencode.jsonc"
    local = target_path()
    if not repo.exists():
        print(f"source not found: {repo}", file=sys.stderr)
        return 1
    src = load(repo)
    if local.exists():
        tgt = load(local)
        shutil.copy2(local, local.with_name(f"{local.name}.bak-{time.strftime('%Y%m%d-%H%M%S')}"))
    else:
        tgt = {}
    deep_merge(tgt, src)
    local.parent.mkdir(parents=True, exist_ok=True)
    with open(local, "w", encoding="utf-8") as f:
        json.dump(tgt, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"synced -> {local}")
    return 0


def self_test() -> int:
    tgt = {"agent": {"plan": {"model": "old", "keep": 1}}, "local_only": True}
    src = {"agent": {"plan": {"model": "new"}}, "new_from_src": 2}
    deep_merge(tgt, src)
    assert tgt == {
        "agent": {"plan": {"model": "new", "keep": 1}},
        "local_only": True,
        "new_from_src": 2,
    }, "deep_merge semantics broken"
    stripped = strip_jsonc('{"a": "//not comment", /* c */ "b": 1 // tail\n}')
    assert json.loads(stripped) == {"a": "//not comment", "b": 1}, "strip_jsonc broken"
    print("ok")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
