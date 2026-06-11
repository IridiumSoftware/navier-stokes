#!/usr/bin/env bash
# check_ledger_counts.sh — ledger count/stamp parity guard.
#
# WHY: the SPEC entry count + version stamp drifted out of sync with dashboard.md /
# CLAUDE.md when new entries landed (e.g. NS-051), and an A0–A7 cross-audit caught the
# same "35 vs 36 / v0.11.1 vs v0.12.0" drift *twice* (2026-06-09, 2026-06-10). Per the
# CLAUDE.md close-out clause, a recurrence escalates from hand-fixing to a pre-commit
# guard — this is it.
#
# WHAT it checks (working-tree files; std POSIX tools only, no deps):
#   1. COVERAGE  — SPEC entry-headers (**NS-0XX —) == registry rows (| NS-0XX |).
#   2. COUNT     — the "(N entries)" / "SPEC N entries" / "N ledger entries" claims in
#                  SPEC.md / dashboard.md / CLAUDE.md all equal the actual entry count.
#   3. STAMP     — the SPEC header version (**vX.Y.Z) == the CLAUDE.md Status (…, vX.Y.Z).
#                  (This is the SPEC-ledger stamp, NOT the changelog repo version.)
#
# Exit 0 = consistent (commit proceeds). Exit 1 = a real mismatch (commit blocked;
# bypass with `git commit --no-verify`). A missing claim is a loud WARN, not a block,
# so a phrasing change degrades to "please re-anchor", never a false block.
#
# Run standalone for an audit:  bash scripts/check_ledger_counts.sh
# CLAUDE.md is gitignored/local; its checks are skipped if the file is absent.
set -u

ROOT="${LEDGER_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || echo .)}"
SPEC="$ROOT/SPEC.md"; REG="$ROOT/artifact_registry.md"
DASH="$ROOT/dashboard.md"; CLA="$ROOT/CLAUDE.md"
fail=0; warn=0

# first integer matched by pattern $1 in file $2 (empty if no match)
num() { grep -oE "$1" "$2" 2>/dev/null | head -1 | grep -oE '[0-9]+' | head -1; }

# --- structural truth: actual entry count ---
entries=$(grep -cE '^\*\*NS-0[0-9][0-9] ' "$SPEC" 2>/dev/null)
rows=$(grep -cE '^\| NS-0[0-9][0-9]' "$REG" 2>/dev/null)
echo "ledger-guard: SPEC entry-headers=$entries  registry-rows=$rows"
if [ "$entries" != "$rows" ]; then
  echo "  X COVERAGE: SPEC entries ($entries) != registry rows ($rows) — every entry needs a row"
  fail=1
fi
truth="$entries"

# --- claimed counts must equal truth ---
check_count() {  # $1=label/file  $2=claimed
  if [ -z "$2" ]; then
    echo "  ! WARN: no entry-count claim found in $1 (re-anchor the grep in this script)"; warn=1
  elif [ "$2" != "$truth" ]; then
    echo "  X COUNT: $1 says $2 entries, actual is $truth"; fail=1
  fi
}
check_count "SPEC.md"      "$(num '\([0-9]+ entries' "$SPEC")"
check_count "dashboard.md" "$(num 'SPEC [0-9]+ entries' "$DASH")"

# --- CLAUDE.md (gitignored/local; skip cleanly if absent) ---
if [ -f "$CLA" ]; then
  check_count "CLAUDE.md" "$(num '[0-9]+ ledger entries' "$CLA")"
  spec_v=$(grep -m1 -oE '\*\*v[0-9]+\.[0-9]+\.[0-9]+' "$SPEC" | grep -oE 'v[0-9.]+')
  cla_v=$(grep -m1 -oE 'Status \([0-9-]+, v[0-9]+\.[0-9]+\.[0-9]+' "$CLA" | grep -oE 'v[0-9.]+')
  if [ -n "$spec_v" ] && [ -n "$cla_v" ] && [ "$spec_v" != "$cla_v" ]; then
    echo "  X STAMP: SPEC header $spec_v != CLAUDE.md Status $cla_v"; fail=1
  fi
fi

if [ "$fail" = 1 ]; then
  echo "ledger-guard: FAIL — fix the count/stamp drift above, or 'git commit --no-verify' to bypass."
  exit 1
fi
[ "$warn" = 1 ] && echo "ledger-guard: passed WITH WARNINGS (see above)."
echo "ledger-guard: OK ($truth entries, counts + stamp consistent)."
exit 0
