#!/usr/bin/env bash
# Prints what Maestro sees on a device: every text, label and hint, in order.
#   tool/e2e/screen.sh <device-id>
set -euo pipefail
maestro --device "$1" hierarchy 2>/dev/null | python3 -c '
import json, sys
tree = json.load(sys.stdin)
out = []
def walk(node):
    a = node.get("attributes", {})
    text = a.get("text") or a.get("accessibilityText") or a.get("hintText") or ""
    if text:
        out.append(text.replace("\n", " ")[:90] + ("  @" + a.get("bounds", "") if "--bounds" in sys.argv else ""))
    for child in node.get("children", []):
        walk(child)
walk(tree)
print("\n".join(out))
' "${@:2}"
