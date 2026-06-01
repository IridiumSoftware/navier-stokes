# Companion — NS-010 Stage 1c (2D): the regularity control

**2026-06-01.** **Scope: 2D pseudospectral ODE-truncation.** NOT the 3D-NS PDE.
2D incompressible NS/Euler is *known* globally regular (no vortex stretching), so
this is a **control**: the validated δ(t) diagnostic must report **regularity**
(δ bounded, BKM finite) — the opposite of the CLM blowup (Stage 1b). Passing it =
the solver + diagnostic correctly say "regular" when the answer is regular, the
prerequisite for trusting them on the open 3D case.

## §1 — Computational basis

`scripts/spectral_2d_control.jl` (+ `.out.txt`). Julia, std-lib only — the Stage-1b
hand-rolled radix-2 FFT extended to 2D (rows-then-columns), 2D roundtrip self-check
exact (0.0e+00). 2D vorticity form `ω_t + u·∇ω = νΔω`, `u=∇⊥ψ`, `Δψ=−ω`,
pseudospectral RK4 + 2/3-dealiasing. Smooth IC `ω₀=sin x cos y + ½ sin(2x+y)`.

## §2 — Results

**(A) 2D Euler (ν=0), N=128, to T=4.** Solver-correctness anchor = the Tier-1
invariants (`physical_invariants.md`): **energy conserved to <1e-6, enstrophy to
<1e-6, ‖ω‖∞ to ~3e-4** — confirms the spectral operators/signs are correct.
Control behavior: **δ(t) decreases (1.45→0.23) via filamentation but stays bounded
> 0** (never →0); **‖ω‖∞ conserved ⇒ BKM ∫‖ω‖∞ grows linearly (FINITE) ⇒ no
blowup.** (Enstrophy stays exactly conserved here because the forward cascade has
not reached the 2/3 cutoff by T=4 — δ=0.23 ≫ grid scale; it would leak later.)

**(B) N-convergence (128 vs 256, to T=2).** δ agrees to a few %; enstrophy conserved
at both N (cutoff not yet reached — no leak to show). Resolution-independent while
resolved.

**(C) 2D NS (ν=0.01), N=128.** Energy & enstrophy **monotonically decay** (viscous
dissipation), δ bounded. Strictly regular.

## §3 — Verification

- **Solver correctness:** 2D Euler energy & enstrophy conserved to <1e-6 (exact
  invariants are the ground truth, in lieu of a closed-form solution). FFT self-check
  exact.
- **Control (regularity reported correctly):** δ bounded (≥0.23), BKM finite,
  ‖ω‖∞ conserved → no blowup. Contrast Stage 1b (CLM): δ→0, BKM→∞. The diagnostic
  **distinguishes regularity from blowup.**
- **Honesty:** I initially expected to *show* "N=256 conserves enstrophy better";
  the data shows both N conserve exactly (cascade not yet at the cutoff), so I
  corrected the claim to match — no leak demonstrated in this run.

## §4 — Spec impact

- **NS-010/011** (`:tested`): now exercised on a 2D pseudospectral solver in the
  *regularity* regime, with exact invariant conservation as the solver-validation.
  The diagnostic correctly reports regularity (δ bounded) vs blowup (CLM, δ→0).
- **NS-004 / `physical_invariants.md` (2D/3D gap):** made concrete — in 2D,
  enstrophy & ‖ω‖∞ are Tier-1 coercive invariants (no vortex stretching) ⇒ BKM
  finite ⇒ global regularity. This is the 2D side of the gap.
- **Firewall:** a 2D truncation, not the PDE. NEXT = 3D, where enstrophy is NOT
  coercive (vortex stretching switches on), there is NO exact benchmark, and
  δ(t)→0 would be the actual open question.
