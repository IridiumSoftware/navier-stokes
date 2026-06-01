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
| **T-01** Burgers δ(t) | **PASS.** Spectrum-fitted δ(t) matches the exact inviscid closed form `arccosh(1/t)−√(1−t²)` to ≤4.1% (t=0.3–0.95); shock exponent 1.519 (theory 1.5); viscous δ bounded. `burgers_analyticity_strip.jl`. | closed-form |
| **T-02** spectrum ↔ strip | **PASS (inviscid).** The Fourier-spectrum decay rate equals the analytically-tracked nearest-singularity distance `δ(t)=Im x*`, `ξ*=i·arccosh(1/t)`. | cross-method |
| **T-03** truncation honesty | **PASS (with correction).** Stage 1b (CLM): δ_spectral N-robust to <0.1% for N∈{512,1024,2048} through t=1.98 (δ→0.010). A *predicted* small-N breakdown did NOT occur — the spectrum-slope fit is robust to cutoff under-resolution (recorded honestly). Error shown vs N; no silent truncation. | convergence |
| **T-04** obstruction co-movement | **PASS (BKM half, CLM).** Stage 1b: δ(t)→0 co-diverges with the BKM integral ∫‖ω‖∞→∞ at the same t*=2 (exact). The NS *critical-norm* (NS-005) half is a 3D-NS test — pending the 3D escalation (no exact benchmark). | cross-method |
| **T-05** 2D regularity control | **PASS.** 2D Euler/NS pseudospectral (`spectral_2d_control.jl`): δ bounded (≥0.23, never→0), BKM finite, and energy+enstrophy+‖ω‖∞ conserved to <1e-6 (Euler, solver-validation) / monotone decay (NS). The diagnostic correctly reports REGULARITY — distinguishing it from CLM blowup (δ→0). Validates the tool before 3D. | exact-invariant + control |
| **T-07** 3D solver validation | **PASS.** 3D pseudospectral Euler (`spectral_3d_control.jl`, rotational form + Leray projection, hand-rolled 3D FFT): on a seeded helical IC, energy AND **helicity** conserved to 0.0000% and `div_max≈1e-12` (N=32, T=3) — the 3D-specific Tier-1 check (vortex stretching live; 2D had none). | exact-invariant |
| **T-06** BKM co-movement gate (3D) | **DEFINED; affirmed in the regular direction.** Any reported 3D δ→0 must co-move with ∫‖ω‖∞→∞ (NS-004), else reject as a resolution artifact. Stage 1c-3D (C): viscous Taylor–Green is regular ⇒ δ bounded (≥0.605) **and** BKM finite (≈14.2) — the two move together in the regular direction. The blowup direction is the Step-2 test. | cross-method (gate) |

**The δ-fit is NOT resolution-robust in the inviscid/under-resolved regime
(honest caveat, Stage 1c-3D panel B).** The exponential-strip slope-fit varies
~50% non-monotonically across N∈{16,32,64} on an inviscid developing-cascade
field, because the fit band `k=2..N/3` is window-sensitive once a power-law range
forms. The *solver* is resolution-robust (energy/helicity exact at every N); the
*δ-slope-fit* is not, in that regime. T-06 + spectral N-convergence (not the
fitted δ alone) are therefore mandatory for any Step-2 δ→0 reading.

**Firewall in testing.** Passing T-01..T-07 promotes NS-010/011 to `:tested` with
`Scope: 1D-model` / `ODE-truncation` / `3D-truncation` — **never** to a PDE
statement. A PDE claim would require a separate convergence/limit argument, which
is out of scope for a diagnostic and would be its own (currently nonexistent)
`:proved` entry.
