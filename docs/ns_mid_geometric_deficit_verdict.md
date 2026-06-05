# Witness verdict — MID coordination: "regularity is irreducibly geometric (∇ξ)"
#                    {NS-005, NS-008, NS-033, NS-034, NS-036}

**Seats run:** Grok (edge-Φ, adversarial) + ChatGPT (NAIVE core witness). **Gemini's MID synthesis seat
did not run** (the panel response file carried Gemini's *LOW #1* verdict instead). **Date:** 2026-06-05.
**Brief:** `docs/ns_mid_geometric_deficit_brief.md`. **Disposition: C4 REFUTED; C1 + a softened residue
survive.**

**Firewall.** Obstruction-program consolidation; no regularity-or-blowup result; `:proved`=0; distance
UNTOUCHED. Both seats independently flagged the *language* of C4 ("ENTIRE", "irreducibly") as exceeding
what is shown.

## The claim under witness

- **C1 (identity, elementary):** P = ∫ω·Sω = ∫|ω|²(ξ·Sξ) — the σ=+1 enstrophy-rung breaker is the
  enstrophy-weighted strain-alignment of the vortex direction ξ.
- **C2 (chain):** regularity ⟺ critical-norm (NS-005) ⟺ enstrophy (NS-036) ⟺ ∫P dt.
- **C3 (deficit):** the only a-priori control (energy, σ<0) is insufficient (NS-008).
- **C4 (synthesis, contestable):** the ENTIRE deficit is carried by ∇ξ and is IRREDUCIBLY GEOMETRIC.

## The decisive signal: the NAIVE seat caught it too

ChatGPT, with no refute-priming, independently circled the exact sentence Grok broke adversarially
("the ENTIRE deficit is carried by ∇ξ and is irreducibly geometric"), calling it "the place where the
prose outruns the demonstrated necessity" and stumbling at precisely the C1→C4 step ("an identity about
alignment with strain, not about derivatives of ξ"). This is NOT the confirmation-bias signature (naive
endorses / adversarial breaks) — it is the opposite: **the over-reach is on the surface, visible to a
cold reader.** That makes the negative verdict robust even without the Gemini seat.

## Per-claim metabolization

- **C1 — STANDS** (uncontested; both seats accept the identity). Useful and exact.
- **C2 — HOLDS, with the slack relocated.** Grok's Q3 claimed "singularity ⟹ enstrophy unbounded is not
  airtight." We push back: energy is *always* bounded (Leray, NS-003), so the NS-036 interpolation
  forces Ḣ^{1/2} bounded whenever energy AND enstrophy are — hence **regularity ⟺ enstrophy-bounded is
  TIGHT.** The genuine looseness is one link further: `∫P dt`-bounded ⟹ enstrophy-bounded is
  **sufficient-only** (the dissipation integral can run while enstrophy stays bounded). So the honest
  chain is `regularity ⟺ enstrophy ⟸ ∫P` (last arrow one-way). Grok located the slack in the wrong
  place; the slack is real but smaller than stated.
- **C3 — STANDS** (NS-008).
- **C4 — REFUTED on "irreducibly" and "ENTIRE" (convergent: Grok adversarial + ChatGPT naive):**
  - **Q1 (uniqueness):** NS-008 rules out energy-*only* and *points to* geometry; it does NOT prove
    ∇ξ-control is the unique route. Grok names survivors not excluded by NS-008 or the scaling wall —
    harmonic-analysis/Besov critical-norm estimates (frequency-space cancellation, no local ξ),
    dispersive/oscillatory-integral cancellation, probabilistic/averaged (non-energy) methods. None are
    known to work for 3D-NS; none are ruled out. "Irreducibly" asserts uniqueness not demonstrated.
  - **Q2 (the ∇ξ leap):** the identity is about the POINTWISE alignment ξ·Sξ, not ∇ξ. The jump from
    "P governs the rung" to "the deficit lives in ∇ξ" smuggles CFM's *sufficiency* (smooth ξ ⟹
    depletion) in as *necessity*. This is the LOW #1 proxy gap (pointwise alignment ≠ ∇ξ) recurring one
    level up — i.e. the same error we had just had refuted.

## What survives (the honest residue)

C1 (the identity) plus the softened, witness-survivable statement:

> The deficit between the controlled (σ<0) and deciding (σ=0) quantities localizes in the vortex-
> stretching production P = ∫|ω|²(ξ·Sξ), which is geometric *in form*. Controlling it via the
> smoothness of ξ (∇ξ, CFM/Hou–Li) is the **best-supported candidate handle** and the one NS-008 points
> to — but it is **NOT** established to be the unique or irreducible route (harmonic-analysis,
> dispersive, and probabilistic methods are not excluded). "Irreducibly geometric" / "the ENTIRE
> deficit" are withdrawn.

## Disposition

- **NS-005, NS-034, NS-036 unchanged** — the center of the map is as they already state it; the MID
  coordination adds the explicit production identity C1 and the softened localization, nothing more.
- **The "irreducibly geometric" synthesis (C4) is WITHDRAWN.** Recorded in synthesis §C.7.
- **Meta (cross-audit lesson, 2nd this session):** my self-audit passed a tidy unification the witness
  broke — LOW #1 ("exhibits"/"line up") then MID ("irreducibly"/"ENTIRE"). The tell both times is a
  TOTALIZING WORD outrunning the support. Logged as a recurring drafting failure mode.
- **NS-024 honesty:** a convergent refutation across an adversarial seat AND an un-led naive seat is a
  strong negative on the over-reach. No promotion, no PDE claim. `:proved`=0; distance UNTOUCHED.
  (Gemini's MID synthesis seat is still open should we want a third read; it would only reinforce the
  negative.)
