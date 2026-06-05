# Companion — Active turbulence: the faithful fluid (NS-041, Phase 0)

*2026-06-04. **Every result here is `Scope ≠ PDE` (phenomenology / 2D
active-turbulence truncation); none is prize progress. Distance to prize:
UNTOUCHED.***

This track builds the **rigorous version of the fluoddity agent engine**. The
fluoddity study (separate repo) proved that engine is a *forcing-controlled
spectral dial, not turbulence* — because its "fluid" is non-physical: dissipation
is a scale-independent **uniform drag** (not viscosity), and forcing is a
**momentum monopole** (not a net-zero force dipole). The goal here is to keep the
lifelike active agents but put them on a **faithful incompressible 2D
Navier–Stokes fluid** — i.e. **active turbulence** — and ask whether genuine
self-organization emerges. Phase 0 (this companion) builds and validates the
faithful fluid substrate; agents arrive in Phase 2.

Approved plan: `~/.claude/plans/jazzy-zooming-horizon.md` (5 phases).

## §1 — Computational basis

`scripts/active_turbulence_fluid.jl` (Julia, std-lib only; hand-rolled radix-2
FFT, as in NS-010 Stage 1b/1c). Extends the validated 2D vorticity–streamfunction
pseudospectral solver `scripts/spectral_2d_control.jl` (NS-010 Stage-1c), keeping
its exact FFT streamfunction-Poisson `ψ̂ = ω̂/|k|²`, 2/3-rule dealiasing, and
energy/enstrophy diagnostics. Two additions:

1. **Exact viscosity via an integrating factor (IF-RK4).** The vorticity equation
   `ω_t + u·∇ω = νΔω + (∇×f)_z` is advanced with the linear term `−νk²`
   integrated *exactly* (`E = exp(−νk²dt)`, `E2 = exp(−νk²dt/2)`), and RK4 applied
   only to the non-stiff nonlinear+forcing part. State is stored as `ω̂` (Fourier)
   so the integrating factor (diagonal in `k`) is machine-exact. This is non-stiff
   (dt limited by the advective CFL only) and replaces fluoddity's uniform drag
   with real `ν∇²`, whose `k²`-selectivity (negligible at large scales, strong at
   small) is what produces an inertial range / cascade.
2. **Curl-of-force coupling hook.** A body force `f(x)` enters the vorticity
   equation as `(∇×f)_z = i(k_x f̂_y − k_y f̂_x)`. In vorticity form the curl
   **auto-discards `f`'s compressive (gradient) part** — the part a velocity-form
   pressure projection would remove — so active forcing couples with **no extra
   projection step**. Here `f ≡ 0` (validating the bare fluid); the active
   force-dipole agents couple through this hook in Phase 2.

Run (std-lib): `julia scripts/active_turbulence_fluid.jl` → `scripts/active_turbulence_fluid.out.txt`.

## §2 — Results (validation)

| check | quantity | result | tier |
|---|---|---|---|
| **AT-01** | unforced inviscid (ν=0,f=0): 2D-Euler energy + enstrophy drift over T=4 (N=128) | **1.3e-14** (both) | exact-invariant |
| **AT-02** | viscous (ν>0,f=0): single Fourier mode \|ŵ\|(t) vs `exp(−ν\|k\|²t)`, max rel. error | **7.3e-16** | closed-form |

- **AT-01** reproduces the 2D-Euler Tier-1 invariants (energy AND enstrophy
  conserved; enstrophy leaks only at the 2/3 cutoff — the same honest caveat as
  the Stage-1c control, T-05) on the new IF-RK4 kernel. A regression: with ν=0 the
  integrating factor is the identity, so this is the existing validated RK4 path.
- **AT-02** uses the fact that a single Fourier mode is an *exact 2D-Euler steady
  state* (`u·∇ω ≡ 0`, since the single-mode velocity is ⊥ to its own gradient), so
  its decay is purely viscous and must match `exp(−ν|k|²t)`. The 7.3e-16 agreement
  confirms the integrating factor integrates `ν∇²` to machine precision — the
  licensing check for the IF-RK4 viscosity (the cascade-bearing fix over the
  fluoddity drag).

## §3 — Verification

Both checks are in `scripts/active_turbulence_fluid.jl` itself and indexed in
`TEST_SPEC.md` as **T-15** (AT-01, exact-invariant) and **T-16** (AT-02,
closed-form). The script exits non-zero if either fails. The FFT round-trip
self-check passes (max err 0).

## §4 — Spec impact / firewall

Produces **NS-041** (`:tested`, Class RESULT, **Scope: phenomenology / 2D
active-turbulence truncation — NOT the NS PDE**). This is the *fluid substrate* of
an active-matter phenomenology study; it bears nothing on global regularity.
`:proved`=0; distance to prize UNTOUCHED.

**Next:** Phase 1 — `active_turbulence_forced.jl`: drive the faithful fluid with a
band-limited / Kolmogorov force + large-scale drag, confirm the 2D dual cascade
(−5/3 inverse for k<k_f, −3 enstrophy for k>k_f) — a trusted turbulence engine
*before* any agent is added (→ NS-042, AT-04/T-18). Then Phase 2 — discrete active
**force-dipole** agents running the (ported) fluoddity Fourier brain, coupling
through the curl-of-force hook, with the net-zero-momentum check AT-03 (→ NS-043).
