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
| **T-06** Step-2 δ→0 gate (3D, multi-condition) | **DEFINED; affirmed in the regular direction; APPLIED to the inviscid-TG Step-2 hunt at N=256↔512 (NS-032) ⇒ INCONCLUSIVE** (G2 fails: full-band δ-fit 42–48% non-converged across N=256↔512; G3 fails: no co-moving finite t* — the gate correctly refuses a naive δ→0 as a resolution artifact; `scripts/step2_gate.jl`). A reported 3D δ→0 is evidence of approach-to-singularity ONLY if ALL three hold — else the verdict is INCONCLUSIVE (honest default NULL): **G1 RESOLVED** — energy still conserved (inviscid: E/E0≈1, spectral tail below the 2/3 cutoff; δ is meaningless past the resolution wall, where E leaks). **G2 CONVERGED** — the *spectrum itself* (not just the fitted δ) agrees across resolution, now testable at **N=256↔512 on the GPU** (`metal/dns_gpu.swift`); the δ-slope-fit alone is window-sensitive (caveat below). **G3 CO-MOVING** — δ→0 co-diverges with BKM ∫‖ω‖∞→∞ (NS-004). Regular-direction affirmation: viscous Taylor–Green is regular ⇒ δ bounded (≥0.605) **and** BKM finite (≈14.2) — the two move together. | cross-method (multi-condition gate) |
| **T-08** CKN-consistency / dimension N-convergence guard (3D) | **DEFINED (calibrated by NS-039).** A δ→0 candidate's most-intense-production set must be consistent with CKN (NS-006) partial regularity: its box-dimension must be **≤1 AND N-convergent (stable or decreasing under refinement)**. NS-039 supplies the empirical calibration — at the viscous vortex-tube reconnection the top-30% box-dimension *rose* D30 = 0.986 (N=256) → 1.426 (N=512), i.e. a ≤1 reading that does **not** survive refinement is a resolution artifact, not a CKN-admissible singular set. A Step-2 ≤1 touch that *lifts* with N (the NS-039 pattern) is therefore REJECTED; only a ≤1, N-stable/decreasing dimension co-occurring with G1–G3 + T-06 survives the gate. | cross-method (gate; NS-039 calibration) |

**The δ-fit is NOT resolution-robust in the inviscid/under-resolved regime
(honest caveat, Stage 1c-3D panel B).** The exponential-strip slope-fit varies
~50% non-monotonically across N∈{16,32,64} on an inviscid developing-cascade
field, because the fit band `k=2..N/3` is window-sensitive once a power-law range
forms. The *solver* is resolution-robust (energy/helicity exact at every N); the
*δ-slope-fit* is not, in that regime. T-06 (G1–G3) + T-08 (the dimension guard) —
i.e. the *spectrum* and the *singular-set dimension* N-converged, not the fitted δ
alone — are therefore mandatory for any Step-2 δ→0 reading. The earlier
non-convergence was measured at N∈{16,32,64}; the GPU solver now makes the
controlling comparison **N=256↔512** feasible (`metal/dns_gpu.swift`, ~40 min/run),
which is where G2/T-08 acquire teeth — NS-039 demonstrated the method on the
viscous reconnection (D30 0.986→1.426) before it is turned on the open-regime hunt.

## Checks for the geometric / resolved-DNS / GPU entries (NS-031, NS-033, NS-038..040) + active-turbulence (AT-1..4, `SIM_SPEC.md`)

*(T-15..T-22 below license the **active-turbulence phenomenology track** AT-1..7 in `SIM_SPEC.md` — Scope ≠ PDE, ≠ obstruction map.)*

These `:tested` computational entries grew after the original NS-010/011 + closure tables; their
licensing checks, previously recorded only in their SPEC entries + companions, are indexed here.

| ID | Check (tier) | Status of check |
|---|---|---|
| **T-09** NS-031 (TCE self-map) | cross-method: the triadic structure of the ledger is deterministic + reproducible; a programmatic scan of all 64 triads finds **zero** that mix the PDE-analysis tier with the closure tier — an INDEPENDENT engine-side reproduction of NS-024's externally-witnessed "broad/generic, no PDE purchase" verdict. | PASS, **Scope: ledger meta-analysis (not PDE)** |
| **T-10** NS-033 (manifold geometry) | exact-invariant: across the slices, energy/helicity/Casimirs conserved to ~1e-13..1e-15 (coadjoint solver, scaling quotient); Koszul curvature κ≡¼ verified; Arnold-curvature sign census reproduces both Arnold (neg) and Misiołek (pos) results. Honest self-trim: the "a3=gate" reading was REFUTED (two notions, not one). | PASS, **Scope: Euler/NS-truncation geometry (not PDE)** |
| **T-11** NS-038 (resolved-DNS A→B→C) | published-number + cross-method: Brachet-1983 TG Re=1600 enstrophy peak Z/Z0≈27.4 at t≈9 reproduced; FFTW ≡ hand-rolled FFT (bit-equal at N=64, all-physics at N=256); resolved (δ·k_cut≈6.5–7.5). | PASS, **Scope: resolved DNS truncation (not PDE)** |
| **T-12** NS-039 (GPU N=512, RWC-038) | cross-method: float32-GPU ≡ float64-CPU **to 5–6 digits** (TG Brachet Z/Z0=27.3902 vs 27.3901; tubes reconnection D30=0.986 to the digit); div-free (relative max|k·û|/max|û|~1e-6). Verdict: the C reconnection ≤1 box-dim touch lifts 0.986→1.426 with N ⇒ resolution artifact. | PASS (verdict :tested), **Scope: resolved DNS truncation (not PDE)** |
| **T-13** NS-040 (helicity depletion) | cross-method + control: matched-spectrum controlled pair — helical (ρ_H=0.97) vs control (ρ_H=0.05) with IDENTICAL E0=0.125 AND Z0=0.534374; depletion (2–4× slower enstrophy growth) resolution-robust N=256↔512 to 3–4 digits. | PASS, **Scope: resolved DNS truncation (not PDE)** |
| **T-23** NS-045 (Beltramization mechanism audit) | cross-method + control: matched ± helical pair (\|ΔE\|=1.4e-17, \|ΔZ\|=2.2e-16) — the Lamb-vector ratio ⟨\|u×ω\|²⟩/⟨\|u\|²\|ω\|²⟩ = 0.026 (helical) vs 0.69 (control), ~26×, present from t=0; N-converged 16↔64↔128. Mechanism = (b) Beltramization, not (a) ω–S alignment. | PASS, **Scope: resolved DNS truncation (not PDE)** |
| **T-24** NS-050 (dynamic-rescaling witness) | closed-form: the modulation fit recovers the EXACT CLM self-similar profile Φ(η)=−4η/(1+4η²) (‖U−Φ‖_L2 halves each step), center x₀=π/2, rate (T*,p)=(2.00,1.00) — from both the exact solution and the pseudospectral solver, N-robust (N=1024/2048/4096). Validates the INSTRUMENT only. | PASS, **Scope: 1D-model / within-truncation (not PDE)** |
| **T-25** NS-050 mapped-grid ℝ-operators | closed-form: cot-map ξ=L·cot(θ/2) — ∂_ξ and the **dilation ξ∂_ξ** (impossible on a periodic box) match exact derivatives of ξ/(1+ξ²) to ~1e-11; the **line-Hilbert H_ℝ** matches BOTH closed-form pairs H[1/(1+ξ²)]=ξ/(1+ξ²) and H[ξ/(1+ξ²)]=−1/(1+ξ²) to ~1e-14, N∈{1024,2048,4096}. `scripts/ns050_mapped_grid.jl`. | PASS (machine precision), **Scope: numerical-tooling (not PDE)** |
| **T-26** NS-050 Hou–Luo β (2nd calibration of T-24) | published-number: the faithful 1D HL model blows up self-similarly; the two-scale instrument reads β=dlnℓ/dlnλ=**2.47**, INSIDE the proven Chen–Hou–Huang band c_l∈(2,4.53) — an anomalous (β≫1) calibration point beyond CLM's β=1. `scripts/ns050_houluo_hl.jl`. | PASS, **Scope: 1D-model / within-truncation (not PDE)** |
| **T-14** NS-013 reality-ladder (validation only — does NOT license a `:tested` claim) | closed-form/cross-method on the *solvers*: complex-Burgers λ=0 blowup ≡ Cole–Hopf t\*=5.49; CLM large-λ ≡ real-CLM t\*=2.0; 3D complex IC div-free to 5e-13. **NOTE:** the ladder's *criticality-gradient interpretation* is **triad-witness-REFUTED** (definitional / mode-density artifact). NS-013 is `:argued` (a reduction), not `:tested`; this row records that the solvers are sound while the gradient is NOT evidence. | solvers PASS; gradient REFUTED — **Scope: model truncation, not PDE** |
| **T-15** AT-1 (faithful fluid — invariants) | exact-invariant: unforced inviscid 2D Euler (ν=0,f=0) conserves energy AND enstrophy to **1.3e-14** over T=4 (N=128) — the 2D Tier-1 invariants, a regression of T-05 on the IF-RK4 kernel. | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-16** AT-1 (faithful fluid — viscous closed form) | closed-form: a single Fourier mode (exact 2D-Euler steady state, u·∇ω≡0) decays as `exp(−ν\|k\|²t)` to **7.3e-16** relative error — the integrating-factor viscosity (IF-RK4) is machine-exact, licensing the `ν∇²` fix over fluoddity's uniform drag. | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-17** AT-2 (forced control — dual cascade) | published-number/qualitative-signature: the faithful fluid under steady band-limited forcing (N=128, k_f=8) reaches a statistically steady state with a **clean forward enstrophy cascade E(k)~k^−3** (measured slope −3.36, R²=0.99, k∈[10,25]) — the universal Kraichnan exponent, distinct from a shallow inverse range (+0.4). The −5/3 inverse-inertial range is resolution-deferred (N≥256). | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-18** AT-3 (active agents — momentum neutrality) | exact-invariant: the discrete active-dipole forcing injects net grid momentum **relative 9.5e-18 (machine zero)** — the defining net-zero property of an active swimmer — while a monopole reference (head force, no tail) injects O(1) (relative 3.7e-2). Plus a stable 1500-step coupled run (E/Z bounded, finite). | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-19** AT-4 (organization census — honest NULL) | qualitative-signature (NULL): in a vigorous active flow (u_rms≈0.6>swim, 42% vortex-dominated), the agent pair-correlation g(r)≈1.0 everywhere for brain-agents AND the dumb-swimmer control (ratio 1.00) — **no clustering**. The NULL is licensed by the brain-vs-dumb control + the Okubo–Weiss flow check. The chemotaxis variant is explicitly UNTESTED (flagged). | PASS (NULL recorded), **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-20** AT-5 (chemotaxis — clustering vs control) | qualitative-signature + control: adding density-aggregation steering on the same faithful incompressible fluid, the agent pair-correlation **g(r) peaks 4.0× at contact** (1.86× near-field, near-field ⟨g⟩ 1.31) vs the dumb control's g≈1.0 (1.00) — clustering. Resolves T-19's NULL: lifelike aggregation survives via chemotaxis (not active turbulence), and on a divergence-free fluid (rules out the compressible-monopole artifact). | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-21** AT-6 (GPU faithful fluid — GPU≡CPU cross-validation) | cross-method (GPU float32 vs CPU float64): the MPSGraph GPU port reproduces the CPU faithful solver — AT-01 invariants conserved to **3.8e-6**, AT-02 viscous decay vs `exp(−ν\|k\|²t)` to **2.95e-6** (both ≈float32 eps, CPU was 1e-14..1e-16), and the forced forward enstrophy cascade slope **−3.48 R²=0.99** (CPU −3.36, same universal −3). ~100× faster (3100 steps N=128 in 3.1 s, M5 Max). | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |
| **T-22** AT-7 (multistability — hysteresis loop) | qualitative-signature + control: an IC-ensemble (16 random ICs, fixed strong cohesion) gives one foam phase (CV≈2.2 — no basin multiplicity), while a cohesion up/down ramp (no reset, density-CV order parameter) traces a **hysteresis loop** — clumps form at coh≈25–35 but persist to coh≈5–15 (loop area 15.4, max gap 0.59 at coh 30) ⇒ a bistable transition zone. Rigorous form of the live path-dependence. | PASS, **Scope: phenomenology / 2D truncation (not PDE)** |

**Firewall in testing.** Passing T-01..T-07 promotes NS-010/011 to `:tested` with
`Scope: 1D-model` / `ODE-truncation` / `3D-truncation` — **never** to a PDE
statement. A PDE claim would require a separate convergence/limit argument, which
is out of scope for a diagnostic and would be its own (currently nonexistent)
`:proved` entry.
