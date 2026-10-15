"""Builds build/e2e/<run>/report.md from a run of tool/e2e/run_e2e.sh.

For every protocol ID (LT-TP-100) it shows the result on iOS and Android:
Maestro flows from their JUnit XML, Flutter tests from the E2E_RESULTS line.

    python3 tool/e2e/report.py build/e2e/<run>
"""
import os
import re
import sys
import xml.etree.ElementTree as ET

PROTOCOL = [
    ("INS-02", "Onboarding"),
    ("INS-03", "Demo wall"),
    ("WAL-01", "Add a memory with photos"),
    ("WAL-02", "Photo permission"),
    ("WAL-03", "Move around the wall"),
    ("WAL-04", "Connect two memories with a thread"),
    ("WAL-05", "Open, edit and delete"),
    ("WAL-06", "Timeline and map"),
    ("WAL-07", "People and places"),
    ("WAL-08", "Free limit"),
    ("WAL-09", "Search, walls and hidden memories"),
    ("WAL-10", "Edit pencils, rename and delete a wall"),
    ("WAL-11", "Unfinished memory kept as a draft"),
    ("WAL-12", "Look back on a month"),
    ("WAL-13", "Home screen widget"),
    ("PRM-01", "Premium page"),
    ("PRM-02", "Subscribe"),
    ("PRM-03", "Restore"),
    ("PRM-04", "Redeem a promo code (Android)"),
    ("STO-01", "Choose memories"),
    ("STO-02", "Story image"),
    ("STO-03", "Reorder, add, remove"),
    ("STO-04", "Video with music"),
    ("STO-05", "Share and save"),
    ("YR-01", "Thread of the Year"),
    ("OTD-01", "On this day"),
    ("FAM-01", "Sign in and create a family wall"),
    ("FAM-02", "Invite and join"),
    ("FAM-03", "Share memories in the family"),
    ("FAM-04", "Report, block, remove"),
    ("FAM-05", "Delete the account"),
    ("BAK-01", "Back up everything"),
    ("BAK-02", "Restore a backup"),
    ("BAK-03", "Send one memory as a capsule"),
    ("BAK-04", "Show the wall on a big screen"),
    ("SET-01", "Themes and name"),
    ("SET-02", "Language and text size"),
    ("SET-03", "Offline and restart"),
    ("SET-05", "App lock"),
    ("SET-04", "Overall impression"),
]

# Not automatable on a simulator; a person tests these with the protocol.
MANUAL = {
    "PRM-04": "Needs the Play Store app with a Google account.",
    "BAK-03": "The capsule link opens on a second device.",
    "BAK-04": "Scanning a QR code needs a camera.",
    "SET-04": "A person's impression.",
    "WAL-13": "Widgets are added on the home screen by hand.",
}


def ids_in(name):
    """Protocol IDs a test covers, from names like 'WAL-03/04/05' or 'STO-01..05'."""
    found = []
    for prefix, first, rest in re.findall(r"([A-Z]{2,3})-(\d{2})((?:(?:/|\.\.)\d{2})*)", name):
        numbers = [int(first)]
        for sep, num in re.findall(r"(/|\.\.)(\d{2})", rest):
            if sep == "..":
                numbers.extend(range(numbers[-1] + 1, int(num) + 1))
            else:
                numbers.append(int(num))
        found += [f"{prefix}-{n:02d}" for n in numbers]
    return found


def suite_platform(suite, out):
    """iOS or Android for a JUnit test suite, from its device."""
    device = suite.get("device", "")
    ios_udid = open(os.path.join(out, ".ios_device")).read().strip() if os.path.exists(os.path.join(out, ".ios_device")) else ""
    if "iPhone" in device or "iPad" in device or (ios_udid and ios_udid in device):
        return "iOS"
    return "Android"


def maestro_results(path, out, platform_name):
    results = {}
    if not os.path.exists(path):
        return results
    root = ET.parse(path).getroot()
    suites = [root] if root.tag == "testsuite" else list(root.iter("testsuite"))
    cases = [case for suite in suites if suite_platform(suite, out) == platform_name for case in suite.iter("testcase")]
    for case in cases:
        failed = case.find("failure") is not None or case.find("error") is not None
        for pid in ids_in(case.get("name", "")):
            if results.get(pid) != "FAIL":
                results[pid] = "FAIL" if failed else "PASS"
    return results


def flutter_results(path):
    results = {}
    if not os.path.exists(path):
        return results
    with open(path, errors="ignore") as log:
        for line in log:
            if "E2E_RESULTS" in line:
                for pid, value in re.findall(r"([A-Z]{2,3}-\d{2})=(\w+)", line):
                    # Onboarding is only the setup of the Flutter tests.
                    if pid != "INS-02":
                        results[pid] = value
    return results


def platform(out, name):
    merged = maestro_results(os.path.join(out, "maestro-junit.xml"), out, name)
    # The large-text run (iOS) counts for its protocol IDs too.
    for pid, value in maestro_results(
        os.path.join(out, "maestro-large-junit.xml"), out, name
    ).items():
        if merged.get(pid) != "FAIL":
            merged[pid] = value
    for pid, value in flutter_results(os.path.join(out, name, "flutter.log")).items():
        if merged.get(pid) != "FAIL":
            merged[pid] = value
    return merged


def cell(value, pid):
    if pid in MANUAL:
        return "manual"
    return {"PASS": "✅ pass", "FAIL": "❌ fail"}.get(value, "– not run")


def main():
    out = sys.argv[1]
    ios = platform(out, "iOS")
    android = platform(out, "Android")
    lines = [
        f"# LifeThreads E2E report – {os.path.basename(out)}",
        "",
        "Protocol LT-TP-100, run automatically on an iOS simulator and an Android emulator.",
        "",
        "| ID | Test | iOS | Android |",
        "|---|---|---|---|",
    ]
    for pid, title in PROTOCOL:
        lines.append(f"| {pid} | {title} | {cell(ios.get(pid), pid)} | {cell(android.get(pid), pid)} |")
    counts = {
        name: (sum(v == "PASS" for v in res.values()), sum(v == "FAIL" for v in res.values()))
        for name, res in (("iOS", ios), ("Android", android))
    }
    lines += [
        "",
        "| | Passed | Failed |",
        "|---|---|---|",
        *[f"| {name} | {p} | {f} |" for name, (p, f) in counts.items()],
        "",
        "## Tested by a person",
        "",
        *[f"- **{pid}**: {why}" for pid, why in MANUAL.items()],
        "",
        "## Files",
        "",
        "- `maestro/`: screenshots per step and Maestro logs, per device",
        "- `maestro-junit.xml`: Maestro results (one test suite per device)",
        "- `<platform>/flutter.log`: Premium purchase and family wall tests",
    ]
    with open(os.path.join(out, "report.md"), "w") as report:
        report.write("\n".join(lines) + "\n")
    print("\n".join(lines[:6 + len(PROTOCOL) + 6]))


if __name__ == "__main__":
    main()
