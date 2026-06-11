# Conditional-criterion vacuity map (v1) — do the literature's blowup-exclusion hypotheses hold on real near-singular flow?

**Scope: resolved-DNS WITNESS, vacuity-capped. `:proved`=0; distance to the prize UNTOUCHED.**
This is a *map*, not a result. A resolved truncation cannot reach the singular limit, so a criterion's
behaviour here is a **suggestive prior** about whether its conditional theorem is live or vacuous for the
*actual* singularity — never a proof. Supports NS-048 (the dynamic frontier); generalizes the one probe
(NS-049's `δ_Λ`) that actually told us something.

## The idea

The NS-048/049 literature is a stack of **conditional** exclusion theorems — *"if hypothesis X holds, no
blowup."* The prize-relevant question for each is not whether the theorem is true (it is) but whether its
**hypothesis X actually holds on the flows that approach singularity** — or is vacuous / moves the wrong way.
NS-049 ran this once (`δ_Λ`) and found the hypothesis driven the *wrong* way. This map runs the same move
across every criterion for which we have a committed witness, on the resolved near-singular fixtures
(Taylor–Green, vortex-tube reconnection / Kerr-tube), and reads the **N-refinement trend** — the sharpest
vacuity signal (a hypothesis that holds at N=256 but breaks at N=512 was a resolution artifact).

## The liveness matrix

| Criterion (the conditional hypothesis) | Theorem it feeds | Measured on resolved flow | N-trend | **Verdict** | Source |
|---|---|---|---|---|---|
| **`δ_Λ → 0`** (vorticity one-directional at the intense cores) | NS-049 Lockwood anisotropy-depletion | `δ@.1%` = **0.54** at the `‖ω‖∞` peak — bounded *below*, multi-directional | stable | **VACUOUS** — the multi-directional case his program does *not* cover is the realized one | `ns049_anisotropy_defect_probe` |
| **box-dim(top-intensity set) ≤ 1** (CKN-admissible singular set) | NS-006 CKN / NS-039 | `D30` = 0.986 (N=256) | **lifts → 1.426 (N=512)** | **WRONG-WAY** — the ≤1 touch is a resolution artifact, not a CKN-admissible set | `step2_gate` / NS-039 |
| **pressure-Hessian dominates strain self-amp uniformly** (`⟨e₃ᵀ∇²p e₃⟩ ≳ ⟨λ₃²⟩`) | NS-046 static hole | **negative on the bulk** (−0.13…−0.19, pressure *enhances* stretch); positive only at top-0.1% cores (+2…+15); `ν`/production ≪1 there | N-conv 64↔128 | **NON-UNIFORM** — holds only at the extreme cores, fails on the bulk | `ns046_uniform_domination_probe` |
| **depletion margin persists at high intensity** | NS-046 / Idea-3 | pHess/self-stretch ratio **10.9 (t=0) → 1.5 (t=6 peak)** | — | **MARGIN-SHRINKS** — the real depletion dominance weakens as production grows | `ns046_gradxi_pressure_probe` |
| **Beltramization suppresses the nonlinear driver** (`u ∥ ω` ⇒ small Lamb vector) | NS-045 | **26×** Lamb-vector suppression — but helicity-conditional, and `belt` rises 0.07 → 0.34 (de-Beltramizes) | N-conv 16↔64↔128 | **CONDITIONAL + TRANSIENT** — needs strong helicity; de-Beltramizes (a delay, not a cure) | `ns045_helicity_mechanism` |
| **Riesz / pressure-Hessian ratio bounded, no log** (`R_j` flat) ⇒ harmonic-analytic route live | NS-047 critical-Besov | `R_j ∈ [0.58, 0.76]`, **flat across shells**; `Re_tail ≪ 1` | flat | **LIVE-but-capped** — corroborates NS-047 C1; smallness holds "as it must" in a regular truncation | `ns046_besov_smallness_probe` |
| **vorticity critical-Besov sharper than BKM** (`Ḃ⁰_{∞,1}/‖ω‖∞` diverges faster) — W2 | NS-047 / W2 detector | ratio `Σⱼ‖Δⱼω‖∞/‖ω‖∞` = **1.1–2.0**, bounded (t=3→6) | bounded | **CAPPED** — bounded multiple of BKM in this regular regime; "sharper" is unobservable without the singular limit | computed here from the `ns046_besov` shells |

### The axisymmetric-swirl cells — a faithful `(r,z)` swirl DNS (`scripts/ns048_axisym_swirl_dns.jl`, 2026-06-10)

Built a faithful axisymmetric NS-with-swirl solver (Hou–Li nice variables `u₁=u^θ/r, ω₁=ω^θ/r, ψ₁=ψ/r²`;
**validated 4/4** — 2nd-order radial operator vs analytic, divergence-free, exact `cos(kz)` diffusion, inviscid
`‖Γ‖∞` max-principle conserved). Ran a single-signed swirl blob (Γ≥0 by construction, z-modulated so `∂_zΓ`
changes sign), 160×128, ν=2e-3, T=2.

| Criterion | Theorem | Measured | **Verdict** |
|---|---|---|---|
| swirl-sign `Γ ≥ 0` controls source `S`? | NS-048 swirl-source | Γ stays **≥0** (max principle confirmed), but `sign(Γ)` predicts `sign(S = ∂_z(u₁²) ∝ Γ ∂_zΓ)` only **50%** of the time, correlation **0.000** | **TRUE-BUT-USELESS** — Γ≥0 holds yet carries *zero* information about the source sign (`sign S = sign ∂_zΓ`, indefinite). Numerically confirms `ns048_swirl_sign_condition_attack` |
| `|x₃|^α` axial-swirl growth | NS-048 route-i / anisotropic-z | the no-boundary single-blob does **not intensify** (Γmax 0.376→0.366, scaled-E decreases — viscous); no `|z|^α` concentration | **PARTIAL** — needs a genuinely intensifying fixture (Hou–Luo wall / colliding jets), not a decaying blob |
| Type-I scaled-energy `I` | Albritton–Barker | scaled-energy proxy `I` bounded + decreasing on the non-intensifying flow | **PARTIAL** (vacuity-capped null) — same fixture caveat |

## What the map says (the synthesis — read with the cap)

Of the **eight** criteria now measured, **not one is both true and useful** on resolved flow:

- **two FAIL their hypothesis outright** — `δ_Λ` stays multi-directional (vacuous), and the CKN ≤1 dimension
  *lifts above 1 under refinement* (resolution artifact);
- **one is TRUE-BUT-USELESS** — `Γ≥0` (swirl-sign) genuinely holds (max principle, confirmed in a validated
  swirl DNS), yet is *uninformative* about the source it is meant to control (correlation 0 with `sign S`);
- **two hold only NON-UNIFORMLY / with a shrinking margin** — the pressure-Hessian depletion is real but
  bulk-negative and cores-only, and its dominance margin collapses 10.9→1.5 as production grows;
- **one is CONDITIONAL + TRANSIENT** — Beltramization needs helicity and de-Beltramizes;
- **two are vacuity-CAPPED** — the Besov-route diagnostics behave exactly as a *regular* truncation forces
  them to (smallness/boundedness "as it must"), so they can corroborate the harmonic-analytic route (NS-047)
  but cannot certify it.

The coherent reading — **a suggestive prior, not a theorem**: the easy *conditional* exclusion criteria tend
to have hypotheses that **don't hold on the very flows that intensify**. That is consistent with *why* the
problem is open — the cheap conditional routes are plausibly vacuous for the actual mechanism — and it tells a
future search **where not to spend effort**: a conditional theorem whose hypothesis a resolved near-singular
DNS already violates (or drives the wrong way under refinement) is unlikely to be the route, unless the
singular limit recovers the hypothesis (which the truncation cannot test).

**Hard caveat (the vacuity cap, stated once more because it is load-bearing).** Every cell is a resolved,
regular flow. None reaches the blowup limit. "Hypothesis X fails on resolved near-singular flow" is evidence
that X is *probably* vacuous for the singularity — it is **not** a proof, and a criterion that fails here
could still be the operative one in the true limit (the truncation simply cannot see it). The map narrows
*plausible* attention; it certifies nothing. `:proved`=0.

## Natural next batch

The `(r,z)` swirl DNS is now built and validated (`scripts/ns048_axisym_swirl_dns.jl`); the **swirl-sign cell
is closed** (Γ≥0 true but vacuous-as-control). The two remaining cells (`|x₃|^α` growth, Type-I `I`) need a
genuinely **intensifying** swirl fixture — the no-boundary single-blob viscously relaxes rather than
concentrating. The honest continuation is a **Hou–Luo wall** (solid-boundary) or colliding-jet IC on the same
validated solver — where axisymmetric swirl is known to intensify (the routes mapped in
`ns048_swirl_source_frontier.md` / `ns048_route_i_blowdown.md`). That is its own DNS session.
