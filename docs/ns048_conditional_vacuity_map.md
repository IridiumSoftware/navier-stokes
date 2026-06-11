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
| `|x₃|^α` axial-swirl growth | NS-048 route-i / anisotropic-z | **Hou–Luo WALL fixture** (`wall` mode, z-odd wall-adjacent swirl): the flow **intensifies hard** (‖ω‖ 0→24.7, swirl→wall `r*`=3.34) BUT goes **unresolved** (spurious energy growth `E/E0→1.32`, then NaN) by t≈0.75 even at ν=2.5e-3 / 192×160; in the resolved phase `ℓ_z` does *not* narrow (1.82→1.97) | **RESOLUTION-LIMITED** — the mechanism is real, but a clean `|z|^α` read needs adaptive ultra-resolution (the Chen–Hou regime), beyond a uniform-grid witness |
| Type-I scaled-energy `I` | Albritton–Barker | same wall fixture: `I` grows only **×1.36** in the resolved phase (modest); the ×100+ peak is unresolved garbage | **RESOLUTION-LIMITED** — modest resolved growth, no clean Type-I read at accessible resolution |

**Two runs.** (a) a single-signed **axis blob** (ν=2e-3) closes the swirl-sign cell. (b) a **Hou–Luo wall
fixture** (z-odd wall-adjacent swirl; `scripts/ns048_axisym_swirl_dns.jl wall` → `scripts/ns048_axisym_swirl_wall.out.txt`)
**confirms the intensification mechanism** (strong ω growth, swirl→wall — unlike the relaxing blob) but goes
**unresolved** on any accessible uniform grid before a clean concentration read. That negative is itself a
finding: it numerically reproduces *why* the Hou–Luo blowup required Chen–Hou's adaptive-ultra-resolution
computer-assisted machinery. Cells (ii)/(iii) are **resolution-limited**, not vacuous.

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
problem is open — the cheap conditional routes are plausibly **non-discriminating in the resolved truncation**
(a triad seat's catch: "vacuous in near-singular flow" must NOT smuggle "irrelevant to PDE truth" — it
supports only "may be non-discriminating in *this* regime") — and it tells a
future search **where not to spend effort**: a conditional theorem whose hypothesis a resolved near-singular
DNS already violates (or drives the wrong way under refinement) is unlikely to be the route, unless the
singular limit recovers the hypothesis (which the truncation cannot test).

**Hard caveat (the vacuity cap, stated once more because it is load-bearing).** Every cell is a resolved,
regular flow. None reaches the blowup limit. "Hypothesis X fails on resolved near-singular flow" is evidence
that X is *probably* vacuous for the singularity — it is **not** a proof, and a criterion that fails here
could still be the operative one in the true limit (the truncation simply cannot see it). The map narrows
*plausible* attention; it certifies nothing. `:proved`=0.

## Natural next batch

The `(r,z)` swirl DNS is built and validated (`scripts/ns048_axisym_swirl_dns.jl`); **swirl-sign is closed**
(Γ≥0 true-but-useless) and the **Hou–Luo wall fixture** is built and confirms the intensification mechanism.
What remains for `|x₃|^α` + Type-I is **not another fixture but more resolution** — the wall flow goes
unresolved on any accessible uniform grid before it concentrates. Completing those two cells means an
**adaptive / very-high-resolution** solver (the Chen–Hou regime — moving mesh or spectral with refinement near
the wall corner), which is a substantial numerics undertaking, not a witness probe. The validated `(r,z)`
solver is the right foundation to build that on; the honest status today is that those two cells are
**resolution-limited**, and the witness has reproduced *why*.

**Triad-reviewed and banked (2026-06-11).** Before building any adaptive solver, the *decision* was put to an
adversarial triad (`docs/ns048_adaptive_solver_triad_brief.md` → `..._triad_verdict.md`). A cheap falsifiable
gate (`scripts/ns048_c0_boundary_transfer.jl`) settled it: the NS-050 two-scale estimator **does** transfer to
a wall-pinned self-similar collapse (β recovered to 0.2% — the boundary is an anchor, not a contaminant), but
a competing *fixed* length-scale contaminates it (32–52%), and the real wall DNS is too short/unclean to
supply a clean window. **Decision: bank — cells (ii)/(iii) stay resolution-limited.** The dynamic-rescaling
reuse path (C) is *estimator-licensed but data-starved*, unlocked for a future cleaner collapse; a full
adaptive solver (A) is dominated for this witness objective (justifiable only as separately-argued reusable
infrastructure). Two over-reach traps were caught and recorded: "vacuous ⇒ irrelevant to PDE truth" (no — only
non-discriminating in the truncation), and "resolving the wall ⇒ learning about the NS singularity" (no —
about a known intensification regime under truncation).
