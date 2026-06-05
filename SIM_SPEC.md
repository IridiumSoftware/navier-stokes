# SIM_SPEC.md — Active-turbulence phenomenology track

**Active-turbulence phenomenology track. Scope: phenomenology / 2D active-turbulence
truncation — NOT the obstruction map, NOT the NS PDE. The obstruction program's
`:proved`=0 firewall does not gate this track; entries here are computational/
phenomenology evidence (`:tested`).**

This is the *rigorous version of the fluoddity agent engine*: a faithful incompressible
2D Navier–Stokes fluid driven by discrete active-dipole agents (active turbulence),
exploring whether genuine self-organization emerges. Co-located in the `navier-stokes`
repo but bookkept separately from the obstruction ledger (`SPEC.md`, NS-001..040).
Entries `AT-1..6` mirror the build phases (AT-5 = the chemotaxis follow-up; AT-6 = the GPU port);
the validation checks `AT-01..04` + the AT-5 census + the AT-6 GPU≡CPU cross-check are indexed in
`TEST_SPEC.md` (T-15..T-21). It extends the obstruction map's validated 2D solver
(NS-010) as a substrate but asserts nothing about the PDE. Plan:
`~/.claude/plans/jazzy-zooming-horizon.md`.

---

## Entries (AT-#)

**AT-1 — Faithful 2D active-turbulence fluid: exact viscosity + the active-coupling hook.**
The substrate for an active-matter phenomenology study — the rigorous version of the fluoddity
agent engine (whose "fluid" is non-physical: scale-independent **uniform drag**, not viscosity;
**momentum-monopole** forcing, not force dipoles). Extends the validated 2D vorticity–streamfunction
pseudospectral solver (NS-010 Stage-1c, `spectral_2d_control.jl`) with the two pieces active matter
needs, keeping its exact FFT streamfunction-Poisson `ψ̂=ω̂/|k|²` and 2/3 dealiasing:
- **Exact viscosity via an integrating factor (IF-RK4).** The linear term `−νk²` is integrated
  exactly (`exp(−νk²dt)`); RK4 advances only the non-stiff nonlinear+forcing part (state stored as
  `ω̂`). Real `ν∇²` is `k²`-selective (negligible at large scales, strong at small) — the
  cascade-bearing fix over fluoddity's uniform drag, which damps every mode equally ⇒ no inertial
  range, no cascade.
- **Curl-of-force coupling hook.** A body force enters the vorticity equation as
  `(∇×f)_z = i(k_x f̂_y − k_y f̂_x)`; in vorticity form the curl **auto-discards `f`'s compressive
  part**, so active forcing couples with **no extra projection**. Here `f≡0` (Phase 0 validates the
  bare fluid); the active force-dipole agents arrive in Phase 2 (AT-3).
- **Validation (AT-01/AT-02).** **AT-01** — unforced inviscid (ν=0,f=0): energy AND enstrophy
  conserved to **1.3e-14** over T=4 (N=128) — the 2D-Euler Tier-1 invariants; a regression of T-05
  on the IF-RK4 kernel. **AT-02** — viscous (ν>0): a single Fourier mode (an exact 2D-Euler steady
  state, `u·∇ω≡0`) decays as `exp(−ν|k|²t)`, matching the closed form to **7.3e-16** — the
  integrating factor is machine-exact (licenses the `ν∇²` fix).
- Evidence: **computed** (validated against the 2D-Euler invariants and a closed-form viscous decay).
  **Status: :tested.** Scope: **phenomenology / 2D active-turbulence truncation — NOT the NS PDE.**
  The fluid substrate of an active-matter study; bears nothing on regularity.
- Depends_on: NS-010 (the validated 2D vorticity–streamfunction solver it extends).
- Source: `scripts/active_turbulence_fluid.jl` (+ `active_turbulence_fluid.out.txt`); companion
  `docs/active_turbulence_companion.md`. Reuses the fluoddity Fourier brain (idea-sharing fork,
  Phase 2). Plan: `~/.claude/plans/jazzy-zooming-horizon.md`.

**AT-2 — Passive forced-turbulence control: the faithful fluid produces a real 2D enstrophy
cascade.** Before adding agents (Phase 2), the control that licenses trusting the AT-1 fluid: drive
it with a steady band-limited (passive, random-phase) vorticity forcing at injection scale `k_f=8`,
dissipate by real `ν∇²` (small scales) + a low-k Rayleigh drag (large scales), run to a statistically
steady state (N=128, E≈0.68, Z≈33), and bin the time-averaged `E(k)=½Σ|ω̂|²/|k|²`.
- **Forward (k>k_f) — a clean Kraichnan enstrophy cascade: slope −3.36, R²=0.99** over k∈[10,25],
  steeper-than-−3 from coherent vortices (the documented real-2D-DNS behaviour). This is a *universal*
  inertial exponent — exactly what the fluoddity engine could NOT produce (its slope was a
  forcing-controlled *dial* spanning −1.4..−3.1 with no universal value). The faithful fluid
  turbulates like real 2D NS.
- **Inverse (k<k_f)** — energy piles below `k_f` (arrested by the drag ⇒ a steady state exists); the
  range is shallow/flat (slope ≈ +0.4), the energy-containing region — **not** a resolved −5/3
  inverse-inertial range, which needs ≥1 decade below `k_f` ⇒ **N≥256 at high `k_f` (deferred).**
- **AT-04 (→ T-17):** the dual-cascade *structure* — a steep forward enstrophy range distinct from a
  shallow inverse range — is present (forward −3.36 vs inverse +0.45). The clean deliverable is the
  forward enstrophy cascade.
- Evidence: **computed** (steady-state, time-averaged spectrum). **Status: :tested.** Scope:
  **phenomenology / 2D forced-turbulence truncation — NOT the NS PDE.**
- Depends_on: AT-1 (the faithful fluid it forces).
- Source: `scripts/active_turbulence_forced.jl` (+ `active_turbulence_forced.out.txt`); companion
  `docs/active_turbulence_companion.md`.

**AT-3 — Discrete active-dipole agents coupled to the faithful fluid: net-zero forcing (AT-03).**
The active-matter coupling — the rigorous fluoddity. N=1500 self-propelled agents swim in the AT-2
fluid, sense the velocity at two body-frame sensors, steer by the **ported fluoddity Fourier brain**
(10-center mirror-symmetric sum-of-sines), are advected + **co-rotated by the local vorticity ω/2**
(the physical leading-order reorientation), and force the fluid back as **net-zero force DIPOLES**
(+f ahead, −f behind, each spread by a normalized Gaussian immersed-boundary kernel) through AT-1's
curl-of-force hook.
- **AT-03 (→ T-18) — the faithful-forcing check.** The dipole forcing injects net grid momentum
  **(3e-15, −2e-14), relative 9.5e-18 — MACHINE ZERO**, the defining property of an active swimmer.
  The fluoddity **monopole** (head force, no tail) injects **(−30, 20), relative 3.7e-2 — O(1)**:
  spurious momentum, unphysical. *This is the precise sense in which the fluoddity splat was not
  physical*, and the fix is named and verified.
- **Stable coupled system:** over 1500 steps the agent⟷fluid system stays bounded (E, Z finite;
  agents swim steadily at ≈0.32). At these parameters the active flow is **weak** (E≈5e-4) — net-zero
  dipoles inject little large-scale energy ⇒ fluid speed ≪ swim speed (weak two-way coupling); Phase 3
  cranks `forceGain`/density toward u_rms ~ swim, where collective self-organization would live.
- Evidence: **computed** (machine-precision momentum check + stable integration). **Status: :tested.**
  Scope: **phenomenology / 2D active-turbulence truncation — NOT the NS PDE.**
- Depends_on: AT-1 (curl hook + fluid), AT-2 (the forced fluid it swims in).
- Source: `scripts/active_turbulence_agents.jl` (+ `active_turbulence_agents.out.txt`); companion
  `docs/active_turbulence_companion.md`. Brain ported from the fluoddity engine (idea-sharing fork).

**AT-4 — Does lifelike organization emerge? A NULL — and it reframes the fluoddity engine.**
The climax test of the arc. Cranked to a vigorous active flow (forceGain=25, N=2000 agents ⇒
**u_rms≈0.6 > swim 0.35**, **42% vortex-dominated** by Okubo–Weiss — the *fluid* self-organizes into
coherent vortices, the real 2D phenomenon), the agents are censused for self-organization.
- **NULL — the agents do not cluster.** Pair-correlation **g(r) ≈ 1.0 everywhere** for both the
  brain-sensing agents AND a dumb-swimmer control (ratio 1.00); no aggregation, no creatures. Lifelike
  organization does **not** emerge from active velocity-sensing agents on a faithful incompressible
  fluid.
- **The reframing:** the fluoddity engine's "creatures/vacuoles" were therefore **not** emergent
  active turbulence. They required two ingredients absent here — (a) **chemotaxis** (cohesion: steering
  up the *density/dye* gradient, toward other agents; this port senses only velocity), and/or (b) the
  **non-physical momentum-monopole forcing**, which created convergence/sink regions agents pile into —
  *impossible* on a divergence-free fluid. The lifelikeness was **chemotaxis + a compressible-forcing
  artifact**, not active-turbulence organization.
- **Decisive follow-up (UNTESTED, flagged):** add the chemotaxis term and re-census — does
  density-aggregation reproduce clustering on the faithful fluid? That isolates whether *any* lifelike
  organization survives on a physical substrate.
- Evidence: **computed** (vigorous coupled run + pair-correlation/Okubo–Weiss census, brain-vs-dumb
  control). **Status: :tested** (an honest NULL). Scope: **phenomenology / 2D active-turbulence
  truncation — NOT the NS PDE.**
- Depends_on: AT-3 (the agent coupling it censuses); cf. fluoddity spectrum study (the engine reframed).
- Source: `scripts/active_turbulence_organization.jl` (+ `active_turbulence_organization.out.txt`);
  companion `docs/active_turbulence_companion.md`.

**AT-5 — Chemotaxis closes the question: lifelike aggregation DOES survive on the faithful fluid.**
The decisive follow-up AT-4 flagged. AT-4 found velocity-sensing agents do not cluster (g(r)≈1);
it hypothesised the fluoddity "creatures" needed (a) **chemotaxis** (the omitted `cohesion`
ingredient) and/or (b) the **non-physical monopole forcing** (convergence sinks). This isolates (a):
on the SAME faithful incompressible fluid with the SAME net-zero dipole forcing, the agents deposit a
density field and **steer up its gradient** (toward each other). Control = dumb swimmers (cohesion=0).
- **CHEMOTAXIS CLUSTERS.** Pair-correlation **g(r) peaks 4.0× at contact** (r≈0.03) and 1.86× over the
  near field for the chemo agents, decaying to uniform by r≈0.3 — while the dumb control stays a
  uniform gas (g≈1.0). Near-field ⟨g⟩ = **1.31 (chemo) vs 1.00 (dumb)**, ratio 1.31.
- **Closes the question + sharpens AT-4's reframing.** Lifelike organization *does* survive on a
  faithful incompressible NS fluid — but via **chemotaxis (aggregation), not active turbulence**. And
  because clustering appears on a **divergence-free** fluid, it is **not** the compressible-monopole
  sink artifact ⇒ **AT-4 candidate (b) is RULED OUT.** The fluoddity creatures were genuinely
  chemotaxis-driven aggregation — a real, substrate-independent mechanism — layered on a fluid that
  *itself* self-organizes into vortices (AT-2/AT-4). Active turbulence makes the vortices; chemotaxis
  makes the creatures; the two are separate.
- Evidence: **computed** (chemo-vs-dumb pair-correlation census on the faithful fluid). **Status:
  :tested.** Scope: **phenomenology / 2D active-turbulence truncation — NOT the NS PDE.**
- Depends_on: AT-4 (the velocity-only NULL it resolves), AT-3 (the agent coupling), AT-1 (the fluid).
- Source: `scripts/active_turbulence_chemotaxis.jl` (+ `active_turbulence_chemotaxis.out.txt`);
  companion `docs/active_turbulence_companion.md`.

**AT-6 — GPU faithful-fluid core: GPU(float32) ≡ CPU(float64), ~100× faster (Phase 4a).**
The GPU port (Phase 4a of "validate then watch"): the faithful 2D vorticity IF-RK4 solver (AT-1/AT-2)
re-implemented on the GPU in **MPSGraph** (`metal/active_turbulence_gpu.swift`, the same engine as the
NS-038→039 GPU DNS — built-in `fastFourierTransform`, GPU-resident ping-pong, NO hand-written Metal
kernels), cross-validated against the CPU Julia. Mirrors the NS-038→NS-039 GPU≡CPU discipline.
- **GPU ≡ CPU to ~6 digits (float32-limited):** **AT-01** inviscid invariants conserved to **3.8e-6**
  (CPU float64: 1.3e-14); **AT-02** viscous single-mode decay matches `exp(−ν|k|²t)` to **2.95e-6**
  (CPU: 7.3e-16) — the integrating factor is exact on GPU.
- **Forward enstrophy cascade reproduced:** the forced run gives slope **−3.48, R²=0.99** (CPU −3.36,
  R²=0.99 — a different forcing realization, same *universal* −3 signature).
- **~100× faster:** 3100 steps (N=128, forced) in **3.1 s** on an M5 Max (~1 ms/step) vs ~3 min CPU;
  the GPU FFT is the engine (as `probe_mpsfft.swift` predicted). This is the validated core Phase 4b
  wires into the interactive app for live watching.
- Evidence: **computed** (GPU run cross-checked against the CPU closed-form/invariant/cascade).
  **Status: :tested.** Scope: **phenomenology / 2D active-turbulence truncation — NOT the NS PDE.**
- Depends_on: AT-1 (the CPU fluid it ports + cross-validates against), AT-2 (the forced cascade).
- Source: `metal/active_turbulence_gpu.swift` (+ `active_turbulence_gpu_{at01,at02,forced}.out.txt`);
  companion `docs/active_turbulence_companion.md`. Build/run per `metal/README.md`.

---

## Artifact registry (AT-#)

`AT-ID | Class | Evidence | Status | Scope | Artifact / Citation`

| AT-ID | Class | Evidence | Status | Scope | Artifact / Citation |
|---|---|---|---|---|---|
| AT-1 | RESULT | computed | :tested | phenomenology / 2D active-turbulence truncation (NOT the NS PDE; fluid substrate of an active-matter study) | `scripts/active_turbulence_fluid.jl` (+ `.out.txt`); companion `docs/active_turbulence_companion.md`. The rigorous fluoddity: extends the validated 2D vorticity–streamfunction solver (NS-010) with exact `ν∇²` via IF-RK4 (integrating factor, machine-exact — AT-02 single-mode decay vs exp(−ν\|k\|²t) to 7.3e-16) + a curl-of-force active-coupling hook ((∇×f)_z auto-discards f's compressive part; active dipoles couple in Phase 2/AT-3, f≡0 here). AT-01: unforced-inviscid energy+enstrophy conserved 1.3e-14 (regression vs T-05). Fixes fluoddity's uniform-drag→ν∇² (cascade-bearing) + monopole→dipole (Phase 2). Plan `~/.claude/plans/jazzy-zooming-horizon.md`. |
| AT-2 | RESULT | computed | :tested | phenomenology / 2D forced-turbulence truncation (NOT the NS PDE) | `scripts/active_turbulence_forced.jl` (+ `.out.txt`); companion `docs/active_turbulence_companion.md`. Passive forced-turbulence control proving the AT-1 fluid is a real turbulence engine: steady band-limited vorticity forcing at k_f=8 + ν∇² + low-k drag → statistically steady state (N=128, E≈0.68, Z≈33). **Forward enstrophy cascade E(k)~k^−3 CLEAN (slope −3.36, R²=0.99, k∈[10,25])** — a *universal* Kraichnan exponent, the contrast the fluoddity dial (−1.4..−3.1, non-universal) lacks. Inverse range = energy-containing pileup, shallow (+0.4); a resolved −5/3 inverse-inertial range needs N≥256/high k_f (deferred). AT-04 (→ T-17): dual-cascade structure present (steep forward vs shallow inverse). |
| AT-3 | RESULT | computed | :tested | phenomenology / 2D active-turbulence truncation (NOT the NS PDE) | `scripts/active_turbulence_agents.jl` (+ `.out.txt`); companion `docs/active_turbulence_companion.md`. Discrete active-dipole agents (the rigorous fluoddity): N=1500 swimmers in the faithful fluid sense it, steer by the ported fluoddity Fourier brain, are co-rotated by local ω/2, and force it as **NET-ZERO force DIPOLES** via AT-1's curl hook. **AT-03 (→ T-18): dipole net momentum = (3e-15,−2e-14), relative 9.5e-18 = MACHINE ZERO** (faithful swimmer); the fluoddity MONOPOLE injects (−30,20) relative 3.7e-2 = O(1) spurious momentum (unphysical, shown). Stable coupled run (1500 steps, E/Z bounded, agents swim ≈0.32). Flow weak at these params (E≈5e-4, net-zero dipoles efficient); Phase 3 strengthens coupling toward u_rms~swim for organization. |
| AT-4 | RESULT | computed | :tested | phenomenology / 2D active-turbulence truncation (NOT the NS PDE) | `scripts/active_turbulence_organization.jl` (+ `.out.txt`); companion `docs/active_turbulence_companion.md`. The climax: does lifelike organization emerge? Cranked to a vigorous active flow (forceGain=25, 2000 agents, u_rms≈0.6>swim, 42% vortex-dominated by Okubo–Weiss — the *fluid* self-organizes into coherent vortices). **NULL — agents do NOT cluster:** pair-correlation g(r)≈1.0 everywhere, brain-agents = dumb-swimmer control (ratio 1.00). **Reframes fluoddity:** its "creatures" were NOT emergent active turbulence — they needed (a) chemotaxis (density-aggregation; this port senses velocity only) and/or (b) the non-physical monopole forcing (convergence sinks, impossible on a divergence-free fluid). Decisive follow-up (UNTESTED): add chemotaxis. T-19. |
| AT-5 | RESULT | computed | :tested | phenomenology / 2D active-turbulence truncation (NOT the NS PDE) | `scripts/active_turbulence_chemotaxis.jl` (+ `.out.txt`); companion `docs/active_turbulence_companion.md`. The decisive AT-4 follow-up: add the density-aggregation (chemotaxis) steering on the SAME faithful incompressible fluid + dipole forcing; control = dumb swimmers (cohesion=0). **CHEMOTAXIS CLUSTERS:** pair-correlation g(r) peaks **4.0× at contact** (1.86× near-field), decaying to uniform by r≈0.3, vs the dumb control g≈1.0 (near-field ⟨g⟩ 1.31 vs 1.00). Lifelike organization DOES survive on a faithful fluid — via **chemotaxis (aggregation), not active turbulence**; appearing on a divergence-free fluid **RULES OUT** AT-4 candidate (b) (the compressible-monopole artifact). Fluoddity's creatures = genuine chemotaxis-driven aggregation. T-20. |
| AT-6 | RESULT | computed | :tested | phenomenology / 2D active-turbulence truncation (NOT the NS PDE) | `metal/active_turbulence_gpu.swift` (+ `active_turbulence_gpu_{at01,at02,forced}.out.txt`); companion `docs/active_turbulence_companion.md`. GPU port (Phase 4a) of the faithful IF-RK4 vorticity solver in MPSGraph (same engine as the NS-038→039 GPU DNS; built-in FFT, GPU-resident, no Metal kernels), cross-validated vs the CPU Julia. **GPU(float32) ≡ CPU(float64) to ~6 digits:** AT-01 invariants conserved 3.8e-6 (CPU 1.3e-14); AT-02 viscous decay vs exp(−ν\|k\|²t) 2.95e-6 (CPU 7.3e-16); forced cascade slope −3.48 R²=0.99 (CPU −3.36, same universal −3). **~100× faster:** 3100 steps N=128 in 3.1 s (M5 Max) vs ~3 min CPU. The validated core for Phase 4b (interactive). T-21. |

**Coverage (A1):** every AT-ID (AT-1..6) has a row. **No orphans:** every artifact named exists under
`scripts/` or `docs/`. **Firewall:** all rows `Scope: phenomenology` (≠ PDE, ≠ obstruction map);
validation indexed in `TEST_SPEC.md` (T-15..T-21, retitled AT-#). This track does not affect the
obstruction ledger's `:proved`=0 / distance-UNTOUCHED accounting.
