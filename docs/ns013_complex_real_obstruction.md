# Companion — NS-013 obstruction-map: why complex-data blowup does not inform real-data regularity (and what it reduces to)

**Session date:** 2026-06-04. **Owner:** Aaron Green.
**Status of this document:** an **`:argued`** obstruction-map (manual analytic argument), **pending
triad-witness** before any spec promotion. **Scope: PDE (framing / no-go).** It establishes **no**
PDE regularity-or-blowup result; `:proved`=0; distance to the prize **UNTOUCHED**. Its content is a
*dissolution* of a hoped-for path, not a step along one.

---

## §1 — The question (NS-013)

Li–Sinai (NS-012) **proved** finite-time blowup for 3D Navier–Stokes with *complex* initial data
(renormalization-group fixed point). The analyticity-strip picture (NS-010/011) frames real blowup
as "the nearest complex singularity reaches the real axis." **NS-013 asks: does the complex result
inform the real-data regularity problem?** Status going in: `:open`, evidence `none`. The only prior
content is the 1D complex-Burgers reality-leakage probe (a mechanism illustration). This document
asks the question *seriously* — is there a genuine real⇐complex implication? — and maps precisely
where the answer dies.

## §2 — The argument (obstruction-map)

**(i) What the Li–Sinai construction exploits.** The blowup is built for complex `u₀:ℝ³→ℂ³` via a
Fourier-space RG fixed point. Its engine is that, for complex data, **the energy `∫|u|²` is not a
coercive real quantity** — it need not be real or positive, and the Leray energy inequality (NS-003)
does not bind. The backward (blowup) construction succeeds *because* it lives in a regime with **no
global coercive control**.

**(ii) What "reality" is, structurally.** Real `u(x)∈ℝ³` ⟺ Hermitian symmetry `û(−k)=conj(û(k))`.
Two exact consequences:
1. **Reality = the Leray control.** `∫|u|²dx = (1/|Ω|)Σ_k|û(k)|²` is then **real and non-negative** —
   reality is *precisely* what makes the energy a coercive global control (NS-003).
2. **Conjugate-pair singularities.** The complex singularities of the analytic continuation of a
   real field occur in conjugate pairs (symmetric across the real axis). Real blowup (NS-010/011)
   therefore needs a conjugate **pair** to reach the axis *simultaneously* — not a lone singularity.

**(iii) The constructive direction is VACUOUS (the key finding).** complex-blowup ⇏ real-blowup.
The *mechanism* of the complex construction — escape from the energy constraint — is exactly what
reality removes. Li–Sinai operates in the **unconstrained regime the real problem never enters**, so
it is not a rung toward the real prize. The "easy direction" of NS-013 carries no implication.

**(iv) The only genuine content is the PROTECTIVE direction — and it is the prize itself.** The real
question is whether reality (conjugate-pair symmetry **+** the energy bound) *keeps* both singular-
ities off the axis. That is a **regularity** statement. But the control reality supplies is the
**energy** bound, which is **supercritical** (NS-002): bounded energy does not reach small scales.
So "reality protects" cannot be cashed from the energy bound alone — one would need control at *all*
scales, i.e. the bounded-enstrophy rung (NS-036, the criticality–Casimir hinge). **NS-013 therefore
reduces to the same single inequality as NS-036 — "can enstrophy `∫|ω|²` be bounded a priori?" —
which is the open problem.**

**Net.** NS-013 splits into a vacuous half and the prize: complex ⇏ real (no-energy regime), and
real-regularity ⟺ "conjugate pair + a *coercive-enough* control hold the strip open," where reality's
control (energy) is supercritical ⇒ the **NS-002 / NS-036 wall**, not a shortcut.

## §3 — Verification (this is a manual argument; what is rigorous vs. argued)

**Rigorous (textbook / exact) premises:**
- Reality ⟺ Hermitian symmetry `û(−k)=conj(û(k))`; under it, `∫|u|²` is real and ≥0 (Parseval). *Exact.*
- Conjugate-pair symmetry of singularities of a real-analytic field's continuation. *Standard.*
- Energy is supercritical for the NS scaling (NS-002/NS-034); the regularity question is equivalent
  to bounding a critical quantity, e.g. enstrophy on the Ḣ^s ladder (NS-036). *Established in-program
  (`:argued`/algebraic) + standard.*
- Li–Sinai blowup requires complex data and is not known to transfer to real data. *Cited (NS-012).*

**Argued (the synthesis — the load-bearing, non-rigorous step):** that premises (i)–(iv) *together
close* the path — i.e. that the reason no real⇐complex implication exists is specifically the
energy-constraint escape, and that the protective direction is co-extensive with the NS-002/036 wall.
This is a structural argument, **not a theorem**: it does not *prove* that no clever real⇐complex
implication exists (absence-of-implication is not itself proved), only that the natural one is
vacuous and the protective one is the prize. **Evidence type: manual. Status ceiling: `:argued`.**

**Over-reach flag (armed):** "reality protects for 3D-NS" ⟺ global regularity ⟺ the Clay prize. Any
model in which reality protects (Step-2 probe) is evidence about *that model's criticality*, **never**
about real 3D-NS. This document claims no PDE result.

**Witness requirement:** per program discipline ("witness elegant convergences before promoting"),
this obstruction-map must be triad-witnessed (Grok edge-Φ / Gemini synthesis) before any promotion
beyond `:argued`. Pre-registered question for the witnesses: *is the absence of a real⇐complex
implication argued or merely asserted, and is the reduction to NS-036's enstrophy rung tight or
loose?*

## §4 — Spec impact

Sharpens **NS-013** (stays `:open` as a PDE question; this map is the first `:argued` content):
complex ⇏ real is **vacuous** (no-energy regime); real⇐complex-as-regularity ⟺ the NS-002/NS-036
enstrophy rung. Proposed: record this as the NS-013 obstruction-map (`:argued`, pending witness),
*not* a new `:proved`/`:tested` claim. Depends_on: NS-012 (Li–Sinai), NS-003 (energy/Leray), NS-002
(supercriticality), NS-036 (criticality–Casimir), NS-010/011 (analyticity strip). The Step-2
falsification-ladder probe (below) tests the corollary prediction. `:proved`=0; distance UNTOUCHED.

---

## Addendum (2026-06-04) — Step-2 probe: the falsification ladder (result)

Tested the corollary prediction (reality-protection tracks the criticality of the available coercive
control) across a ladder of models, each run with complex data + a tunable reality leakage `−iλ·Im`
(λ→∞ forces real). Scripts: `scripts/ns013_reality_ladder.jl` (1D), `ns013_reality_ladder_2d.jl`,
`ns013_reality_ladder_3d.jl`. Each solver validated (Burgers λ=0 ≡ Cole–Hopf t*=5.49; CLM large-λ
≡ real-CLM t*=2.0; 3D complex IC div-free to 5e-13).

**Protection threshold λ_c (lower = easier to protect = stronger control):**

| rung | coercive control | Euler (ν=0) | NS (ν=0.01) |
|---|---|---|---|
| 1D Burgers | viscosity / max-principle (subcritical) | (shocks) | **0.05** |
| 2D NS | energy + **enstrophy** (critical) | 0.5 | **0.1** |
| 3D NS | energy **only** (supercritical) | 1.0 | **0.5** |
| 1D CLM | **none** (pure vortex stretching) | **∞ (never)** | — |

**Findings.** (a) BINARY (robust): every model with a coercive control protects (finite λ_c, with a
delay-then-threshold T*(λ) shape); CLM (no control) never protects — it only *delays* toward its
finite real-blowup time. (b) GRADIENT (at matched ν): λ_c rises monotonically with dimension /
decreasing criticality — 1D(0.05) < 2D(0.1) < 3D(0.5) at ν=0.01; 2D(0.5) < 3D(1.0) at ν=0 — and
viscosity uniformly lowers λ_c. **3D is the hardest controlled model to protect, precisely because
its only control (energy) is supercritical (NS-002)** — the same wall, as a gradient. This
corroborates the obstruction-map: complex⇏real is vacuous, and the protective direction is gated by
the criticality of the control, weakest in 3D.

**Caveats (firewall).** Truncation-scoped: every real fate is regular *because the finite truncation
regularizes* — NOT 3D-NS PDE evidence. λ_c is IC/N/ν-dependent; only the *monotone ordering at matched
ν* is the robust signal. Suggestive corroboration in models, not a law. `:proved`=0; UNTOUCHED.

---

## Witness pass (2026-06-04) — REFUTED as a logical barrier; sharpened to a geometric open mechanism

Triad-witnessed (Grok edge-Φ + Gemini synthesis; brief `docs/ns013_triad_brief.md`). **Both seats
converged on refuting the map** on all four questions: (Q1) "complex⇏real is vacuous" is asserted,
not established — conjugate symmetry is a strong analytic constraint not ruled out as a real⇐complex
bridge, and it conflates Li–Sinai complex-*data* with the analyticity strip (NS-010, non-vacuous);
(Q2) the reduction "reality ⟹ *only* energy ⟹ supercritical ⟹ enstrophy rung" is **loose** —
"energy supercritical ⟹ reality can't protect small scales" is a *non sequitur* (Grok), ignoring the
conjugate-phase structure; (Q3) attributing the truncation λ_c gradient to PDE supercriticality
crosses the firewall; (Q4) the ladder is "definitional theater," its gradient likely a mode-density
artifact (untested). **Hidden assumption both broke:** that the *only* relevant structure reality
supplies is the positive energy norm. The map **does not survive** as a logical obstruction.

**Sharpened analysis (post-witness, the corrected map — and it corrects the witnesses too):**
1. Reality's Hermitian phase constraint does **not** generically deplete the cascade — *real 3D-NS
   turbulence is the prototypical strong forward cascade*. So reality's phase *per se* supplies no
   generic coercive small-scale bound. (Corrects the witnesses' "phase depletes": that conflates the
   Hermitian constraint with *dynamical* coherence.)
2. The regularity-relevant depletion is **emergent + geometric**: vorticity/intermediate-strain
   alignment (Ashurst; Hou–Li) ⇒ the **Constantin–Fefferman** conditional criterion (direction
   ξ=ω/|ω| regular where |ω| large ⟹ no blowup). Conditional, unproven for general data.
3. **NS-013's protective direction reduces to the emergent geometric depletion (CFM / Hou–Li
   conditional regularity)** — not to "reality=energy" nor to reality's phase symmetry. Connects
   NS-013 → NS-006 (CKN geometric) → CFM → **NS-038's measured `c²_int`** (c²_int peaks ≈0.72 at the
   stretching max — the Hou–Li signature, already in the DNS).
4. **Honest open mechanism:** *does reality's emergent dynamics produce enough geometric depletion
   (vorticity-direction regularity, CFM) to control small scales?* — precisely located, conditional,
   open. NOT a barrier, NOT a bridge.

**Disposition:** the original obstruction-map is **withdrawn as a logical claim** (witness-refuted);
kept here as the recorded attempt + refutation (the NS-024 honesty pattern). NS-013 stays `:open`.
The surviving contribution is the *sharpened reduction to the CFM/Hou–Li geometric mechanism* +
the *model fact* that controlled models protect and CLM does not. No `:proved`/`:tested` PDE claim;
`:proved`=0; distance UNTOUCHED. (Optional confirmation probe: a matched-spectrum Hermitian-vs-
scrambled-phase production measurement would test claim 1 — that reality's phase does not generically
deplete — but `c²_int` from NS-038 already evidences the geometric mechanism of claim 2.)

## Consolidation (2026-06-11; TRIAD-TRIMMED same day — `docs/ns046_ns013_triad_verdict.md`)

The consolidation below was put to a two-seat adversarial pass (Grok Φ + synthesis) **and trimmed hard**; the
GPU N-trend then *empirically confirmed* the seats' central attack. The honest record:

- **Claim 1 (phase-scramble, `ns013_phase_production_3d`): survives only as "quadratic invariants are
  insufficient."** The 97–99% production collapse under an invariant-preserving scramble is close to textbook
  triple-correlation phenomenology (odd moments of phase-random fields vanish); a *negative* result would have
  been the surprise. The calibration value (E,Z,H held to ~1e-16 while `∫ω·Sω` collapses) stands; the bridge
  to the *reduction* does not (P2-C1: NOT ESTABLISHED).
- **Claim 2 (`ns013_cfm_conditioned_probe`): the "ξ smoother in cores" reading is REFUTED — and the N-trend
  killed it empirically.** The N=64 headline (core/bulk 0.57) **reverses under refinement: 2.62 at N=256**
  (`ns013_cfm_gpu_trend.jl`; the NS-039 lift pattern). The seats' three attacks all landed: the 1%→0.1% uptick
  was load-bearing, the single-N footing was weak, and there is a **kinematic confound** (high-`|ω|` sets in a
  tube fixture are organized *by construction* — "vortex tubes are tube-like" is morphology, not protection).
  **N=512 final: 4.15 — monotone lift 0.57→2.62→4.15**; the extreme cores roughen with resolution and the
  roughening is itself unconverged at N=512. The N=64 reading is dead; what the trend *witnesses* (cap intact:
  regular flow, reconnection physics) is that direction-roughness CONCENTRATES at the most intense set under
  refinement — the kinematic "tubes are smooth" intuition fails exactly at the cores.
- **The "reduction" itself: REFUTED as a reduction (P2-C3) — it is a relabeling.** CFM is a necessary
  condition for *any* NS flow; "the protective direction reduces to CFM" adds no discriminating content, and
  the complex-data angle contributes almost nothing (the 1D one-sided Fourier-support mechanism does not
  transfer to 3D except as analogy). Elimination-by-exhaustion is not a reduction.

**The stable landing (adopted from the synthesis seat):**
> *Reality's phase/Hermitian structure alone does not appear protective; geometric organization remains the
> leading surviving candidate — but the reduction to CFM is **argued, not witnessed**.*

**Status:** NS-013 stays **`:open`**; the surviving content is `:argued` + **two adjacent, non-diagnostic
witnesses** (neither touches the load-bearing step). What a *diagnostic* witness would need: a measurement
that discriminates CFM-geometric protection from the alternatives (helicity depletion, other alignments,
viscous regularization) — e.g. direction-roughness vs blowup-indicator correlations that differ systematically
between real and complex data. None exists. The open core is the analytic CFM-sufficiency question, which the
program will not manufacture. `:proved`=0; distance UNTOUCHED.
