# TEST_SPEC.md — verification discipline for computational claims

A `computed`/`:tested` entry is trustworthy only if its script **reproduces a
quantity with an independent check** — a known closed form, an exact invariant, a
cross-method agreement, or a published number. This file lists, per claim, the
check that licenses its status. A script that does not pass its row must not have
its spec entry promoted.

Tiers of check (strongest first):
- **exact-invariant** — a conserved quantity held to machine precision.
- **closed-form** — agreement with an analytic solution.
- **cross-method** — two independent computations agree.
- **published-number** — reproduces a value from the literature.
- **qualitative-signature** — reproduces a known qualitative behavior (weakest;
  only licenses a guarded `:tested`).

## Existing claims (this arc)

| ID | Check (tier) | Status of check |
|---|---|---|
| NS-020 (homology falsified) | closed-form: b₁(𝕋³)=3, b₁(box)=0 at every refinement; Hodge-L₁ has exactly 3 zero modes then a spectral gap; harmonic = constant-flux fields exactly (∂₁h=∂₂ᵀh=0). | PASS (in `.out.txt`) |
| NS-021 (MFE saddle) | published-number + qualitative: laminar fixed point exact (‖RHS‖=0); memoryless lifetimes (survival R²=0.99, CV≈1); τ(Re) two estimators (survival-fit vs censoring-aware MLE) agree ~5%. | PASS, **Scope ODE-truncation** |
| NS-022 (helical triad) | exact-invariant: energy & helicity conserved to ~1e-13; conservation-fixed recipient split matches simulation to 3 digits. | PASS |
| NS-023 (autopoietic / (M,R) gate) | exact (8-state CTMC committor solved exactly); pre-registered prediction (S>A>F) confirmed; **null control** (symmetric cycle → no gate); rotation: committor triple identical, cyclically permuted. | PASS, **Scope abstract-closure** |
| NS-023 (B-universality) | cross-check: box-parameterized RHS bit-identical to verified `mfe!` at standard box (max|Δ|=0). | PASS |
| NS-024 (convergence) | external-witness: 3 independent seats (Grok/Gemini/ChatGPT) converged on the trim. | PASS (witnessed; argued) |

## Pending checks for the live attack (NS-010/011)

| ID | Required check before promotion | Tier |
|---|---|---|
| **T-01** Burgers δ(t) | Computed analyticity-strip width / nearest complex pole must match the **Cole–Hopf closed form** for the pole trajectory (viscous: poles stay off real axis; inviscid: reach it at the shock time). | closed-form |
| **T-02** spectrum ↔ strip | The fitted exponential decay rate of the Fourier spectrum must equal the independently-tracked nearest-singularity distance `δ(t)` (two methods agree). | cross-method |
| **T-03** truncation honesty | Report resolution-dependence: `δ(t)` and the BKM integral must be shown vs truncation `N`; a result that drifts with `N` is flagged, not promoted. No silent truncation. | qualitative + convergence |
| **T-04** obstruction co-movement | As `δ(t)→` small, the BKM integral (NS-004) and a critical norm (NS-005) must grow consistently with the theory; inconsistency = bug, not blowup. | cross-method |

**Firewall in testing.** Passing T-01..T-04 promotes NS-010/011 to `:tested` with
`Scope: 1D-model` / `ODE-truncation` — **never** to a PDE statement. A PDE claim
would require a separate convergence/limit argument, which is out of scope for a
diagnostic and would be its own (currently nonexistent) `:proved` entry.
