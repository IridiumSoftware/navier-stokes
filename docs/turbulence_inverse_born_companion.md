# Companion — the inverse-Born obstruction over the turbulence cascade family

**2026-06-01.** Pushing the inverse-Born further (after `turbulence_nogo_map.jl`), now
applying the closure-v5 **inverse-Born obstruction methodology** verbatim (Aaron Green,
Apr 2026 — `closure-v5 BUSINESS/inverse_born_methodology.md`). The descriptive map showed
*where* the measured spectrum sits; this **derives the cascade by obstruction** — uses the
observed structure to *forbid* mechanisms, with strict invariant stratification and
anti-anchoring discipline. **Scope: EMPIRICAL phenomenology + the exact 4/5 law +
realizability no-go's. NOT the 3D-NS PDE; `:proved`=0; the prize was not the target.**

## §1 — Computational basis

- **Source (new):** `scripts/turbulence_inverse_born.jl` (+ `.out.txt`). Std-lib Julia (`Printf`).
- **Methodology imported (closure-v5):** (i) the *flip* — ask "what is consistent /
  forbidden?", not "what does it produce?"; (ii) *invariant stratification* (§5) — a
  constant is a HARD constraint only if frame-independent across time/scale/scope/resolution;
  frame-dependent numbers are convergence targets, never anchors; (iii) *null-as-clarification
  + phase promotion* (§3.3); (iv) *anti-anchoring* (§9) — match structure, not numbers.
- **The classified family:** K41 (monofractal), log-normal (Kolmogorov–Obukhov 1962),
  β-model (Frisch–Sulem–Nelkin), log-Poisson (She–Lévêque). `ζ_p` formulas + derivatives.
- **Run:** `julia scripts/turbulence_inverse_born.jl`.

## §2 — Results

**Panel A — invariant stratification (the gate).** Only five invariants are
frame-independent enough to use as HARD constraints: `ζ_3=1` (4/5 law, exact-from-NS),
`D≤3` (definitional), `ζ_p` nondecreasing+concave (realizability), CKN ≤1D
(resolution-protected theorem), and the codim-2 filament *integer* (structural, model-level,
CKN-consistent). The numbers — `C_K≈1.6`, `μ≈0.2`, the `ζ_{p≥4}` values, `κ≈0.41`, `C_ε≈0.5`
— are convergence targets, explicitly **not** anchored on.

**Panel B — the obstruction (HARD constraints only).**

| model | ζ₃=1 | ζ′≥0 | D≤3 | D≥0 | verdict |
|---|---|---|---|---|---|
| K41 (monofractal) | yes | yes | yes | yes | ALLOWED (degenerate, D=δ(h−⅓)) |
| **log-normal (K62)** | yes | **NO** (p*≈16.5) | yes | **NO** | **FORBIDDEN** |
| β-model (D_F=2.8) | yes | yes | yes | yes | ALLOWED* (monofractal, linear ζ_p) |
| log-Poisson (SL) | yes | yes (≥⅑) | yes | yes | **SURVIVES** |

- **log-normal is forbidden by two independent HARD violations:** `ζ′_p = ⅓ − (μ/18)(2p−3)`
  goes negative for `p > p* = 3/μ + 3/2` (≈16.5 at μ=0.20, ≈13.5 at μ=0.25) — `ζ_p` turns
  *down*, impossible for bounded increments; and `D(h) = 3 − (9/2μ)(h−h₀)²` goes negative
  (negative dimension). A clean structural null (cf. closure-v5 P2-A/P2-B).
- **β-model** passes every hard constraint but is linear (monofractal) — disfavored only at
  the convergence layer (measured `ζ_p` are concave). Flagged `*`: a frame-dependent
  distinction, **not** a structural forbiddance.
- **log-Poisson (She–Lévêque)** survives: monotone, concave, `ζ_3=1`, bounded `h_min=⅑`,
  and `D(h_min)=1` **exactly** by the codim-2 construction (=1.058 at the p=40 truncation,
  →1 from above as p→∞) — it *meets the CKN ≤1D edge exactly*. It survives because it is
  built on structural **integers** (codim-2 = 1-D filaments; the log-Poisson hierarchy),
  not on fitted numbers.

**Panel C — the verdict.** The null (log-normal forbidden) is a possibilistic-layer result:
realizability alone kills it, at every Re, in every flow — phase-promoting "why not
log-normal" from "data disfavor it" to "structurally impossible." Among the survivors, only
the *convergence layer* (concavity + CKN-saturation) selects log-Poisson, and that selection
is explicitly the weaker, frame-dependent layer — not promoted to structural. **What is
actually forced (structure, not numbers):** every admissible cascade has `ζ_3=1` (the 4/5
tangent), monotone-concave `ζ_p`, and a most-singular end at `D≤1` (CKN); the surviving
multifractal class meets these via the codim-2 filament integer.

## §3 — Verification

**Type — algebraic + computed.**
- *Exact / structural:* `ζ_3=1` (4/5 law); the log-normal turnover `p* = 3/μ + 3/2` (exact
  in μ); `D≥0` violation of log-normal (negative-dimension, exact); β-model slope
  `(D_F−2)/3` (exact); SL monotonicity `ζ′≥⅑>0` and `D(h_min)=1` by codim-2 (exact).
- *Computed:* the per-model PASS/FAIL grid; the SL monotonicity scan over p∈[0,30]; the
  finite-p (p=40) approach `D(h_min)=1.058→1`.
- *Anti-anchoring check:* no model parameter was tuned to a measured number; `C_K, μ, κ,
  C_ε` entered only as a post-hoc convergence note among structural survivors.

**Honest scope.** The hard structural layer FORBIDS exactly one model (log-normal) and
leaves a family (K41/β/log-Poisson). The selection of log-Poisson among survivors is a
*convergence-layer* (frame-dependent) statement and is labeled as such — not upgraded to a
structural result on the strength of numbers. Nothing here touches the PDE.

## §4 — Spec impact

Strengthens the candidate **NS-037** (possibilistic / inverse-Born map): adds the
*obstruction* layer (the cascade-model family + the log-normal structural null + the
survivor pinned by structural integers) on top of the descriptive map. Still **deferred**
as a formal entry (owner's call); for now this companion + script + the v0.1.26 map
constitute the inverse-Born deliverable. If NS-037 is formalized, evidence = algebraic +
computed; Status `:argued`; Depends_on NS-006 (CKN), NS-009 (Onsager/4-5), NS-036.

*Firewall: empirical phenomenology + the exact 4/5 law + realizability no-go's; not the
PDE; `:proved`=0; the prize was not the target. Methodology: closure-v5
`inverse_born_methodology.md`. Metabolized by Claude, 2026-06-01.*
