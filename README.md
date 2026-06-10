# Navier–Stokes Obstruction Program

A **verified, scope-disciplined atlas of what obstructs a proof of 3D incompressible
Navier–Stokes global regularity** — assembled, tier-checked against the primary literature,
stress-tested by attempted disproof, and paired with the negative results and numerical tools
from an extended exploration.

> **Read this first — the firewall.** This repository makes **no progress on the Clay problem**.
> Across the entire ledger, `:proved` = **0**; the distance to the prize is **UNTOUCHED**. What is
> here is a *map of the difficulty* and a *record of what does not work* — offered to make the next
> serious search more efficient, not to claim a result. Every claim carries an explicit evidence
> tier and a scope tag; nothing is dressed up. If you are looking for a proof or a breakthrough, it
> is not here, and the documents say so on every page.

---

## Why this might save you months

If you are starting (or deep into) the regularity problem, most of the up-front cost is not ideas —
it is **assembling the obstruction landscape, verifying that the literature says what people claim
it says, and discovering for yourself which approaches dead-end.** That work is done here, honestly:

1. **A tier-verified obstruction atlas.** The standard no-go results — Escauriaza–Seregin–Šverák /
   Prodi–Serrin, Caffarelli–Kohn–Nirenberg, Nečas–Růžička–Šverák + Tsai, Tao's averaged-NS,
   KNSS / Albritton–Barker — are collected with their **precise scopes, hypotheses, and
   interdependencies**, and assembled into one positive object: *what any finite-time singularity
   must be* (`docs/ns_blowup_generator_class.md` — the `G1–G5` hard / `S1,S2` soft / `W1,W2` witness
   synthesis). The independence relations are made explicit (which "obstructions" are the *same wall*
   in different language — see `SPEC.md` §Independence note), so you don't mistake one barrier for five.

2. **Citations treated as objects to verify, not trust.** Every load-bearing citation carries a
   **C0–C5 reliability tier** (C0 unverified mention → C5 adversarially checked), and the verification
   was actually *done*: primary sources read, proofs line-checked where it matters, and **real errors
   caught** — e.g. a transcription error in a Nečas–Růžička–Šverák H-identity record (errors ours; the
   theorem stands), a hardened reading of a Wang fractional-Hardy endpoint (`α < 1/4`), and a
   systematic record-audit of all transcribed closed-form identities (one error total, fixed). The
   literature does **not** come pre-verified; transcription errors propagate; this repo de-risks that.

3. **Attempted disproof, not just citation.** Cited closed forms and transcribed identities were
   stress-tested with exact-arithmetic (sympy) and numerical checks (`disproof/`, the citation-disproof
   arc) — which both validates the survivors and surfaces the errors. A standing rule: every new
   transcribed identity gets a check at transcription time.

4. **Honest negatives — the part you actually want.** What *doesn't* work is documented as carefully
   as what does: the session-scale attacks on the dynamic frontier that reduce to two un-mechanized
   open cores (`docs/ns048_*`), the conditional anisotropy-depletion criteria whose key assumption a
   resolved DNS drives the *wrong* way (`docs/ns049_*`), and a self-similar-profile reconstruction that
   hit a genuine rigorous-numerics wall through four distinct failure modes (`docs/ns050_*`). Each
   dead-end is mapped so you need not re-walk it.

5. **A scope discipline you can trust.** Every entry is tagged `Scope: PDE` / `model` / `truncation` /
   `phenomenology` / `methodology`; `:proved` is reserved for machine-checked PDE statements and is
   **empty**; within-truncation computations are labeled **witnesses**, never evidence about the PDE;
   and an **over-reach ledger** (`changelog.md`) records every "sharpens"/"proves" claim that was
   *declined*. The point is that you can read an evidence tier and believe it.

6. **Working numerical tools.** A validated pseudospectral 3D DNS chain (Taylor–Green / vortex-tube,
   Brachet-benchmarked), a δ-analyticity-strip diagnostic, phase-coherence / production probes, and a
   **self-similar-variable operator toolkit on ℝ** (a cotangent-map dilation operator and a
   line-Hilbert transform, validated to machine precision — `scripts/ns050_mapped_grid.jl`) that is
   reusable for *any* self-similar / discretely-self-similar / ancient-solution profile analysis.

7. **The hard core, precisely stated.** The two genuinely-open frontiers are written down exactly
   (`docs/ns046_target.md` static / `docs/ns048_exclusion_frontier.md` dynamic) — where the real
   difficulty sits, and what a live attack must engage, rather than where it merely stalls.

---

## How to navigate

Ground-truth hierarchy (see `CLAUDE.md` for the full discipline):

| file | what it is |
|---|---|
| `SPEC.md` | the ledger — every claim with an `NS-###` id, logic tier, evidence type, status, scope, source. **Start here.** (35 entries; the header has a Reading & audit guide + the status-promotion rubric + the independence note.) |
| `artifact_registry.md` | spec → evidence map (every entry → its script / proof / citation) |
| `docs/ns_blowup_generator_class.md` | the MDAGC synthesis: *what a blowup must be* (`G1–G5 ∧ S1,S2 ∧ W1,W2`) |
| `docs/ns046_target.md`, `docs/ns048_exclusion_frontier.md` | the two open frontiers, stated precisely |
| `audit_2026-06-09.md` | the latest A0–A7 cross-audit (the repo audits itself for drift/over-reach) |
| `TEST_SPEC.md` | the check that licenses each computational claim |
| `dashboard.md` | current status + priority stack |
| `scripts/`, `docs/*_companion.md` | the runs and their permanent records |

---

## What this is **not**

- **Not a proof, and not progress on the Clay problem.** `:proved` = 0; distance UNTOUCHED. The
  hard obstructions (`G1–G5`) are *other people's theorems*, credited as such; our additions are the
  verification, the organization, the negatives, and the tools.
- **Not new mathematics in the deep sense** — it is a verified map, a negative-results record, and
  reusable tooling. Several "framings" (the supercriticality / phase-coherence readings, the
  categorical lens) are reorganizations of known facts, labeled as such.
- **Within-truncation results are witnesses, not PDE statements** — a resolved DNS cannot reach the
  singular limit, and every such entry says so (the vacuity cap).

## Provenance & honesty notes

Maintained by **Aaron Green** (independent researcher), with collaborators — the **ORSI / CCATT**
organizing framework and several extension directions are due to a collaborator (B.), and a
conditional-criterion thread engages J. Lockwood's work (assessed honestly and pointedly in
`docs/ns049_lockwood_verification.md`). Developed with **substantial AI assistance (Claude)** under an
explicit anti-over-reach discipline — which is *why* the C0–C5 citation tiers, the `:proved`=0 firewall,
the scope tags, the over-reach ledger, and the self-auditing protocol exist: they are the guard-rails
against an internally-coherent narrative reading as more than it is (the "structured-local-coherence"
hazard, named throughout). Read the evidence tiers, not the prose, and verify anything load-bearing
yourself — the repo is built to make that easy.

*Corrections and independent verification are welcome.*
