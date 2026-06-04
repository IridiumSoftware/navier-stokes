# CLAUDE.md — Navier–Stokes Obstruction Program

## Project identity

A **rigorous obstruction program** for the 3D incompressible Navier–Stokes
global-regularity problem (Clay Millennium Prize). The goal of *this repo* is
**not** to claim a solution. It is to maintain an honest, evidence-tiered ledger
of:

1. the **problem** stated precisely,
2. the **obstructions** — the theorems and scaling facts any proof must respect,
   and that kill naive approaches (the walls),
3. the **diagnostics** — computable quantities that detect approach to blowup,
4. the **falsified** approaches (classical and our own),
5. the **live** approaches and conjectures,
6. our own **computational results**, each carried at its true evidence tier and
   with an explicit **SCOPE** declaration (model? truncation? the PDE?).

**Status (2026-06-04, v0.1.42).** Honest baseline: **zero progress on the prize.**
The PDE regularity question is untouched (`:proved`=0); 30 ledger entries, all scoped.
What exists is (a) a catalogue of the standard obstructions; (b) one falsified approach
of our own (homology, NS-020); (c) a body of turbulence/closure *phenomenology* plus a
possibilistic / inverse-Born map of turbulence's constants (NS-037) — finite truncations +
empirical structure, none bearing on PDE regularity; (d) the **complex-plane** analyticity-
strip diagnostic (NS-010), validated on Burgers/CLM/2D/3D and applied to the gated Step-2
blowup hunt (NS-032) — INCONCLUSIVE at N=256↔512 (the gate correctly refuses a
resolution-artifact δ→0); and (e) a **resolved-DNS** track at N=256 (boundary program
A→B→C, NS-038) extended to **N=512 on the Metal/GPU spectral solver** — the RWC-038
reconnection verdict (NS-039: the ≤1 box-dimension touch is a resolution artifact) and the
clean helicity-depletion result (NS-040). Every `:tested` is model/truncation-scoped; none
is a PDE result. See `dashboard.md`.

**Owner:** Aaron Green.

## The firewall (THE core discipline of this repo)

This problem punishes wishful thinking. The single most important rule:

> **Never conflate a result about a model, a truncation, or an analogy with a
> statement about the Navier–Stokes PDE.** Every spec entry and companion result
> carries a `Scope:` line stating exactly what object it concerns
> (`PDE` / `ODE-truncation` / `1D-model` / `abstract-closure` / `phenomenology` /
> `external-theorem`). A claim with `Scope ≠ PDE` can **never** be cited as
> progress on the prize.

Corollaries:
- No "we're close." Distance to the prize is measured only by rigorous PDE
  results, of which we have none.
- Elegant cross-domain convergences are **guilty until externally witnessed**
  (see the closure↔turbulence pass, NS-024 — trimmed to "broad/generic").
- A falsified approach is a *result* (it removes a path) and is recorded as
  `:falsified`, not hidden.

## Ground-truth hierarchy

1. **`SPEC.md`** — the obstruction ledger. Every named claim (a problem, an
   obstruction, a diagnostic, a falsified approach, a result, a conjecture) gets
   an `NS-ID`, a **Class**, an **evidence type**, a **status**, a **Scope**, and
   a citation/source. If it is not in the spec, it is not established.
2. **`artifact_registry.md`** — maps every spec entry to its evidence: a script
   we ran, or a literature citation. No row → no traceable evidence.
3. **`DESIGN.md`** — the strategic narrative: the obstruction-program method, the
   live attack (complex plane), and the cross-project framing.
4. **`TEST_SPEC.md`** — the verification discipline for our *computational*
   claims: what each diagnostic must reproduce (known closed forms, exact
   limits) to be trusted.
5. **`dashboard.md`** — current status + priority stack. No scorecard copy.
6. **`docs/*_companion.md`** — permanent record of each substantive session.
7. Source (`scripts/`) and everything else — supporting.

Plus **`physical_invariants.md`** — the tiered invariant constraint set (Tier 1
hard / Tier 2 phenomenology / Tier 3 established), the same stratified-constraint
discipline as the closure-v5 and possibilistic-inversion invariant files. It feeds
the obstruction entries (NS-002/003/004) and enforces, in invariant terms, the
Scope firewall: only Tier-1 invariants may be used as hard constraints; Tier-2
phenomenology (K41 etc.) may not.

## Evidence types & status (adapted for a math obstruction program)

| Evidence type | Meaning | Status it supports |
|---|---|---|
| **external-theorem** | a published, established theorem we cite (not ours) | `:cited` |
| **computed** | we ran a computation (script in `scripts/`) | `:tested` (+ Scope) |
| **argued** | a manual mathematical argument / diagnosis | `:argued` |
| **falsified** | an approach ruled out (by us or the literature) | `:falsified` |
| **none** | an open question, no resolution | `:open` |
| **proved** | a *rigorous proof we produced* | `:proved` — **none yet; reserved** |

**Rule.** `:proved` requires a rigorous proof of a PDE statement and is currently
empty by design. `computed` results are `:tested` and MUST carry a `Scope` that
is not `PDE` unless they are a verified PDE statement (none are).

## Classes (the obstruction-program skeleton)

- **PROBLEM** — the prize question and its precise sub-questions.
- **OBSTRUCTION** — a wall: a theorem/scaling fact a proof must respect, or that
  kills an approach.
- **DIAGNOSTIC** — a computable detector of blowup (analyticity strip, spectrum).
- **FALSIFIED** — a ruled-out approach.
- **RESULT** — our own computed finding (always with Scope).
- **CONJECTURE** — an open conjecture worth tracking.
- **RELATED** — external work bearing on a program entry (cited, with Scope).
- **PROGRAM** — meta-entries about method and cross-project use.

## Language tooling & package discipline

Julia (LinearAlgebra/SparseArrays stdlib; FFTW when spectral methods enter — pin
in `Project.toml`/`Manifest.toml`) for exact and numerical diagnostics; Python
(`uv` + `uv.lock`) for exploration. The arithmetic type and verification
mechanism set the evidence class, not the language: a `Float64` spectral
computation is `computed`/`:tested`, never a proof. Never commit a lockfile-less
ecosystem; `latest` is forbidden.

## Cross-project framing (why this matters beyond NS)

This is a **hard-problem testbed**. Two things transfer to the other open
research programs (CFS, closure-quotient, possibilistic-inversion):
1. **The method** — evidence-tiered obstruction ledger + firewall + external
   witnessing. This is the contribution that is *certain* to transfer.
2. **Substantive findings** — transfer **only** when witnessed and scoped. The
   closure↔turbulence link (NS-024) was witness-trimmed to a *broad, generic*
   structural kinship with **no analytic purchase on the PDE**; it is recorded as
   such and is NOT a bridge to import elsewhere without its caveats.

## Workflow rules

- **The spec is ground truth.** Conflicts resolve toward the spec.
- **Honest framing.** "Diagnostic in a 1D model" beats "evidence of blowup."
  "Falsified" beats quietly dropping a dead idea.
- **Every result gets a Scope line.** No exceptions.
- **Witness elegant convergences** before promoting them.
- **Test before committing**; a commit's computations must run and reproduce
  their stated checks (see `TEST_SPEC.md`).

## What not to do

- Don't call anything progress on the prize unless it is a rigorous PDE result
  (`:proved`). There are none.
- Don't conflate a truncation/model/analogy with the PDE (the firewall).
- Don't import the closure↔NS link as more than "broad/generic, witnessed."
- Don't add a spec entry without a registry row and a Scope.
