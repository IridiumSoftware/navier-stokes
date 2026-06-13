# NS-050 companion — Attempt 5: stabilized dynamic-rescaling profile solve

**Date:** 2026-06-13. **Status: the CLM gate PASSED (the scheme is validated); the HL solve is a
CLEAN NEGATIVE — the HL profile behaves as a saddle the modulation cannot stabilize.** Scope:
1D-model / numerical-tooling (≠ PDE). `:proved`=0; distance UNTOUCHED; reconstructs a KNOWN object
(ZERO prize value). **Provenance:** the session brief `~/Desktop/ns050_dynrescale_session_brief.md`
(Aaron, 2026-06-12), incorporated by reference; this closes its single question (§1) and the open
item in `ns050_houluo_profile_companion.md` §4. Code: `scripts/ns050_dynrescale_profile.jl`
(+`.out.txt`); diagnostic `scripts/ns050_hl_diag.jl` (+`.out.txt`). The reading below is
hand-written after looking at the numbers (the house rule of brief §4 / the §3 auto-summary catch).

## 1. What was built and run

The one new element vs attempts 1–4 (brief §0): **modulation-pinned (c_l, μ) solved algebraically
every step**, removing the scaling + amplitude zero-modes from the τ-flow, **with τ-evolution to the
fixed point as the engine** (no Newton). Operators: the T-25 validated cot-map ℝ-operators (∂_ξ,
ξ∂_ξ, H_ℝ) reused verbatim. Two design choices the brief left as "e.g.":
- **Two-point collocation pinning.** W is odd ⇒ W(0)=0, so the brief's literal `W(0)=W₀ /
  ∂_ξW(0)=0` pins are degenerate; L²/2nd-moment pins diverge on the ~1/ξ tail (CLM Φ~−1/η). So we
  hold W stationary at two core points ξ_a (the |W|-peak) and ξ_b (outward, where |W|≈0.4·peak):
  `d/dτ W(ξ_a)=d/dτ W(ξ_b)=0` ⇒ an exact 2×2 for (μ,c_l). This IS "differentiate the pin along the
  flow, solve the 2×2" in its most robust, tail-insensitive form.
- The cot-map **tames** the dilation CFL: ξ∂_ξ = −sinθ ∂_θ, whose coefficient →0 at the ξ=±∞ edges
  (the brief's edge-CFL worry is real but the map helps; CFL ≈ Δθ/c_l).

**GATE (brief §2.5, MANDATORY):** the identical machinery on CLM (ω_t=ωHω), whose self-similar
profile is closed-form. Derived here and verified by hand: **Φ(η)=−4η/(1+4η²) satisfies
Φ + ηΦ′ = Φ·HΦ** (both sides equal −8η/(1+4η²)²; HΦ = 2/(1+4η²) via the Hilbert dilation rule). In
rescaled form ∂_τW = W·HW − μW − c_l ξW_ξ the fixed point is Φ with (μ,c_l)=(1,1). HL was not run
until the gate passed.

## 2. Results

**GATE — CLM: PASS, both seeds, to spectral accuracy** (`ns050_dynrescale_profile.out.txt`):

| seed (odd, ~1/ξ class) | N | μ→ | c_l→ | ‖W∓Φ(s·)‖ (core) | resid | (s, sgn) |
|---|---|---|---|---|---|---|
| −ξ/(1+ξ²) | 1024 | 1.0000 | 1.0000 | 1.05e-05 | 1.07e-11 | (0.50,+1) |
| −ξ/(1+0.5ξ²) | 1024 | 1.0000 | 1.0000 | 1.44e-02 | 1.29e-11 | (0.35,+1) |

Both seeds converge (residual ~1e-11) to the CLM profile with the correct eigenvalues (μ,c_l)=(1,1),
matching Φ modulo its scaling symmetry Φ(s·) — **seed-independent**. *(The shape distance is reported
modulo the CLM scaling+reflection symmetries: Φ(sη) is a one-parameter family, all with (μ,c_l)=(1,1),
and −Φ is the reflected branch with (−1,−1) — the pin selects a member by its two pinned values.)*

**HL — DIVERGES, both seeds** (`ns050_dynrescale_profile.out.txt`: both report DIVERGED at N=2048).
The diagnostic `ns050_hl_diag.jl` (`+.out.txt`) localizes the mechanism — it is **not** a CFL/stiffness
blowup (identical behavior at dτ=1e-5 and 2e-6, N=1024 and 2048), it is a monotone **wrong-way drift**:

- (A) standard: μ runs 0.50 → 0.18 (away from the expected μ→1); c_l runs −0.07 → −9.6 (the HL
  eigenvalue should be ≈+2.5, band (2,4.53)); ‖W‖∞, ‖G‖∞ grow exponentially → NaN at τ≈1.87.
- (B) with ‖G‖∞ renormalized each step (to rule out the G-amplitude runaway as a separate cause):
  the flow still escapes — μ→−1.0, c_l→−1.74, **residual plateaus at ≈34** (a high-residual
  non-fixed-point, nowhere near convergence). So the G-drift was a symptom, not the cause.

## 3. Verification

- *CLM gate (the positive result):* closed-form gate. The scheme recovers the EXACT CLM profile
  (closed-form Φ) and its exact eigenvalues (1,1) to residual ~1e-11 and shape ~1e-5/1e-2, from two
  distinct seeds. Evidence type: computed witness against a closed form. This validates the
  stabilized-dynamic-rescaling **instrument** — the first profile-solve in the NS-050 arc that
  converges at all. → TEST_SPEC **T-32** (PASS, Scope: 1D-model).
- *HL (the negative):* the same machinery, applied to the HL coupled system, diverges from both
  seeds; the diagnostic shows monotone escape robust across dτ, N, and a G-renorm variant. Evidence
  type: computed honest-negative. → recorded as a negative; no status change.

## 4. Reading — the clean negative (brief §0 / §3)

**The stabilized dynamic-rescaling combination (modulation-pinning + τ-evolution) does not reach the
HL fixed point.** The reason is sharp and is the brief's pre-registered §0 cause: the HL self-similar
profile behaves as a **saddle** whose unstable directions survive the modulation. Modulation removes
the *symmetry* zero-modes (scaling, amplitude) — which is exactly enough for CLM, whose profile is an
**attractor** of the modulated flow (it converged to 1e-11) — but the HL profile carries *genuine
unstable eigenmodes beyond the symmetries*, and pure forward τ-evolution escapes along them. This is
precisely why Chen–Hou used a Newton solve with stability control rather than relaxation, and it
reproduces (now with a validated instrument and a localized mechanism) the honest negative of
attempt 1 (`ns050_houluo_profile_solve.jl`).

Per brief §0, the arc closes here as a clean negative: **no attempt 6 without a genuinely new
element.** The negative is informative, not a dead end — it tells attempt 6 exactly what it needs:
either (i) **unstable-mode projection / Newton–Krylov** on `F(W,G,c_l)=0` seeded near the profile
(project out or invert the saddle's unstable subspace — Chen–Hou's machinery), or (ii) the
**higher-resolution forward-run path** (`ns050_houluo_profile_companion.md` §4) to reach the
asymptotic profile as a seed. The modulation-pinning developed here is a reusable component of (i):
it correctly removes the two symmetry zero-modes, so a Newton step need only handle the *remaining*
finite unstable subspace.

**What is durably won:** the modulation-pinned dynamic-rescaling scheme on the validated T-25
ℝ-operators is a working, gate-validated profile solver (CLM, machine accuracy, seed-independent) —
reusable for the NS-048 DSS/ancient-profile search (`ns050_mapped_grid_solver_scope.md` §6), which
is the only non-zero-value use (the prize value is, as pre-declared, zero).

## 5. Firewall

CLM and HL are 1D models; the solver is a finite hand-rolled-spectral truncation; the modulation is
amplitude+scale only. This validates an INSTRUMENT and records a localized negative; it does not
touch 3D-NS regularity. `:proved`=0; Scope: 1D-model / numerical-tooling; distance UNTOUCHED.
