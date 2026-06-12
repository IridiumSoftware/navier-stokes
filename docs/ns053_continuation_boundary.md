# NS-053 — Hyperdissipation α-continuation boundary

**Date:** 2026-06-12. **Status:** `:open`. **Scope:** PDE-analysis instrument (≠ PDE).
**:proved`=0; distance UNTOUCHED.**

**Canonical witness repo:** `~/grok-test` (GO-023/024). This doc is the obstruction-ledger port.

---

## Statement

Characterize what **kills** profile stabilization as (α,d) → (3,1) from the hyperdissipation side:

- **α** — dissipation order ν(−Δ)^α (Katz–Pavlović partial regularity for 1<α<5/4)
- **d / n** — Hou generalized axisym **n = 1 + 2R/Z** (2405.10916) — **FALSIFIED as 1D proxy**

True NS: α=1 < 5/4 regularity rail.

---

## Witness history (2026-06-12)

| Phase | Artifact | Verdict |
|---|---|---|
| GO-023 v1 | λ-distortion d_eff | LIVE α; d-proxy ≠ Hou |
| GO-023 moves 1–3 | Hou n = 1+2ρ + HL port | **Hou n FALSIFIED** on CLM + HL |
| GO-024 | α-only v2 | active fork |

**Program kill #1 (met):** Hou n-continuation is proxy artifact → **drop n-family, α-only.**

**Live signal:** α_eff sweep on CLM — rigidity lost above α≈1.08 (before α=5/4).

---

## Anchors (tier)

| Anchor | Tier | Source |
|---|---|---|
| Katz–Pavlović Hausdorff bound (1<α<5/4) | **C2** | math/0104199 |
| α≥5/4 global regularity @ d=3 | **C1** | folklore; line-read pending |
| Hou n→3.188 | **C2/numerical** | 2405.10916 — **not confirmed by GO proxy** |

See `~/grok-test/docs/go024_katz_line_read.md`, `go023_hou_line_read.md`.

---

## Kill criteria

1. ~~Hou n-proxy confirms stabilization~~ → **MET (negative)** — drop n-family
2. α-boundary indistinguishable from regular interior → watch on GO-024
3. α mechanism already in literature → citation + port only

`:proved`=0.