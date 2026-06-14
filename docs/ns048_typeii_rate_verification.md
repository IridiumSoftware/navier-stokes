# NS-048 Type-II rate-bound verification — re-confirmation + citation-index reconciliation

**Date:** 2026-06-13. **Status: a verification + reconciliation pass (no new claim). Scope:
PDE-analysis (≠ the PDE).** `:proved`=0; distance UNTOUCHED. Deepens the Type-II rate-bound edge
(NS-048 core (c)). **Honest finding up front:** the C3 line-reads already existed
(`docs/ns048_type_ii_frontier.md` §2, 2026-06-07, triad-refined); this pass independently
**re-confirmed the two headline statements verbatim against arXiv** and **fixed citation-index drift**
(`citation_tiers.md` was stale/inconsistent and missing two papers). The deepening was therefore
mostly a soundness-check + sync, not new reads — recorded as such.

## 1. Primary-source re-confirmation (2026-06-13, arXiv abstracts)

| Paper | Statement re-confirmed | Match vs the C3 record |
|---|---|---|
| **Tao 1908.04958** (*Quantitative bounds for critically bounded solutions to NS*) | verbatim: *"the critical `L³_x` norm must blow up at a rate `(log log log 1/(T*−t))^c` or faster for an infinite sequence of times approaching `T*`"* — **triple-log lower bound, along a sequence** | ✓ exact |
| **Palasek 2101.08586** (axisym) | weighted critical norm `‖r^{1−3/q}u‖_{L_t^∞ L_x^q}`, **axisym `q∈(2,3]`**, *"a double logarithmic lower bound on the blowup rate"*, via *"the strategy of Tao (2019)"* with bounds depending on a *"double exponential of the critical norm"* | ✓ exact |

**Honesty catch (Palasek).** The abstract makes **no explicit "improves Tao" claim**. Our
characterization "double-log improves triple-log" is a *correct rate-inference* (`loglog ≻ logloglog`
asymptotically ⇒ a `loglog` lower bound is the stronger statement) **but in a different functional
setting** — Palasek's is a *weighted* `‖r^{1−3/q}u‖_{L^q}` axisym norm, Tao's is plain `L³`. Not
strictly apples-to-apples. (The plain-critical axisym double-log is the *separate* result
Ożański–Palasek 2210.10030.) The citation index now states this explicitly.

## 2. The finding — the deepening already existed; the index had drifted

`docs/ns048_type_ii_frontier.md` §2 already holds the full Type-II rate table at **C3** (primary
line-reads, triad-refined `c5_triad_witness_verdict.md`): Tao 1908.04958 (triple-log) · Ożański–Palasek
2210.10030 (axisym weak-`L³` double-log, best plain-critical) · Palasek 2101.08586 (weighted double-log)
· Palasek 2111.08991 (`d≥4` quadruple-log). The NS-050 prior-art round (2026-06-11) independently
re-confirmed Tao+Palasek ("✓ exactly as recorded").

But `citation_tiers.md` — the index — had **drifted out of sync** (a close-out-item-(vi) lapse):
- the NS-048-section row was stale at **"C1/C2 partial"** (vs the §2 C3);
- the NS-050-section rows were understated at **C2**;
- **two papers were missing** from the index entirely (Ożański–Palasek 2210.10030; Palasek 2111.08991);
- the gloss read *"the gap-to-full-exclusion is qualitative"* — **mischaracterized** (see §3).

## 3. The sharpened gap-to-exclusion (the real deliverable)

The old one-word gloss "the gap is qualitative" was *underspecified*, not simply wrong — the frontier
doc uses "qualitative" and "quantitative" for **two different aspects**, and the precise statement
honors both (conflating them is the trap):

> **The gap has two faces, both true.** Each result proves a blow-up-rate **lower** bound — *if* a
> singularity exists, the (weighted/plain) critical norm must diverge at least at rate `R(t)`, with `R`
> in the slow `loglog`/`logloglog`/`loglogloglog` class.
> - *(frontier §4 — the NATURE of the Type-I/II line):* exclusion proves `rate ≥`, a construction
>   would show `rate =`, so Type-II is **a quantitative race**, not a clean qualitative Type-I/II
>   *dichotomy* — the rate is the single shared object.
> - *(frontier §2 — the SIZE of the gap):* closing the race demands a **qualitative leap in growth
>   class** — from "diverges like iterated-log" to "must diverge faster than the equation's own
>   `∼(T−t)^{−1/2}` scaling" — *not* a constant/factor improvement. The iterated logs are so slow that
>   even numerically probing them exceeds computing capacity.
>
> Net: a *quantitative* race whose closing needs a *qualitative* leap in the lower bound's growth
> class — and no method makes the leap.

**Connection to the σ=0 / Carleman-ladder tracking (`ns048_sigma0_decay_carleman_tracking.md`).**
Tao 1908.04958 is *both* the triple-log paper *and* exactly what the Carleman ladder (NS-051) is
formalizing. This sharpens the ladder firewall a second way: even completed, the ladder would
machine-verify the **triple-log rate bound's Carleman engine** — but the triple-log is itself only a
*partial* Type-II exclusion (`rate ≥`), not exclusion. So "ladder completion ⇏ NS-048 closure" holds
here too: the very theorem the ladder targets is a rate bound, not a closure.

## 4. Reconciliation done

- `citation_tiers.md`: the NS-048 row rebuilt as the **authoritative consolidated Type-II-rate row**
  at **C3** (all four papers + the quantitative-gap gloss + the weighted-norm caveat); the
  NS-050-section Tao/Palasek rows lifted **C2→C3** with the honesty catch + a cross-reference to the
  consolidated row. The two missing papers folded into the consolidated row.
- `docs/ns048_type_ii_frontier.md` §2: a one-line note that the headline statements were re-confirmed
  vs arXiv 2026-06-13 and the index reconciled.

`:proved`=0. Distance UNTOUCHED — this verified and re-confirmed other people's rate theorems and
fixed our index; the open core (Type-II exclusion = the quantitative race) is unchanged.
