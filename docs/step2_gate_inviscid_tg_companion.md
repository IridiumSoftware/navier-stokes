# Companion — Stage 1c-3D Step-2 executed: the gated inviscid-TG δ→0 hunt at N=256↔512 (NS-010)

**Session date:** 2026-06-04. **Owner:** Aaron Green.
**Scope firewall:** `:proved`=0. Resolved inviscid 3D pseudospectral Euler *truncation* — NOT
the 3D-NS PDE. This is the **dangerous step** (searching for δ→0 = loss of analyticity), designed
around NOT producing a false positive. The honest default verdict is **NULL/INCONCLUSIVE**.

---

## §1 — Computational basis

NS-010's priority-stack `[NEXT]` item was Stage 1c-3D **Step 2**: a blowup-candidate IC in the
*open* regime (enstrophy not coercive), watching whether δ(t)→0 — gated so a δ-decline counts as
evidence only under strict conditions. The CPU prototype (`spectral_3d_blowup_candidate.jl`) ran
at N=32/64 and was *inconclusive by design* at that resolution. The GPU solver
(`metal/dns_gpu.swift`) makes the controlling comparison **N=256↔512** feasible (~40 min/run).

**The candidate:** inviscid Taylor–Green (Brachet Euler), ν=0 — the canonical Euler
near-singularity probe (H≡0, unopposed vortex stretching). Run at N=256 and N=512, T=7,
dt=0.005. Scalar diagnostics (E/E0, winf) every 0.1; spectral-field snapshots at
t=3.0–6.5 for the δ(t) trajectory (δ-only fast load, `NS_DELTAONLY=1`).

**The gate** (formalized in `TEST_SPEC.md` T-06 + T-08; applied by `scripts/step2_gate.jl`):
- **G1 RESOLVED** — δ·k_cut > 6 (analyticity strip wider than the grid scale; the *leading*
  resolution test). Energy-leak is the *lagging* one.
- **G2 CONVERGED** — the *spectrum* (not just the fitted δ) agrees across N=256↔512.
- **G3 CO-MOVING** — δ→0 co-diverges with BKM ∫‖ω‖∞→∞ at a common finite t*.
- **FORM** — `δ/(−δ̇)`: constant ⇒ exponential (t*=∞, REGULAR); linear-to-zero ⇒ finite t*.
- **T-08** — CKN dimension guard (box-dim ≤1 AND N-stable), calibrated by NS-039.

---

## §2 — Results

Energy is conserved to ~1e-6 well into the run (N=256 wall ≈ t=5.9; N=512 leaks earlier, t≈5.2,
because it resolves a *more intense* cascade). The δ·k_cut>6 (strict) common resolved window is
**t ≤ 4.5**. In it:

| t | δ (N=256) | δ (N=512) | |Δ|/δ |
|---|---|---|---|
| 3.0 | 0.139 | 0.080 | 42% |
| 3.5 | 0.115 | 0.067 | 42% |
| 4.0 | 0.092 | 0.049 | 46% |
| 4.5 | 0.078 | 0.041 | 48% |

**Gate verdict: INCONCLUSIVE / regular-leaning.**
- **G2 FAILS:** the full-band δ-fit differs **42–48%** between N=256 and N=512 *even in the
  resolved window* — the documented window-sensitivity (the cascade spectrum is not a pure
  exponential, so the slope depends on the band length). A δ→0 read from the raw fit would be a
  resolution artifact; the gate correctly refuses it.
- δ extrapolates to t*=∞ (no finite-time δ→0); winf grows toward t*≈4.7 but δ does **not**
  co-move (G3 fails). The decline decelerates (log δ ≈ linear in t) — exponential, the regular
  signature, consistent with the literature (Brachet Euler TG: no finite-time singularity).
- T-08 is moot (verdict already NULL).

This **extends the old N=32/64 "inconclusive by design" to real N=256↔512 resolution with the
full multi-condition gate** — and validates the gate itself (G2 catches the non-convergence).

---

## §3 — Verification

- δ via the validated `delta_shell` (NS-010, same as the CPU runs); δ-only loader mode reuses it.
- The gate criteria are explicit and mechanical (`step2_gate.jl`); default NULL.
- **Evidence type: computed** (resolved inviscid-Euler truncation; gate applied at N=256↔512).
  **NOT** a PDE statement; no `:proved` content. The honest result is a *negative/inconclusive*:
  no trustworthy finite-time δ→0 at accessible resolution.

---

## §4 — Spec impact

Updates **NS-032** (Stage 1c-3D Step-2 gated blowup hunt — NULL): extends its N=32/64/128 NULL
to the **N=256↔512** the entry itself called for, with the full T-06/T-08 gate ⇒ **INCONCLUSIVE
/ regular-leaning** (δ-fit not N-converged, 42–48% across N; no co-moving finite-time δ→0). No
new spec entry (status update to NS-032). New
infrastructure: `scripts/step2_gate.jl`, the δ-only loader mode, TEST_SPEC T-06 (sharpened) +
T-08 (new, CKN dimension guard calibrated by NS-039). Source/evidence: `metal/euler_tg{256,512}.txt`,
`metal/delta_tg{256,512}.dat`. Scope: resolved truncation — NOT the PDE; `:proved`=0.
