# changelog — Navier–Stokes obstruction program

## v0.1.1 — 2026-05-31 — Physical invariants reference

Added `physical_invariants.md` — the tiered invariant constraint set for NS, in
the lineage of the closure-v5 `physical_invariants.md` and the possibilistic-
inversion `geophysical_invariants.md`. Tier 1 (frame-independent / hard:
incompressibility, energy inequality, momentum, scaling symmetry→supercriticality,
Galilean/rotation symmetries, helicity & circulation [Euler-exact / NS-decaying],
enstrophy [2D-coercive / 3D-battleground], BKM); Tier 2 (frame-dependent
phenomenology: K41 −5/3, increment 1/3, anomalous dissipation, intermittency, Re
thresholds, blowup scenarios — soft only, anchoring anti-pattern if hard); Tier 3
(established theorems = the fixed end). **Load-bearing reading recorded: the 2D/3D
regularity gap IS an invariant-tier story — enstrophy is Tier-1 coercive in 2D, the
battleground in 3D, leaving only the supercritical energy as Tier-1 control.** The
tier-confusion anti-pattern is the Scope firewall in invariant terms. Wired into
`CLAUDE.md` ground-truth hierarchy and cross-referenced to `SPEC.md` NS-IDs.

## v0.1.0 — 2026-05-31 — Repository established

**Founding commit.** Set up the obstruction-program scaffold for the 3D
incompressible Navier–Stokes global-regularity (Clay) problem, in the TCE
ground-truth-hierarchy style, adapted for a mathematics obstruction program.

- **Business files:** `CLAUDE.md` (constitution + the Scope firewall),
  `SPEC.md` (the obstruction ledger, 18 entries), `DESIGN.md` (strategy +
  the complex-plane live attack + cross-project framing), `dashboard.md`,
  `artifact_registry.md`, `TEST_SPEC.md`.
- **Spec populated from what we know:** problem statement (NS-001);
  obstructions NS-002..009 (supercriticality, Leray energy-only control, BKM,
  Prodi–Serrin–ESS, CKN partial regularity, no-self-similar-blowup, Tao
  averaged-blowup no-go, Onsager 1/3); diagnostics NS-010/011 (analyticity
  strip, complex-singularity tracking); live NS-012/013 (Li–Sinai complex-data
  blowup; real⇐complex open).
- **Prior arc migrated** (copied from TCE; TCE copies remain @79e5e35):
  15 scripts + 2 witness docs. Recorded honestly as NS-020 (homology
  reformulation **:falsified**), NS-021 (MFE saddle phenomenology, Scope:
  ODE-truncation), NS-022 (helical triad, Scope: model), NS-023 (autopoietic
  closure / (M,R) rotation-covariant gate, Scope: abstract closure — a separate
  domain), NS-024 (closure↔turbulence convergence, witness-trimmed to
  broad/generic, Scope: analogy).
- **Honest baseline recorded:** zero progress on the prize; `:proved` count = 0
  by design; distance-to-prize = UNTOUCHED.

**Next:** the complex-plane diagnostic (NS-010/011) — Burgers exact poles, then a
spectral truncation watching the analyticity-strip width δ(t). First in-repo
direction with `Scope: PDE-method`; still a diagnostic in models, not a proof.
