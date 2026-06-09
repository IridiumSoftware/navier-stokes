# NS — Boussinesq material-cause probe (SCOPE — SHELVED for the categorical purpose)

**Date:** 2026-06-08 (scoped); **2026-06-09 status update.** `Scope: model-DNS` (≠ PDE).
**`:proved`=0; distance to the prize UNTOUCHED.**

> **STATUS (2026-06-09, after adversarial edge-witness, endorsed): SHELVED for the categorical purpose.**
> The motivating *categorical* question is **settled algebraically** before any simulation (§1.1) — no DNS
> can move it. What remains is an ordinary Boussinesq fluid-dynamics probe (baroclinic generation vs
> vortex-stretching), of independent but **lower** priority; if ever run it carries **no load-bearing
> categorical claim** and does not test the efficient-closure diagram.

Originally scoped from the material-cause correction in `ns_efficient_closure_categorical.md` §3:
incompressible NS *trivializes* material cause (`ρ=const`; only energy is open). The probe asked whether
**restoring a genuinely-open material cause moves the production object** — and whether any answer can
transfer (it cannot — see §5). §1.1 below records why the categorical part is already decided.

---

## 1. The one question

In incompressible NS the vortex-stretching production `P = ∫ω·Sω` (NS-036) sits in `ker(E)`: it is
invisible to the energy pairing (`⟨P·B(u,u),u⟩≡0`), and energy is the *only* open channel. **Does opening a
material channel change that?** Concretely: add a transported, sourced, diffused material scalar coupled
back to momentum, and measure whether `P` is amplified, suppressed, or untouched — and whether a *new*
production pathway (baroclinic) appears that the pure-NS no-go map never sees.

## 1.1 Why the *categorical* question is already settled (so the categorical yield is ~nil)

The identity that put `P·B(u,u)` in `ker(E)` is **purely kinematic** — `⟨P·B(u,u),u⟩ = ∫ u·(u·∇)u =
½∫ u·∇|u|² = 0` by integration by parts on a divergence-free field. It involves **no density and no
buoyancy.** Adding the buoyancy term `βθê_z` introduces a *separate, additive* energy channel `β∫θ u_z`
that is orthogonal to the advection term; it cannot lift the stretching out of the kernel. **Therefore
`P·B(u,u)` stays in `ker(E)` regardless of the material field** — the categorical claim ("does material
move the production object") has an algebraic answer (no), and a simulation can at best *confirm a known
identity*. This is why the categorical motivation is dead and the probe is shelved for that purpose
(edge-witness Grok Φ, 2026-06-08, endorsed). The buoyancy coupling does add a genuinely new vorticity
source (baroclinic, §2) — but that is ordinary active-scalar fluid dynamics, not a categorical test.

---

## 2. The system (3D Boussinesq — the minimal four-cause-complete fluid)

```
∂ₜu + (u·∇)u = −∇p + νΔu + β θ ê_z          (momentum; buoyancy along gravity)
∇·u = 0                                       (incompressible — Leray P unchanged)
∂ₜθ + (u·∇)θ = κΔθ + s                        (material scalar: advected, diffused, SOURCED)
```

`θ` is the restored **material cause**: open (`s` injects, `κΔθ` dissipates), and it **constitutes the
efficient cause** via the buoyancy term `βθê_z` — the Rosen entanglement ("the product is the catalyst")
made literal. Caveat up front: Boussinesq only *partially* restores material cause (density variation enters
*only* through buoyancy; it is still "incompressible + a buoyant scalar"). **Full** material openness is
compressible NS — a different, harder object, explicitly out of scope here.

### What the coupling adds (the two new terms to track)

- **Energy budget gains a material channel:** `d/dt ½∫|u|² = −ν∫|∇u|² + β∫θ u_z + ∫f·u`. Energy is no
  longer the *only* open channel — material now injects/removes kinetic energy through `β∫θ u_z`. (Note:
  the advective `⟨P·B(u,u),u⟩≡0` is *unchanged* — buoyancy is a separate, additive channel. So the
  categorical prediction is that `P·B(u,u)` *stays* in `ker(E)`; buoyancy adds a sibling, it does not lift
  the stretching out of the kernel. The probe tests this.)
- **Vorticity gains a baroclinic source:** `∂ₜω + (u·∇)ω = (ω·∇)u + νΔω + β ∇θ × ê_z`. The
  **baroclinic term `β ∇θ × ê_z` is a vorticity source independent of vortex-stretching** — a production
  pathway with no analog in pure NS. The central empirical question becomes: **does baroclinic generation
  feed or starve `∫ω·Sω`?**

---

## 3. What to measure (the witness observables)

On a resolved DNS, buoyancy ON vs OFF at matched kinetic energy / matched `Re`:

1. **`P_vortex = ∫ω·Sω`** — the stretching production. Amplified, suppressed, or invariant under buoyancy?
2. **`P_baroclinic = ∫ω·(β∇θ × ê_z)`** — baroclinic enstrophy generation. Its magnitude *relative to*
   `P_vortex`, and its sign-correlation with `P_vortex` (does it add to or oppose stretching?).
3. **Energy-kernel check:** confirm `⟨P·B(u,u),u⟩≈0` persists (algebraic, must hold) while the new
   `β∫θ u_z` channel is nonzero — i.e. the production stays in `ker(E)`; material opens a *sibling* channel,
   not a door onto the stretching.
4. **Phase-coherence test (port NS-013).** Random-phase surrogate preserving `|û(k)|` **and** `|θ̂(k)|`
   (so kinetic energy, enstrophy, scalar variance all exact). Does the production still collapse? And the
   new question only Boussinesq can ask: does the **cross-field phase coherence** between `û` and `θ̂` carry
   `P_baroclinic` — i.e. is baroclinic generation *also* a phase-coherence object, or is it visible to the
   quadratic (`θ`-variance) invariants?

A result is a measured statement of the form: *"at Rayleigh Ra=X, buoyancy amplifies/suppresses `P_vortex`
by factor Y; `P_baroclinic` is Z% of total enstrophy generation and (co/anti)-aligned; the phase-scramble
collapse (persists / changes — cross-coherence carries W%)."* That answers the categorical question
empirically, within-truncation.

---

## 4. Effort ladder (N=1 → 3D), maximum insight per unit effort

- **N=1 calibration — 2D Boussinesq (cheap, and regularity is KNOWN).** 2D Boussinesq with full dissipation
  is globally regular (Chae 2006; Hou–Li 2005) — a clean baseline where production is controlled. Smoke
  gate: scalar transport conserves `∫θ` (source off) to machine precision; buoyancy injects energy with the
  correct sign; `P_baroclinic` computed two ways agree. Measure how `θ`-throughput modulates `P_vortex`
  here first, where nothing can blow up.
- **Step 2 — 3D Boussinesq**, extending the validated pseudospectral chain (`scripts/dns_tg256.jl`): add a
  `θ` field (same spectral machinery), the buoyancy term in the momentum RHS, scalar diffusion `κ`, and an
  optional band-limited source `s`. Re-run observables (1)–(4) on a Taylor–Green and on the tube/reconnection
  fixture used for NS-038/NS-049.
- **Reuse, don't rebuild:** the FFT/dealiasing/dyadic-band tooling, the phase-scramble surrogate
  (`ns013_phase_production_3d.jl`), and the `∫ω·Sω` diagnostic all port directly; only the scalar transport +
  buoyancy + baroclinic diagnostic are new.

---

## 5. Vacuity caps (mandatory — read before believing any number)

1. **Resolved DNS ≠ the singular limit.** Every number is within-truncation; `:proved`=0.
2. **Boussinesq is NOT the Clay NS, and NOT a test of the diagram.** A result about Boussinesq production
   does **not** transfer to incompressible NS-001. Nor does it test the categorical claim — that is settled
   algebraically (§1.1). Any run is *standalone Boussinesq fluid dynamics*; the baroclinic source is absent
   from real Clay NS by construction. State this loudly on any finding.
3. **Boussinesq itself only partially restores material cause** (buoyancy-only density coupling). Don't read
   "four-cause-complete" as "physically complete"; full material openness = compressible NS, out of scope.
4. **Connection to known terrain (honest framing, not novelty):** the material-scalar enlargement is the
   well-trodden **active-scalar-as-NS-analog** territory (SQG / Constantin–Majda–Tabak; 2D-Boussinesq ≈
   3D-axisymmetric-Euler, Majda–Bertozzi). The probe's only residual value is a measurement *within that
   fluid-dynamics literature* (baroclinic vs stretching) — not connecting it to the categorical reframing
   (§1.1 settles that), and not discovering the analogy.

---

## 6. Decision — what it would (not) earn

- It earns **nothing on categorical grounds** — the categorical question is closed algebraically (§1.1),
  so a run cannot upgrade the diagram (`ns_efficient_closure_categorical.md` stays `Scope:
  categorical-analogy`, no NS-ID).
- *If* run later as standalone fluid dynamics and it yields a clean measured statement (§3), it earns
  **one NS-ID**, Class DIAGNOSTIC, `Scope: model-DNS`, status `:tested` — about *Boussinesq*
  baroclinic/stretching interaction, explicitly fire-walled from NS-001 *and* from the diagram.
- **The "null" is not merely likely — it is proven (§1.1):** `P·B(u,u)` *stays* in `ker(E)` (the identity
  is kinematic; buoyancy is additive/orthogonal), so material opens a sibling door, it does not move the
  stretching production. The over-reach to refuse: dressing any measured Boussinesq modulation as "material
  cause resolves/illuminates the prize," or as "testing the four-cause diagram." It does neither — caps (1),
  (2).
