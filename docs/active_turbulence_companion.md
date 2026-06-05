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

---

# Phase 1 — passive forced-turbulence control (NS-042)

The control that proves the faithful fluid is a **real turbulence engine** before
any agent is added. `scripts/active_turbulence_forced.jl` drives the NS-041 fluid
with a steady band-limited (passive, random-phase) vorticity forcing at injection
scale `k_f=8`, dissipated by `ν∇²` (small scales) + a low-k Rayleigh drag (large
scales, to arrest the inverse cascade so a steady state exists), and time-averages
`E(k)=½Σ|ω̂|²/|k|²` in statistical steady state (N=128, E≈0.68, Z≈33).

## §2.1 — Result: a clean 2D enstrophy cascade

| range | window | slope | R² | expectation |
|---|---|---|---|---|
| **forward (enstrophy)** | k∈[10,25] (k>k_f) | **−3.36** | **0.99** | Kraichnan −3 |
| inverse (energy-containing) | k∈[2,6] (k<k_f) | +0.45 | 0.13 | (see below) |

- The **forward enstrophy cascade is clean and universal: `E(k)~k^−3`** (measured
  −3.36, slightly steeper-than-−3 from coherent vortices — the documented real-2D
  -DNS behaviour). This is the decisive contrast with the fluoddity engine, whose
  spectral slope was a *forcing-controlled dial* spanning −1.4..−3.1 with **no**
  universal value (fluoddity-metal `docs/spectrum_study.md`). A real 2D NS fluid
  has a universal −3; the faithful fluid does too. **The fix worked.**
- The **inverse range is the energy-containing pileup** (energy accumulates below
  `k_f`, arrested by the drag — a steady state exists), shallow/flat (slope ≈ +0.4).
  It is **not** a resolved −5/3 inverse-inertial range: that requires ≳1 decade of
  scale separation below `k_f`, i.e. **N≥256 at high `k_f`** — deferred. The
  dual-cascade *structure* (steep forward, distinct shallow inverse) is present.

## §3.1 — Verification (T-17)

**AT-04** (→ TEST_SPEC **T-17**): in steady state the forward range is a steep
enstrophy cascade (slope < −2.3, R² > 0.85) clearly distinct from the inverse
range — PASS (−3.36, R²=0.99 vs +0.45). The bare-fluid checks AT-01/AT-02 (T-15/
T-16) still hold (the forced solver shares the NS-041 IF-RK4 core).

## §4.1 — Spec impact

Produces **NS-042** (`:tested`, **Scope: phenomenology / 2D forced-turbulence
truncation — NOT the NS PDE**). `:proved`=0; distance UNTOUCHED.

**Next:** Phase 2 — discrete active **force-dipole** agents running the (ported)
fluoddity Fourier brain, advected + co-rotated by the flow, coupling through the
curl-of-force hook, with the net-zero-momentum check AT-03 (→ NS-043). Optional
deferred: the −5/3 inverse-inertial range at N≥256/high-`k_f`.

---

# Phase 2 — discrete active-dipole agents (NS-043)

The active-matter coupling — the rigorous fluoddity. `scripts/active_turbulence_agents.jl`:
N=1500 self-propelled agents swim in the faithful fluid (NS-042). Each, per step:
1. **Sense** — bilinear-interpolate the velocity at two sensors (±sensorAngle,
   sensorDist, in the agent's own (forward,left) frame), project rotation-invariantly,
   and feed the mirror-symmetric **ported fluoddity Fourier brain** (10-center
   sum-of-sines, `Shaders.swift:195–249` → Julia `brain()`) → (axial thrust, turn).
2. **Force the fluid as a net-zero DIPOLE** — +f·p̂ at the head (x+ℓ/2 p̂), −f·p̂ at
   the tail (x−ℓ/2 p̂), each spread by a **normalized** Gaussian immersed-boundary
   kernel (Σ weights = 1), so the dipole injects *exactly zero* net momentum. The
   fluid feels (∇×f)_z via NS-041's curl hook (no extra projection).
3. **Advect + reorient** — ẋ = u(x) + v_swim·p̂; heading turns by the brain command
   + the local vorticity **ω(x)/2** (the physical leading-order co-rotation).

## §2.2 — Result: faithful net-zero coupling (AT-03)

| forcing | net momentum Σf (relative) | reading |
|---|---|---|
| **dipole (faithful)** | (3e-15, −2e-14) → **9.5e-18** | **machine zero** ✓ active swimmer |
| monopole (fluoddity) | (−30, 20) → 3.7e-2 | O(1) — spurious momentum, unphysical |

This *is* the precise sense in which fluoddity's momentum-monopole `splat` was not
physical: a real swimmer is force-free (a dipole), injecting zero net momentum. The
fix is named (the dipole), implemented (normalized IB spread), and verified to
machine precision. The agents are now genuinely two-way coupled to the faithful
fluid — sensing, brain-steering, co-rotating, swimming (≈0.32).

The **coupled run is stable** over 1500 steps (E, Z bounded, finite). Honest caveat:
at these parameters the active flow is **weak** (E≈5e-4) — net-zero dipoles are
efficient and inject little large-scale energy, so the fluid speed is ≪ the swim
speed (weak two-way coupling). Strong collective dynamics need u_rms ~ v_swim,
which Phase 3 reaches by cranking `forceGain` / agent density.

## §3.2 — Verification (T-18)

**AT-03** (→ TEST_SPEC **T-18**, exact-invariant tier): dipole net momentum machine-
zero (rel < 1e-12) vs the O(1) monopole reference; plus a stable 1500-step coupled
integration (finite, bounded). PASS.

## §4.2 — Spec impact

Produces **NS-043** (`:tested`, **Scope: phenomenology / 2D active-turbulence
truncation — NOT the NS PDE**). `:proved`=0; distance UNTOUCHED.

---

# Phase 3 — does lifelike organization emerge? (NS-044)

The climax. `scripts/active_turbulence_organization.jl` cranks the coupling to a
**vigorous** active flow (forceGain=25, N=2000 agents) and censuses for
self-organization, with a **brain-vs-dumb-swimmer control** to isolate whether the
*sensing brain* organizes the agents beyond generic active matter.

## §2.3 — Result: NULL (and it reframes the engine)

The flow is now vigorous: **u_rms ≈ 0.6 > swim 0.35**, **42% vortex-dominated**
(Okubo–Weiss OW<0). The *fluid* self-organizes into coherent vortices — the real 2D
phenomenon. But the **agents do not**:

| census | brain-agents | dumb control |
|---|---|---|
| g(r) (all r) | ≈ **1.00** | ≈ **1.00** |
| ⟨g(small r)⟩ | 1.00 | 1.00 (ratio 1.00) |

**No clustering, no creatures.** Brain-sensing agents cluster no more than dumb
swimmers, and neither clusters at all (g(r)≈1 = a random gas). **Lifelike
organization does not emerge** from active velocity-sensing agents on a faithful
incompressible fluid.

**The payoff — this reframes the fluoddity engine.** Its "creatures/vacuoles" were
*not* emergent active turbulence. They required two ingredients deliberately absent
from this faithful port:
1. **Chemotaxis** (the engine's `cohesion` term) — agents steering up the
   **density/dye** gradient, *toward each other*. This port senses only **velocity**.
   That was the aggregation driver.
2. The **non-physical momentum-monopole forcing** — it makes convergence/sink
   regions where agents pile up. On a **divergence-free** fluid this is *impossible*.

So the lifelikeness was **chemotaxis + a compressible-forcing artifact**, not
active-turbulence self-organization. On a faithful fluid with physical dipole forcing
and velocity-sensing, the agents stir a real turbulent flow but stay uniform.

## §3.3 — Verification (T-19)

**NS-044** is an honest **NULL** (→ TEST_SPEC **T-19**, qualitative-signature/NULL),
licensed by the brain-vs-dumb control and the Okubo–Weiss flow check. The chemotaxis
variant is **explicitly UNTESTED** (flagged), not silently assumed.

## §4.3 — Spec impact + the arc

Produces **NS-044** (`:tested`, NULL, **Scope: phenomenology — NOT the NS PDE**).
`:proved`=0; distance UNTOUCHED. **Active-turbulence arc Phases 0–3 COMPLETE** (the
faithful fluid, its real cascade, the faithful agents, the organization NULL).

**Decisive follow-up (untested):** add the chemotaxis term — does density-aggregation
reproduce clustering even on the faithful incompressible fluid? That isolates whether
*any* lifelike organization survives on a physical substrate. (Phase 4 — GPU port for
scale — remains deferred.)
