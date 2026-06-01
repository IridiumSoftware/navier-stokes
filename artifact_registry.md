# artifact_registry.md — spec → evidence map

Every `SPEC.md` entry maps here to its evidence: an in-repo script (`computed`) or
a literature citation (`external-theorem`). No row → no traceable evidence.
Columns: `NS-ID | Class | Evidence type | Status | Scope | Artifact / Citation`.

| NS-ID | Class | Evidence | Status | Scope | Artifact / Citation |
|---|---|---|---|---|---|
| NS-001 | PROBLEM | external-theorem | :open | PDE | Fefferman, Clay problem statement (2000/2006) |
| NS-002 | OBSTRUCTION | argued | :argued | PDE | standard criticality scaling (Tao expositions) |
| NS-003 | OBSTRUCTION | external-theorem | :cited | PDE | Leray (1934); Hopf (1951) |
| NS-004 | OBSTRUCTION | external-theorem | :cited | PDE | Beale–Kato–Majda (1984) |
| NS-005 | OBSTRUCTION | external-theorem | :cited | PDE | Prodi (1959); Serrin (1962); Escauriaza–Seregin–Šverák (2003) |
| NS-006 | OBSTRUCTION | external-theorem | :cited | PDE | Caffarelli–Kohn–Nirenberg (1982) |
| NS-007 | OBSTRUCTION | external-theorem | :cited | PDE | Nečas–Růžička–Šverák (1996); Tsai (1998) |
| NS-008 | OBSTRUCTION | external-theorem | :cited | PDE | Tao (2016), JAMS — averaged-NS blowup |
| NS-009 | OBSTRUCTION | external-theorem | :cited | PDE/Euler | Constantin–E–Titi (1994); Isett (2018); BDLSV (2019); Onsager (1949) |
| NS-010 | DIAGNOSTIC | external-theorem + computed | :tested | PDE-method (validated in 1D + 2D + 3D-viscous-control models; δ-fit NOT resolution-robust for inviscid/under-resolved 3D — documented) | FT(1989); SSF(1983); `burgers_analyticity_strip.jl` (T-01) + `spectral_clm_blowup.jl` (1b: T-03/T-04) + `spectral_2d_control.jl` (1c-2D: T-05) + `spectral_3d_control.jl` (1c-3D: T-06/T-07 — 3D solver E+H validated, viscous-control regular, inviscid δ-fit caveat); companions ns010_*_companion.md |
| NS-011 | DIAGNOSTIC | external-theorem + computed | :tested | PDE-method (validated in 1D-models) | SSF(1983); Matsumoto–Bec–Frisch; `burgers_analyticity_strip.jl` (T-02 inviscid) + `spectral_clm_blowup.jl` (CLM simple-pole δ=ln(2/t)) |
| NS-012 | RESULT (live) | external-theorem | :cited | PDE (complex data) | Li & Sinai (2008), JEMS |
| NS-013 | CONJECTURE | none | :open | PDE | — (real ⇐ complex implication open) |
| NS-020 | FALSIFIED | computed | :falsified | discrete-topology | `scripts/navier_stokes_homology_diagnostic.jl` (+.out.txt) |
| NS-021 | RESULT | computed | :tested | ODE-truncation / phenomenology | `scripts/mfe_self_sustaining.jl`, `mfe_lifetime_scaling.jl`, `mfe_B_universality.jl`, `mfe_escape_mechanism.jl`, `mfe_committor_decomposition.jl` |
| NS-022 | RESULT | computed | :tested | 3-ODE model | `scripts/triad_closure_vs_cascade.jl` |
| NS-023 | RESULT | computed | :tested | abstract closure (separate domain) | `scripts/closure_autopoiesis_{small,structured,canon}.jl`, `closure_{knfamily_scaling,mr_gate,q102_richgate,triad_rotation,offgas}.jl` |
| NS-024 | RESULT | argued (witnessed) | :argued | analogy (no PDE purchase) | `docs/seam_order_convergence_witness_{brief,verdict}.md` |
| NS-025 | RELATED | external-theorem | :cited | software-ecosystems / phenomenology (NOT PDE) | Gosme, arXiv:2512.09352 (2025) — causal-symmetrization signature of operational closure; bears on NS-023/024 |
| NS-030 | PROGRAM | argued | :argued | methodology | this repo's discipline; DESIGN §5 |
| NS-031 | PROGRAM | computed | :tested | methodology (program self-map, NOT PDE) | `discovery/ns_obstruction_corpus.json` + `discovery/ns_triad_discovery.out.txt`; companion `docs/ns_triad_discovery_companion.md`; engine = TCE `Discovery.Triadic` via `SpecBridge` |

**Coverage:** every NS-ID has a row. **No orphans:** every in-repo artifact named
above exists under `scripts/` or `docs/`. **Status honesty:** no `:proved`; all
`computed` rows carry a non-PDE Scope; the only `Scope: PDE` rows are
external-theorem citations and the open problem itself.

**Promotion rules.**
- A `computed` row can rise only within its Scope (e.g. NS-010 `:argued → :tested`
  once the Burgers/spectral diagnostic runs and passes TEST_SPEC). It does **not**
  thereby become a PDE statement.
- `:cited` rows are fixed by the literature; we do not "upgrade" others' theorems.
- `:proved` (Scope: PDE) is reserved for a rigorous proof we produce. Empty.
