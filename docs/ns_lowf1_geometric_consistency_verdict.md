# Triad-witness verdict — LOW #1 geometric-consistency ({NS-013, NS-039, NS-040})

**Seats:** Grok (edge-Φ, cold/adversarial) + Gemini (synthesis). **Date:** 2026-06-05.
**Brief:** `docs/ns_lowf1_geometric_consistency_brief.md`. **Disposition: REFUTED (convergent, 2/2).**

**Firewall.** Obstruction-program corollary; no regularity-or-blowup result; `:proved`=0; distance
UNTOUCHED. Gemini additionally flagged that the lemma's own phrasing ("the DNS *exhibits* the depletion
CFM/Hou–Li needs; theory and data line up") **crosses the firewall** — confirmed; the synthesis-doc
§C.3 phrasing was corrected accordingly.

## The claim under witness (NOW REFUTED)

"The CFM/Hou–Li geometric depletion that NS-013 reduces regularity to is *exhibited*, and controllably
strengthened, in the resolved DNS (c²_int relaxes after 0.72; intense-set dimension ≳1.4, never ≤1;
helicity depletes stretching) — theory and our data agree." Plus the sharpened sub-question:
conditional-alignment-persistence and its N/Re trend as the decisive discriminator.

## Per-question verdicts

- **Q1 vacuity — REFUTED (both seats).** The DNS is regular-by-construction (Re=1600, viscous, finite
  grid): *no measurement could have refuted CFM/Hou–Li*, because the flow stays regular regardless. The
  observed depletion is a necessary condition for what is already guaranteed — empty agreement, a
  tautology of regularization. Grok: the only informative-in-the-other-direction outcome (depletion
  fails while regularity holds) is impossible here. Strongest non-vacuous residue granted by Grok:
  depletion *can* occur and *can* be strengthened by a control parameter inside a regular flow — real
  phenomenology, but not evidence it is the mechanism that would prevent a singularity.
  *(Claude: accept; Gemini's "any metric inevitably relaxes" is slightly too strong — a flow could
  dissipate while staying aligned — but the conclusion, vacuous-as-PDE-evidence, stands.)*

- **Q2 proxy / category-fit — REFUTED (both seats). THE DECISIVE BLOW.** CFM requires control of the
  *smoothness* of ξ=ω/|ω| (`∫|∇ξ|²|ω|`); Hou–Li requires nonlinear cancellation arising from it. We
  measure the *pointwise* alignment c²_int and a *coarse* box-dimension. Concrete gap (both seats
  independently): c²_int can relax (look depleting) while `|∇ξ|` blows up at a focal kink / roll-up
  edge between intense regions (CFM integral fails); and the production set can stay ≳1.4-D while ξ
  develops a zero-measure line defect *inside* the set (box-dimension is blind to it). The proxies can
  report "depletion" while the continuous field drives a singularity. They sit in a different category.

- **Q3 decidability — REFUTED as decisive (both seats).** Two symmetric traps at N≤512: (a)
  *pre-asymptotic convergence* — a true sub-grid directional collapse at inaccessible scales leaves the
  persistence metric looking flat/converged, an illusion; (b) *resolution–disorder entanglement* — a
  drift toward de-alignment cannot be separated from the grid resolving higher-k turbulent fluctuations
  (NS-039's lesson in reverse: resolution faked dimension either way). No reachable-N trend classifies
  genuine-crack vs artifact without an independent higher-Re control that does not exist in this
  program. The proposed probe is structurally blind. **DROPPED.**

- **Q4 helicity — WEAKENS (Grok: holds-under-attack; Gemini: breaks).** Helicity is a special global
  invariant; depletion being *dial-able* by it shows depletion is constraint-DEPENDENT. Worst-case ICs
  (Kerr anti-parallel tubes) are zero-helicity by construction. **Synthesis (Grok's careful reading,
  adopted):** NS-040 *weakens the lemma's relevance* to the generic/zero-helicity worst case — the DNS
  evidence is even *less* relevant to the unconstrained case that matters for singularity. It is NOT,
  however, evidence *for* blowup (Gemini's "exact blueprint for how zero-helicity flows race toward a
  singularity" over-reaches in the opposite direction). NS-040 is a constrained-flow mechanism result,
  full stop — licensing neither the pro-regularity lemma nor a pro-blowup reading.

## What survives (scoped phenomenology only — NOT PDE purchase)

The lemma survives only as "phenomenology of vortex-stretching depletion inside one class of regular
flows." It is NOT meaningful consistency with CFM/Hou–Li in any sense that informs the open problem.

## The residue worth keeping (a sharper read of WHERE the open question sits — diagnostics, not PDE)

A singular scenario, IF it exists, must (a) live at ~zero helicity (NS-040/Kerr), and (b) live in `∇ξ`
— the vorticity-*direction gradient* — which the pointwise c²_int and the box-dimension provably
*cannot see* (Q2). Our depletion diagnostics look exactly where a singularity would NOT show up. This
is a statement about our diagnostics' blind spots, `:proved`=0, distance UNTOUCHED.

## Disposition

- **NS-013 stays `:argued`** (unchanged; the PDE question is open; the witness did not touch the
  reduction — it refuted a *consistency lemma* built on NS-038/039/040, not the reduction itself).
- **The geometric-consistency lemma (synthesis §C.3) is REFUTED** → rewritten to the scoped form above;
  its firewall-crossing phrasing corrected.
- **The conditional-alignment-persistence probe is DROPPED** as structurally undecidable (Q3).
- **Meta (cross-audit lesson):** the witness caught an over-reach my own self-audit had passed *and
  committed+pushed* — the validator-confirmation-bias pattern, this time in committed text. The
  adversarial two-seat pass is what caught it.
- **NS-024 honesty:** a *convergent REFUTATION* (2/2 adversarial seats, primed to refute, independently
  failing to save the lemma) is the strongest negative the protocol produces. No promotion, no PDE
  claim. `:proved`=0; distance UNTOUCHED.
