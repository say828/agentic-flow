#!/usr/bin/env python3
import json
import sys
from pathlib import Path


def collect_cases(node, bucket):
    if isinstance(node, dict):
        score = None
        identifier = None
        for key in ("diff_ratio", "score", "difference_ratio"):
            value = node.get(key)
            if isinstance(value, (int, float)):
                score = float(value)
                break
        for key in ("screen_code", "id", "name", "case", "route"):
            value = node.get(key)
            if isinstance(value, str) and value.strip():
                identifier = value.strip()
                break
        if score is not None:
            bucket.append((identifier or f"case_{len(bucket)+1}", score, node))
        for value in node.values():
            collect_cases(value, bucket)
    elif isinstance(node, list):
        for item in node:
            collect_cases(item, bucket)


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: analyze_proof_results.py <proof-json>", file=sys.stderr)
        return 1

    path = Path(sys.argv[1])
    if not path.is_file():
        print(f"File not found: {path}", file=sys.stderr)
        return 1

    data = json.loads(path.read_text(encoding="utf-8"))
    cases = []
    collect_cases(data, cases)

    unique = []
    seen = set()
    for identifier, score, raw in sorted(cases, key=lambda item: item[1], reverse=True):
        key = (identifier, score)
        if key in seen:
            continue
        seen.add(key)
        unique.append((identifier, score, raw))

    print(f"proof_file={path}")
    print(f"cases_found={len(unique)}")
    if not unique:
        print("No comparable cases with numeric diff_ratio/score found.")
        return 0

    failing = [item for item in unique if item[1] > 0]
    print(f"failing_cases={len(failing)}")
    best = min(unique, key=lambda item: item[1])
    worst = max(unique, key=lambda item: item[1])
    print(f"best_case={best[0]} score={best[1]:.8f}")
    print(f"worst_case={worst[0]} score={worst[1]:.8f}")
    print("top_failures:")
    for identifier, score, _raw in failing[:10]:
        print(f"- {identifier}: {score:.8f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
