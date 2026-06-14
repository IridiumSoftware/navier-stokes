# Go-Map cross-repo verification — round 3 (GO-018..021, the ancient-Liouville / Type-II wave)

**Date:** 2026-06-14. **Status: verify-and-port (A7). Scope: 1D-model witness + literature crosswalk
(≠ PDE).** `:proved`=0; distance UNTOUCHED. Extends NS-052 (rounds 1–2: `gomap_verification_2026-06-12.md`,
`gomap_verification_round2_2026-06-12.md`). **Pin: `grok-test@8e0e066`** (GO-018..021 added in ancestor
`385c9be`; tree clean at HEAD). Method: all 7 Python probes re-run on this machine; `.out.txt` overwritten
in place; `git diff` vs the pin grades reproduction. **No Lean in this wave (all stdlib Python) ⇒ the
`.lake` hazard does not apply here.**

## Results — ALL 7 BYTE-IDENTICAL

| Probe | GO | Verdict (exit) | Reproduction |
|---|---|---|---|
| `go018_seregin_scenario_map.py` | GO-018 | LIVE (0/5 scenarios need a falsified witness) | **byte-identical** |
| `go019_no_split_bubbling.py` | GO-019 | TESTED — Φ wins under profile-distance; L²/Besov favor superpositions | **byte-identical** |
| `go019_m5_bubble_quant.py` | GO-019 | LIVE — dist(Φ) selector stable; M5 open | **byte-identical** |
| `go019_m5_compactness_scaling.py` | GO-019 | FALSIFIED (exit 1) — no-split gap *closes* as λ→0 | **byte-identical** |
| `go020_palasek_besov_rate.py` | GO-020 | TESTED — double-log→Besov rate panel; gap documented | **byte-identical** |
| `go021_axisym_swirl_ancient_euler.py` | GO-021 | LIVE — nontrivial swirl ansätze survive the finite-energy proxy | **byte-identical** |
| `go021_seregin_bounds_swirl.py` | GO-021 | LIVE — swirl ansatz meets (3.7)+(3.10) *proxy* in the m-band | **byte-identical** |

Exit codes are deliberate verdicts (`SystemExit(0 if live else 1)`); the GO-019 exit-1 is the kill-met
signal, not a run failure. `git diff` empty against the pin = deterministic stdlib reproducing exactly.

## Per-GO digest (with honest scoping)

- **GO-018 — Seregin conditional Type-II scenario × falsified-witness crosswalk (LIVE).** 0/5 Seregin
  scenarios (S2-A..S5-D, S0) require any GO-falsified DNS witness (δ_Λ→0 VACUOUS, CKN≤1 WRONG-WAY,
  swirl-sign FALSIFIED). The witness column cites **in-repo established findings** (NS-039 D30-lift,
  NS-049/GO-008 δ_Λ floor, GO-005 swirl-sign) — so the matrix is *consistent with the repo*. The Seregin
  scenario structure + theorem/eq numbers (Thm 2.1, 3.1, eqs 1.2/1.4) are **Grok's reading of 2507.08733**
  — repo Seregin is at **C2 statement-level only**; the specific numbers are not line-verified here.
- **GO-019 — M5 no-split minimal datum (two-sided, OPEN).** Honest combined read across the 3 probes:
  at **fixed scale**, the profile-distance selector picks the canonical CLM Φ at k=1 (no-split survives),
  but the **L²/Besov** minimal datum favors richer k>1 superpositions (selector mismatch); under
  **singular λ→0 blowup-clock scaling** the no-split gap *closes* (`m5_compactness_scaling` FALSIFIED).
  Net: the witness **positions M5 as open** — it is *not* a PDE no-split theorem, and the fixed-scale
  "selector survives" must not be read in isolation from the singular-scale "gap washes."
- **GO-020 — Palasek double-log → Besov rate panel (TESTED, gap-documenting).** The double-log L³
  template has sub-polynomial (log-log) slope; the Besov proxy inherits the exponent ratio q/3=2. The
  panel **documents the gap** — the target (Ožański–Palasek **2210.10030 Cor 1.2**: a *single*-log Besov
  rate, one log weaker than the L³ double-log) is **not witnessed** here; full proof is research-scale.
  Ties directly to the 2026-06-13 Type-II rate verification (`ns048_typeii_rate_verification.md`).
- **GO-021 — ancient-Euler Liouville port (LIVE, positioning).** Maps the Seregin 2507.08733 pipeline
  (Type-II weak blowup → moment bounds → Euler scaling → ancient Euler → ancient-Euler Liouville) and a
  Liouville port table (m<½ closed; irrotational closed; self-similar closed for ½<m<⅗; axisym-zero-swirl
  closed; **axisym+radial-decay conditional**; DSS/general-3D OPEN). The two probes show swirl ansätze can
  meet the (3.7)/(3.10) weighted-bound *proxies* in the m-band, narrowing the Prop-4.2 ω_θ route — but
  honestly scoped: **NOT claimed** (suitable weak solution / actual ancient-Euler solution); and **[9]'s
  zero-swirl ancient-Euler limit still blocks the literal swirl construction**. The live theorem gap for
  Clay-direction Type-II exclusion = **general ancient-Euler Liouville**, not any DNS witness.

## Catches / flags (flow back to grok-test)

1. **Attribution (GO-020):** `2210.10030` is **Ožański–Palasek**, not "Palasek" (the probe labels it
   "Palasek conjecture (2210.10030)"). Same precision class as the round-1/2 HQWW catch. Corrected in our
   `citation_tiers.md`.
2. **Tier honesty (GO-018/021):** the Seregin 2507.08733 specific theorem/eq numbers are **Grok's read**,
   not repo-line-verified (repo Seregin = C2 statement-level). The scenario map + port table are ported as
   **positioning at the tier they earn (C1/named, reproduction byte-identical)**, with a flag that a
   Seregin 2507.08733 line-read is required before leaning on the specific numbers. Do **not** over-cite.

## Cross-confirmations gained for in-repo work

- **GO-020 ↔ Type-II rates:** independently reproduces the Palasek/Ožański–Palasek double-log rate
  structure and points at the single-log-Besov target (2210.10030 Cor 1.2) — a useful refinement for the
  consolidated Type-II-rate row.
- **GO-018/021 ↔ NS-048 Hole-B / NS-050:** the ancient-Euler Liouville positioning corroborates the repo's
  C2 Seregin reading (`ns048_type_ii_frontier.md` §2, `citation_tiers.md`), adding a finer scenario ×
  witness matrix + Liouville port table.
- **GO-019 ↔ NS-048 M5 (no-split):** positions Hole-M5 as open with a concrete fixed-vs-singular-scale
  witness — consistent with the litmap's "no-split honest hold."

## Firewall

Witness/positioning tier throughout; the Seregin theorem-numbers stay Grok-read (C1/named) pending a
2507.08733 line-read; the only quantitative claims are 1D-model proxies, explicitly "NOT claimed" as
ancient-Euler solutions. `:proved`=0; distance UNTOUCHED. **substrate_source: grok-test@8e0e066.**
