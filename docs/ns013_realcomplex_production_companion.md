# NS-013 — Real-vs-complex on the production object (companion)

**Date:** 2026-06-07. **Scope: 1D complex viscous Burgers (the Li–Sinai / NS-013 analog). NOT the 3D-NS
PDE. `:proved`=0; distance to the prize UNTOUCHED.** A witness/counter-witness probe, not a result that
moves any `Scope: PDE` entry.

## §1 — Computational basis

- **Script:** `scripts/ns013_realcomplex_production.jl` (std-lib Julia; hand-rolled radix-2 complex FFT;
  IF-RK4 solver copied verbatim from the Cole–Hopf-validated rung `complex_burgers_reality_leakage.jl`).
- **Output:** `scripts/ns013_realcomplex_production.out.txt`.
- **Model.** 1D complex viscous Burgers `u_t = −u u_x + ν u_xx − iλ·Im(u)`, `ν=0.2`, `N=1024`, `dt=0.005`,
  2/3-dealiased. The reality-leakage `λ` damps `Im(u)` at rate `λ`: `λ=0` = complex data (Cole–Hopf
  blowup), `λ→∞` forces `u` real (heat-maximum-principle protected). Cole–Hopf complex IC
  `φ₀=1+b·e^{ix}`, `b=3` ⇒ `t*=ln(b)/ν=5.49`; plus a multi-mode one-sided IC `φ₀=1+1.5e^{ix}+0.8e^{2ix}`.
- **The production object (exact 1D algebra).** For `g=u_x`, the gradient-energy budget is, exactly,
  `d/dt ½∫g² = −½∫g³ − ν∫g_x²`. The **production object** is `P ≡ −½∫g³` (self-steepening, the shock
  nucleator); its normalized form `Skew ≡ −∫g³/(∫g²)^{3/2}` is the velocity-gradient skewness — the exact
  1D shadow of the 3D enstrophy budget `dΩ/dt = ∫ω·Sω − ν∫|∇ω|²` and the production skewness `S_ω`.

## §2 — Results

**N=1 gate — the production budget identity holds.** `d/dt ½∫g²` (finite-diff) vs `−½Re∫g³ − νRe∫g_x²`:
rel.err `2.8e-4`. The production object is correctly measured.

**Finding 1 — the complex-blowup class carries IDENTICALLY ZERO production (exact, by Fourier support).**
The single-mode Cole–Hopf complex blowup has `|P| ≈ 2.4e-16` (machine zero) and `Skew ≡ 0` for the
*entire* evolution, even as `∫|g|²` blows up (×10¹² by `t*`) and `δ(strip): 1.10 → 0.009`. The reason is
structural and general: the Cole–Hopf complex ICs are **analytic signals** — one-sided spectrum (only
`k>0` modes). For any one-sided `g`, `∫g³ = 2π·(g³)_{k=0} = 0`, because **three positive wavenumbers
cannot sum to zero**. So `P ≡ 0` on the *entire* complex-blowup class, not a single-mode accident.
A second one-sided witness (the multi-mode IC) confirms it: peak `|Skew| = 1.3e-15` over its whole run.

**Finding 2 — reality ACTIVATES the production (it does not deplete it).** As `λ: 0 → 1`, the field is
pushed from the one-sided analytic signal toward a conjugate-symmetric **two-sided** spectrum
`û(−k)=conj û(k)`; `∫g³` becomes nonzero and `Skew` climbs `0 → 0.67` (the turbulence-like gradient
skewness), `|P| > 0`, viscously balanced ⇒ regular. The reality-leakage sweep also reproduces the
existing rung's protection boundary (`λ_c∈(0.02,0.05)`: `λ=0` blows at `t*≈5.75`, `λ=0.02` delayed to
`7.0`, `λ≥0.05` regular).

**The inversion.** The prior hypothesis was that reality might *deplete* the production. The opposite is
true: the complex blowup forms in a channel where the production object is structurally **absent**
(`P≡0`), and reality is precisely the spectral condition (two-sidedness) that **switches the production
on**. The complex-blowup channel (off-axis analyticity, `δ→0`) and the real-flow production channel are
*disjoint* objects in 1D.

## §3 — Verification

- *Example/identity-tested.* The exact budget identity `d/dt ½∫g² = −½∫g³ − ν∫g_x²` verified numerically
  (rel.err 2.8e-4) — validates `P` as measured.
- *Algebraic (exact).* `∫g³ = 2π·(g³)_{k=0} = 0` for any one-sided-spectrum `g` (three positive
  wavenumbers cannot sum to 0). This is a theorem, not a fit; the numerics (`|P|~1e-16` complex vs `~1e-4`
  real) are its confirmation, and it covers the whole analytic-signal (Li–Sinai) class.
- *Solver provenance.* IF-RK4 + hand FFT are the Cole–Hopf-validated rung (`complex_burgers_reality_
  leakage.jl`, `T*(λ=0)` matches `ln(b)/ν` to <10%).

## §4 — Spec impact

**No new S-ID; no status change.** This is a within-model witness feeding **NS-013** (does complex-data
blowup inform real-data regularity?). It **corroborates** the existing NS-013 triad verdict that
"complex⇏real is vacuous": in 1D the complex singularity lives in off-axis analyticity (the absent
maximum principle), an object **disjoint** from the production (`∫ω·Sω` / ξ-alignment / NS-046) the
real-regularity question is about — now shown sharply, with the production object *identically zero* on
the complex side and nonzero on the real side.

**Honest scope / non-transfer.** 1D has no vortex direction `ξ`; this is the amplitude/skewness shadow of
the 3D production. The Fourier-support argument is **1D-specific** (the production is a single cubic
`∫g³`); the 3D production `∫ω·Sω = ∫|ω|²(ξ·Sξ)` is *not* a single cubic in a one-sided field, so the clean
"identically zero" does **not** transfer. What transfers is the **question**: does reality's spectral
structure (conjugate symmetry) gate the 3D production? That is a sharper, witness-survivable framing of
the NS-013 → NS-046 link, recorded as a direction — not a result. `:proved`=0; prize UNTOUCHED.
