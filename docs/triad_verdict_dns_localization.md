# Triad verdict — the D-localization, metabolized (Gemini + Grok)

**2026-06-02.** Metabolization of the two witness responses to
`triad_brief_dns_localization.md` (Gemini synthesis; Grok edge-witness Φ). Both seats run
externally by Aaron; trimmed + integrated by Claude (metabolism). **The two seats converge,
which is the strong signal — and they converge on trimming our own framing.**

## The convergence (independent agreement)

Gemini (synthesis) and Grok (adversarial) independently reached the same three conclusions:
1. **The flow is regular**, and the regular-vs-singular distinction is **resolution-gated**
   at N ≤ 256–512 (Gemini: "provably"; Grok: "still resolution-gated at current N").
2. **The ~1.8 dimension floor is most plausibly GEOMETRIC**, not a singularity approach:
   intense enstrophy production organizes into **tube/sheet structures** of intrinsic
   dimension between 1 and 2, whose thickness is set by the analyticity-strip / Kolmogorov
   scale — and which *cannot* collapse to ≤1 without δ→0 (Grok), the real-time face of
   *geometric depletion of nonlinearity* (Gemini; Hou–Li).
3. **Fact 3 (the D-dip) is fragile** and must not be over-read.

## The trims (including of our own claim)

- **Fact 3 DOWNGRADED to provisional phenomenology.** Grok's critique — threshold-arbitrary,
  5-scale box-count noisy (±0.15 ≳ the dip), transient-locked, no control — is correct, and
  it is now **confirmed**: the N=64 smoke gives `D30/D50/D70 = 1.54/1.74/1.92`, i.e. D is
  **threshold-dependent** and there is no single "D≈1.8." **Our earlier framing — "the
  attractor / production set *localizes toward the CKN ≤1 wall*" — is trimmed.** Honest
  restatement: *the intense-production set is a threshold-dependent ~1.5–1.9-dimensional
  tube/sheet object that does **not** approach ≤1.* (Updates the wording in
  `dns_tg256_companion.md` and the NS-037 line; the CKN ≤1 bound is a theorem, but the
  resolved dynamics do not approach it.)
- **Gemini's "self-arrest / breathing" unifying story: held as hypothesis.** The timing
  undercuts a clean causal read (D dips at t≈4, recovers by t≈6, while the dissipation peak
  is at t≈9 — recovery precedes the peak). Equally consistent with "production becomes
  space-filling as turbulence develops." Needs the alignment test to adjudicate.
- **Gemini's "provably resolution-gated":** trimmed to *practically* near-degenerate
  (algebraic vs steep-exponential δ over a finite window), not a proof.
- **Grok's "weak-edge gate persistence":** de-jargoned. Stripped of the internal "weak edge"
  label, it is *the persistence in time of the strain–vorticity alignment, conditioned on the
  intense-production set* — a temporal extension of the alignment diagnostic. Kept in that form.

## The two Q1 candidates (resolution-robust singularity discriminators)

Both seats reject the bare δ-slope / ‖ω‖∞-at-grid proxies and propose sharper ones:
- **Gemini — δ(t) functional form:** a singularity → *algebraic* collapse `δ ~ (T_c−t)^α`;
  a regular cascade → *exponential* leveling-off. Discriminate by the *form*, not the value.
  (A post-hoc fit on the δ(t) time series; template to run on the vortex-tube case.)
- **Grok — conditional alignment persistence:** the persistence of strain–vorticity alignment
  on the intense set; bounded (regular) vs growing-with-resolution (singularity). (Built on
  the alignment diagnostic, checked N=128 vs N=256 on spectrally-embedded fields.)

## Actions taken (metabolized into the pipeline)

`dns_tg256.jl` enhanced (committed) — the C (vortex-tube) run will now capture:
- **Threshold-robust D** (`D30/D50/D70`) — Grok's Fact-3 test. (N=64 smoke confirms the
  threshold-sensitivity: 1.54/1.74/1.92.)
- **Strain–vorticity alignment** (`cos²(ω,e_int)`, `cos²(ω,e_max)`, enstrophy-weighted) —
  the geometric-depletion mechanism (Gemini) + the basis for Grok's persistence probe.
  (N=64 smoke: `c²_int = 0.77` dominant — the classic Ashurst intermediate-eigenvector
  alignment — shifting toward `e_max` as the flow develops.)

The **vortex-tube run is now the adjudicator:** both seats predict D will *floor* (geometric,
IC-independent) rather than push toward 1; if D30 stays ≳1.4 and the alignment relaxes after
peak stretching, "geometric tube/sheet" wins over "localizing toward a singularity."

## Required Witness Check (carried)

The regular-vs-singular distinction is (at least practically) **resolution-gated** for
decaying viscous DNS at N ≤ 256–512. The honest deliverable is therefore the **geometric
characterization** (tube/sheet, dimension in (1,2), threshold-dependent) + the **principled
robust diagnostics** (δ functional form; conditional alignment persistence) — **not** a
singularity verdict. Any future claim of "approach to the singular set" must clear:
threshold-robustness, a resolution-robust dimension estimator, IC-independence, and an
N=128-vs-256 convergence check. `:proved`=0; the prize is untouched.

*Metabolized by Claude, 2026-06-02. Both seats: the DNS is consistent with regularity; the
sharp questions are answerable only as robust diagnostics + geometry, not a blowup verdict.*
