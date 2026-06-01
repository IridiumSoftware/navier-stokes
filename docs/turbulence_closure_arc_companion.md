# Companion — the turbulence/closure arc (2026-05-31)

The session that produced NS-020..024 and motivated this repo. Permanent record
per the companion standard. **Every result here is `Scope ≠ PDE`; none is prize
progress.** Migrated from TCE (scripts also committed there @79e5e35).

## §1 — Computational basis

15 Julia scripts (`scripts/`, LinearAlgebra/SparseArrays stdlib; the `closure_*_canon`
/ `q102_richgate` / `knfamily_scaling` ones load closure-v5 canonical data by
absolute path). Each has a paired `.out.txt`. Built/run on Julia 1.12.

- `navier_stokes_homology_diagnostic.jl` — cubical 𝕋³/box boundary operators,
  Betti/Hodge.
- `triad_closure_vs_cascade.jl` — Waleffe-1992 reduced helical triad (3 ODEs).
- `mfe_*` (5) — Moehlis–Faisst–Eckhardt 9-mode model (eqs transcribed from the
  paper, p.7), lifetime statistics, B-universality, committor decomposition.
- `closure_autopoiesis_{small,structured,canon}.jl`, `closure_knfamily_scaling.jl`,
  `closure_{mr_gate,q102_richgate,triad_rotation,offgas}.jl` — stochastic CTMC +
  exact 8-state committor for the autopoietic-closure / (M,R) results.

## §2 — Results (precise, scoped)

1. **Homology reformulation FALSIFIED** (NS-020). On fixed domains `b₁` is pinned
   under refinement (𝕋³→3, ℝ³→0); grows only under topology change; the difficulty
   is the **norm** (supercriticality, NS-002), invisible to topology. Repair-cost =
   1/vorticity exactly. *Scope: discrete-topology diagnostic.*
2. **MFE saddle phenomenology** (NS-021). Self-sustaining metastable state;
   **memoryless** exponential lifetimes (survival R²=0.99, CV≈1); `τ(Re)~exp(B·Re)`,
   B≈0.013–0.015 (amplitude-invariant, geometry-dependent, ~tracks spanwise γ);
   recovery **gated by the roll mode a₃** (committor 5.9× at dip-bottom). Escape
   factorizes κ=Φ·q; the Φ/q split is interface-dependent. *Scope: ODE-truncation
   — a 9-variable ODE is smooth ∀t; NO PDE bearing.*
3. **Helical triad** (NS-022). E & H conserved to ~1e-13; intermediate-signed leg =
   unstable donor; isolated triad merely **oscillates** ⇒ cascade direction is a
   driven-ensemble property, not the triad algebra. *Scope: 3-ODE model.*
4. **Autopoietic closure + (M,R) gate** (NS-023). Decay-default + autocatalytic
   closure reproduces metastable+memoryless+`τ(ρ)~exp(N·g(ρ))` *intrinsically*.
   Generic structured complexes: structure predicts gating (degree/Fiedler +0.79)
   and robustness (λ₂ +0.81). Canonical CFS Q₁₀₂: **no localized gate** even with
   real weights/roles (delocalized — too symmetric). Exact (M,R) 8-state CTMC:
   **gate = target of the weak edge, rotation-covariant** (committor triple
   identical, cyclically permuted; symmetric null control → no gate). The seam is
   **lifeline ∧ death-route**; tightness trades lifespan vs identity. *Scope:
   abstract closure theory — a SEPARATE domain, not NS.*
5. **Closure↔turbulence convergence, witnessed** (NS-024). 3-seat pass
   (Grok/Gemini/ChatGPT): C1 (closed=inert/open=needs-degeneracy-breaker) holds but
   **broad**; C2 "Order=seam" identity **dead** (doubly dissociable); C3 origin-
   unification **refuted**. "Is the seam's incompleteness one notion or two?" → **two**
   (logical/selectional ≠ dynamical/stochastic). *Scope: analogy; no PDE purchase.*

## §3 — Verification

See `TEST_SPEC.md`. Strongest checks: NS-022 exact invariants (E,H ~1e-13);
NS-023 exact committor + pre-registered prediction + null control + bit-identical
RHS cross-check (max|Δ|=0); NS-021 two τ-estimators agree ~5% + memoryless R²=0.99;
NS-020 closed-form Betti/Hodge; NS-024 three independent witness seats.

## §4 — Spec impact

Produced spec entries NS-020..024 (all `Scope ≠ PDE`) and motivated the repo's
PROBLEM/OBSTRUCTION/DIAGNOSTIC ledger (NS-001..013) by clarifying, negatively,
where the difficulty is NOT (topology) and where the live analytic handle IS (the
complex plane, NS-010/011). Net contribution to the prize: **zero**; contribution
to the *map*: a falsified path, a clean re-diagnosis, and a calibration of how
little an unwitnessed analogy is worth here.
