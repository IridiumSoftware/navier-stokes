# changelog — Navier–Stokes obstruction program

## v0.1.6 — 2026-06-01 — Consolidation: validated-diagnostic milestone + internal audit

Pre-3D consolidation checkpoint (`docs/validation_milestone.md`).
- **Internal cross-audit PASS** (TCE-style): A1 spec↔registry ID parity (20 IDs),
  A3 every referenced artifact exists (+ every `.jl` has its `.out.txt`), A4 firewall
  intact (**zero** `:proved` status; only reserved-language mentions).
- **Validation ladder consolidated:** the NS-010/011 diagnostic is two-sided —
  correctly reports blowup (1a Burgers exact δ; 1b CLM exact δ + BKM co-movement)
  AND regularity (1c 2D: δ bounded, invariants conserved <1e-6) against ground truth.
  Hermetic radix-2 FFT (1D+2D), self-checked. Tool chain trusted before 3D.
- Dashboard milestone recorded; distance-to-prize UNTOUCHED.
- Open (decisions, not done here): push/remote; prune the migrated turbulence scripts
  from TCE; and "run the TCE" prep step before the 3D escalation.

## v0.1.5 — 2026-06-01 — NS-010 Stage 1c (2D): the regularity control

`scripts/spectral_2d_control.jl` (+ companion). 2D pseudospectral NS/Euler
(vorticity form; hand-rolled FFT extended to 2D, roundtrip exact). 2D is *known*
globally regular ⇒ the diagnostic must report regularity — and it does:
- **Solver validated** by the Tier-1 invariants: 2D Euler conserves energy,
  enstrophy, ‖ω‖∞ to <1e-6 (the exact-invariant ground truth in lieu of a closed
  form). FFT 2D self-check exact.
- **Control PASS (T-05):** δ(t) decreases via filamentation but stays **bounded
  (≥0.23, never→0)**; ‖ω‖∞ conserved ⇒ BKM ∫‖ω‖∞ **finite** ⇒ no blowup. NS (ν>0):
  energy & enstrophy monotonically decay, δ bounded. The diagnostic **distinguishes
  regularity from blowup** (vs CLM Stage 1b, δ→0) — the prerequisite for 3D.
- **physical_invariants.md made concrete:** enstrophy & ‖ω‖∞ are Tier-1 coercive in
  2D (no vortex stretching) ⇒ BKM finite ⇒ regular. The 2D side of the 2D/3D gap.
- **Honesty:** corrected a text claim ("N=256 conserves enstrophy better") that the
  data didn't support (both N conserve exactly; cascade not yet at the cutoff).
- **Firewall:** 2D truncation, not the PDE. NEXT = 3D (open regime, no benchmark).

## v0.1.4 — 2026-06-01 — NS-010 Stage 1b: spectral solver + BKM co-movement (CLM)

`scripts/spectral_clm_blowup.jl` (+ companion). Apply the validated δ(t) diagnostic
to a *real pseudospectral solver* of the Constantin–Lax–Majda model `ω_t=ωH(ω)` —
the 1D vortex-stretching (NS-004) analog that genuinely blows up.
- Hand-rolled radix-2 FFT (no FFTW dependency), self-checked vs manual DFT (5e-13).
- Derived exact CLM strip `δ(t)=ln(2/t)` (complex singularity `x*=π/2+i ln(2/t)`),
  blowup `t*=2`, simple pole. δ_fit reproduces it exactly.
- **T-04 PASS (BKM half):** δ→0 co-diverges with ∫‖ω‖∞→∞ at the same t*=2.
- **T-03 PASS (with honest correction):** solver+δ N-robust to <0.1% for
  N∈{512,1024,2048} through t=1.98. I predicted a small-N breakdown there; there is
  none — the spectrum-slope fit is robust to cutoff under-resolution. Recorded as a
  correction, not buried.
- NS-010/011 stay `:tested` (now exercised on a 2nd exact benchmark + a real
  time-stepper); NS-004 corroborated computationally.
- **Firewall:** validates the tool chain on the vortex-stretching nonlinearity in a
  1D model. Does NOT touch 3D-NS regularity. NEXT = Stage 1c (2D→3D, no benchmark).

## v0.1.3 — 2026-06-01 — NS-010 Stage 1a: analyticity-strip diagnostic VALIDATED

`scripts/burgers_analyticity_strip.jl` (+ companion `docs/ns010_analyticity_strip_companion.md`).
First `Scope: PDE-method` work. The complex-singularity / analyticity-strip blowup
diagnostic (NS-010/011) is validated against an EXACT 1D closed form:
- Derived the exact inviscid-Burgers strip width `δ(t)=arccosh(1/t)−√(1−t²)` (from
  the complex-characteristic singularity `cos ξ*=1/t`, `ξ*=i·arccosh(1/t)`), shock
  at `t*=1`, `δ~(t*−t)^{3/2}`.
- **Spectrum-fitted δ(t) matches it to ≤4.1%** (t=0.3–0.95; cube-root `k^{-4/3}`
  prefactor removed); **3/2-law exponent = 1.519** (theory 1.5). **T-01 PASS, T-02
  PASS (inviscid).**
- Viscous control (Cole–Hopf, ν=0.1): δ bounded (~0.4) for all t incl. past t*=1,
  vs inviscid δ→0 — viscosity holds the complex singularity off the real axis.
- NS-010/011 promoted `:argued → :tested` (Scope: PDE-method, validated in 1D-model).
- **Firewall intact:** validates the *tool*; the 3D-NS question (does δ→0 there) is
  untouched — Stage 1b (spectral truncation) + ultimately the open problem. T-03
  (full N-sweep) PARTIAL; T-04 (BKM/critical-norm co-movement) PENDING for 1b.

## v0.1.2 — 2026-05-31 — Log external related work (Gosme)

Added **NS-025 (Class RELATED)**: Gosme, *Causal symmetrization as an empirical
signature of operational autonomy in complex systems*, arXiv:2512.09352 (Dec 2025)
— verified real (paper fetched; Aaron's cited title was a close paraphrase). An
external empirical operationalization of the closure-to-efficient-causation /
(M,R) framework on 50 software ecosystems: order parameter Γ (bimodal phase
transition), "causal symmetrization" (Granger structure↔activity coupling 0.71→0.94
at maturity), "structural zombies." **Scope: software-ecosystems / phenomenology —
NOT NS-PDE; cannot bear on the prize.** Bears on NS-023/024 (closure-theory side).
Added Class `RELATED` to `CLAUDE.md`; registry row; flagged the symmetrization-vs-
(M,R)-symmetry comparison as caution-not-claim. Queued a phenomenology experiment:
test whether the symmetrization signature appears in the MFE saddle (Granger
structure=roll a₃ vs activity=perturbation energy), Scope: ODE-truncation.

## v0.1.1 — 2026-05-31 — Physical invariants reference

Added `physical_invariants.md` — the tiered invariant constraint set for NS, in
the lineage of the closure-v5 `physical_invariants.md` and the possibilistic-
inversion `geophysical_invariants.md`. Tier 1 (frame-independent / hard:
incompressibility, energy inequality, momentum, scaling symmetry→supercriticality,
Galilean/rotation symmetries, helicity & circulation [Euler-exact / NS-decaying],
enstrophy [2D-coercive / 3D-battleground], BKM); Tier 2 (frame-dependent
phenomenology: K41 −5/3, increment 1/3, anomalous dissipation, intermittency, Re
thresholds, blowup scenarios — soft only, anchoring anti-pattern if hard); Tier 3
(established theorems = the fixed end). **Load-bearing reading recorded: the 2D/3D
regularity gap IS an invariant-tier story — enstrophy is Tier-1 coercive in 2D, the
battleground in 3D, leaving only the supercritical energy as Tier-1 control.** The
tier-confusion anti-pattern is the Scope firewall in invariant terms. Wired into
`CLAUDE.md` ground-truth hierarchy and cross-referenced to `SPEC.md` NS-IDs.

## v0.1.0 — 2026-05-31 — Repository established

**Founding commit.** Set up the obstruction-program scaffold for the 3D
incompressible Navier–Stokes global-regularity (Clay) problem, in the TCE
ground-truth-hierarchy style, adapted for a mathematics obstruction program.

- **Business files:** `CLAUDE.md` (constitution + the Scope firewall),
  `SPEC.md` (the obstruction ledger, 18 entries), `DESIGN.md` (strategy +
  the complex-plane live attack + cross-project framing), `dashboard.md`,
  `artifact_registry.md`, `TEST_SPEC.md`.
- **Spec populated from what we know:** problem statement (NS-001);
  obstructions NS-002..009 (supercriticality, Leray energy-only control, BKM,
  Prodi–Serrin–ESS, CKN partial regularity, no-self-similar-blowup, Tao
  averaged-blowup no-go, Onsager 1/3); diagnostics NS-010/011 (analyticity
  strip, complex-singularity tracking); live NS-012/013 (Li–Sinai complex-data
  blowup; real⇐complex open).
- **Prior arc migrated** (copied from TCE; TCE copies remain @79e5e35):
  15 scripts + 2 witness docs. Recorded honestly as NS-020 (homology
  reformulation **:falsified**), NS-021 (MFE saddle phenomenology, Scope:
  ODE-truncation), NS-022 (helical triad, Scope: model), NS-023 (autopoietic
  closure / (M,R) rotation-covariant gate, Scope: abstract closure — a separate
  domain), NS-024 (closure↔turbulence convergence, witness-trimmed to
  broad/generic, Scope: analogy).
- **Honest baseline recorded:** zero progress on the prize; `:proved` count = 0
  by design; distance-to-prize = UNTOUCHED.

**Next:** the complex-plane diagnostic (NS-010/011) — Burgers exact poles, then a
spectral truncation watching the analyticity-strip width δ(t). First in-repo
direction with `Scope: PDE-method`; still a diagnostic in models, not a proof.
