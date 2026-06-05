# Corollaries of the no-go map + TCE self-map v2 (the 30-node ledger)

**Date:** 2026-06-04. **Owner:** Aaron Green. **Scope firewall:** `:proved`=0; everything here is
*structural/methodological* consolidation of a no-go map — no PDE theorem. Distance UNTOUCHED.

Consolidation at the program's mature plateau: (A) the map's structure, (B) the TCE self-map re-run
on the now-30-node ledger (NS-031 update), (C) the corollaries/lemmas the no-go understanding yields.

---

## A. The map has a center — but it is a *reduction*, not a triad

Multiple independent routes reduce to **one rung: can enstrophy `∫|ω|²` be bounded a priori?**
— NS-002 (supercriticality), NS-036 (criticality–Casimir hinge, *exactly*), NS-006 (CKN ≤1-D),
NS-013 (the witness-sharpened CFM/Hou–Li geometric reduction), with NS-038/039/040 *observing* the
relevant quantities. **Refinement from the TCE re-run (below):** the convergence is real but *loose*. The enstrophy-rung
members surface as a **MID-band coordination** ({NS-005,008,036}, {NS-033,034,036}, {NS-005,006,008}
@0.78) — not HIGH — and the NS-013↔DNS geometric-depletion link surfaces at **LOW** ({NS-013,039,040}
@0.70). The reduction-chain character (deps lead to the rung across layers, not multi-angle on one
object) is *why* it reads MID/LOW rather than HIGH. The sharpest structural signal is that the **HUB is
the critical-norm node NS-005** — it anchors the HIGH critical-norm cluster *and* dominates the MID band.

## B. TCE self-map v2 — `Discovery.Triadic` on the 30-node corpus (NS-031 update)

Re-ran the TCE engine (`SpecBridge → Discovery.Triadic`, via `discovery/ns_obstruction_corpus.json`,
now 30 nodes) — the matured ledger vs. NS-031's original 20 nodes. 126 candidates; HIGH band
(coordination score ≥0.85, "multi-angle on one object"):

- **Supercriticality-consequences + dead-paths** @1.0: {NS-002, NS-007, NS-009}, {NS-002, NS-007/009,
  NS-020} — the central wall and the falsified/no-go entries cohere.
- **The critical-norm cluster** @0.92–1.0: {NS-005, NS-008, NS-033}, {NS-005, NS-008, NS-034},
  {NS-005, NS-033, NS-034} — **NS-005 (the one open backward path NS-002 leaves) coordinates tightly
  with no-energy-only (NS-008) + the exact scaling calculus (NS-034) + the manifold geometry (NS-033).**
  *This is the structurally-indicated live edge.*
- **Diagnostic → blowup-hunt** @1.0: {NS-010, NS-011, NS-032} — the analyticity-strip + complex-
  tracking + the gated inviscid-TG hunt (the complex-plane track as a unit). *New (NS-032).*
- **Resolved-DNS cluster** @0.95: **{NS-038, NS-039, NS-040}** — found independently as a tight unit.
- **Closure / bridge / method / self-map** @0.86–1.0: {NS-023, NS-024, NS-025}, {NS-024, NS-030,
  NS-031}, … — the meta-arc coheres; the tier-wall (NS-024/030/031 = the only bridges) holds.

**Findings vs NS-031:** (i) the engine independently recovered the new clusters (DNS trio; diagnostic-
hunt) — corroboration; (ii) it elevated the **critical-norm cluster** as a HIGH coordination — a clear
"where the live work is"; (iii) the enstrophy-rung convergence surfaced only as a *loose MID/LOW
coordination* (NS-036 at MID, NS-013↔DNS at LOW; see below), not HIGH — consistent with its
reduction-chain character (§A); (iv) the closure tier-wall (zero classical×closure triads) still holds
at 30 nodes.
**MID band** (0.7–0.85, 49 candidates): **NS-005 is the HUB** — it anchors most MID triads (paired with
NS-006/007/008/009/020/033/036); the **enstrophy hinge NS-036 coordinates** here ({NS-005,008,036},
{NS-033,034,036}, {NS-008,034,036} @0.78) — the rung IS a coordination, just looser than HIGH.
**LOW band** (0.55–0.7, 59 candidates): #1 = **{NS-013, NS-039, NS-040} @0.70** — the CFM-reduction ↔
DNS-`c²_int` link, found *independently by the engine*. (It suggested a "geometric-consistency lemma"
[§C.3] that was subsequently **witness-refuted 2/2**; the link is real as *coordination*, but carries
no PDE content — see the verdict doc.) Full log: `discovery/ns_triad_discovery.out.txt` (268 lines, reproducible via the invocation in
its header).

## C. Corollaries / lemmas of the no-go map (scoped; no proofs)

Genuine structural/methodological lemmas the assembled no-go understanding yields:

1. **Necessary-conditions bundle for blowup (unification).** Any 3D blowup must *simultaneously* be:
   enstrophy-unbounded (NS-002/036) **and** critical-norm (NS-005) **and** CKN-≤1-D in spacetime
   (NS-006) **and** geometric-depletion-failing (NS-013/CFM) **and** (Onsager) at/above the 1/3
   dissipation threshold (NS-009). A *tight conjunctive target* — a candidate failing any one is dead.
2. **Dead-paths checklist (what NOT to try):** not exact self-similar (NS-007); not energy-only
   (NS-008); not topology/homology (NS-020, *falsified*); not a complex⇐real shortcut (NS-013,
   *witness-refuted*). Enumerated, scoped.
3. **Geometric-consistency lemma — WITHDRAWN (witness-refuted 2/2, 2026-06-05).** The original claim
   ("the resolved DNS *exhibits* the CFM/Hou–Li depletion theory needs; theory and our data line up")
   **crossed the firewall** and was refuted by both seats (Grok edge-Φ + Gemini, convergent): (Q1) the
   DNS is regular-by-construction, so the depletion is *forced* — empty agreement, not a test; (Q2)
   `c²_int` and the box-dimension are *proxies* that decouple from CFM's actual object (the smoothness
   of `ξ=ω/|ω|`, `∫|∇ξ|²|ω|`) — alignment can relax while `∇ξ` kinks; (Q3) the conditional-alignment-
   persistence probe is structurally undecidable at reachable N. **Residue (diagnostics, not PDE):** a
   singular scenario, if any, must live at ~zero helicity (NS-040/Kerr) and in `∇ξ` — *invisible* to
   our `c²_int`/`D` diagnostics. See `docs/ns_lowf1_geometric_consistency_verdict.md`. `:proved`=0.
4. **Exact scaling lemmas (NS-034):** the critical/super/sub classification is exact algebra (the
   Prodi–Serrin line, the σ-exponent ladder) — reusable.
5. **Structural-impossibility lemmas (NS-037, scoped EMPIRICAL):** log-normal (K62) forbidden;
   μ∈[0,1]; the touchability ranking (dissipation-rate > exponents > amplitude).
6. **Methodological lemma (NS-039/RWC-038):** a box-dimension "approach to a singular set" is
   untrustworthy unless its N-convergence points the *right* way (D rose 0.986→1.426) — a reusable
   diagnostic standard now codified as TEST_SPEC T-08.
7. **Production identity + the "irreducibly geometric" over-reach — WITHDRAWN (witness-refuted,
   2026-06-05; MID-coordination {NS-005,008,033,034,036}).** *Survives:* the exact identity
   `P = ∫ω·Sω = ∫|ω|²(ξ·Sξ)` — the σ=+1 enstrophy-rung breaker is the enstrophy-weighted strain-
   alignment of the vortex direction ξ; and the tight link `regularity ⟺ enstrophy-bounded ⟸ ∫P dt`
   (last arrow sufficient-only). *Withdrawn:* the synthesis claim that the deficit is "**ENTIRE**ly /
   **irreducibly** geometric (∇ξ)." Refuted convergently by an adversarial seat (Grok) AND an un-led
   naive seat (ChatGPT): (Q1) NS-008 rules out energy-*only* but does not make ∇ξ-control *unique* —
   harmonic-analysis/Besov, dispersive, probabilistic routes are not excluded; (Q2) the identity is
   about *pointwise* alignment ξ·Sξ, not ∇ξ — the leap smuggles CFM *sufficiency* in as *necessity*
   (the §C.3/LOW#1 proxy gap, one level up). *Softened survivor:* ∇ξ-smoothness (CFM/Hou–Li) is the
   **best-supported candidate handle** NS-008 points to, **not** the unique route. See
   `docs/ns_mid_geometric_deficit_verdict.md`. `:proved`=0.

## D. Disposition

Consolidation only; no spec status changes. The structurally-indicated next direction (per both this
synthesis and the TCE) is the **critical-norm path (NS-005)** — the one backward route NS-002 leaves
open. The re-witness of the CFM/Hou–Li geometry has now been **done twice** (LOW #1 §C.3 and the MID
coordination §C.7) — both over-reaches were caught; the honest frontier is the *open* PDE question of
a-priori control of the vortex-stretching production `P`, with ∇ξ-geometry the best candidate handle
but not the proven-unique one. `:proved`=0; distance to the prize UNTOUCHED.
