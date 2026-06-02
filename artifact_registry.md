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
| NS-013 | CONJECTURE | none | :open | PDE | — (real ⇐ complex implication open). Probe: `scripts/complex_burgers_reality_leakage.jl` (1D reality-stabilizer, Move 4 — reality protects, boundary λ_c∈(0.02,0.05); illustrative only, :open unchanged) |
| NS-020 | FALSIFIED | computed | :falsified | discrete-topology | `scripts/navier_stokes_homology_diagnostic.jl` (+.out.txt) |
| NS-021 | RESULT | computed | :tested | ODE-truncation / phenomenology | `scripts/mfe_self_sustaining.jl`, `mfe_lifetime_scaling.jl`, `mfe_B_universality.jl`, `mfe_escape_mechanism.jl`, `mfe_committor_decomposition.jl` |
| NS-022 | RESULT | computed | :tested | 3-ODE model | `scripts/triad_closure_vs_cascade.jl` |
| NS-023 | RESULT | computed | :tested | abstract closure (separate domain) | `scripts/closure_autopoiesis_{small,structured,canon}.jl`, `closure_{knfamily_scaling,mr_gate,q102_richgate,triad_rotation,offgas}.jl` |
| NS-024 | RESULT | argued (witnessed) | :argued | analogy (no PDE purchase) | `docs/seam_order_convergence_witness_{brief,verdict}.md` |
| NS-025 | RELATED | external-theorem | :cited | software-ecosystems / phenomenology (NOT PDE) | Gosme, arXiv:2512.09352 (2025) — causal-symmetrization signature of operational closure; bears on NS-023/024. **Queued MFE test DONE → NEGATIVE:** `scripts/mfe_gosme_symmetrization.jl` (+.out.txt) — Granger symmetrization NOT reproduced in the MFE saddle (proxies disagree, near noise floor at high Re); Scope ODE-truncation |
| NS-030 | PROGRAM | argued | :argued | methodology | this repo's discipline; DESIGN §5 |
| NS-031 | PROGRAM | computed | :tested | methodology (program self-map, NOT PDE) | `discovery/ns_obstruction_corpus.json` + `discovery/ns_triad_discovery.out.txt`; companion `docs/ns_triad_discovery_companion.md`; engine = TCE `Discovery.Triadic` via `SpecBridge` |
| NS-032 | RESULT (null) | computed | :tested | inviscid-3D-truncation (NOT PDE) | `scripts/spectral_3d_blowup_candidate.jl` (+.out.txt) — gated blowup hunt, INCONCLUSIVE (G2/G3 fail; gates flag resolution limit, no false positive). **High-res N=128 confirmation:** `scripts/blowup_highres.jl` (+.out.txt) — wall moves with N (t_res 3.0/4.26/≥5.0), δ drifts down (not converged), still INCONCLUSIVE |
| NS-033 | GEOMETRY | computed | :tested | geometry of 2D & 3D ideal flow / finite truncations (NOT 3D-NS PDE) | `scripts/manifold_{1,2,3,4,5,6}_*.jl` (+.out.txt); companion `docs/manifold_study_companion.md`; Slice-4 κ≡¼ verified; Slice-5 SDiff(T²) k∥l⇒0+symmetry, census 84%neg/9%pos (Arnold+Misiołek); Slice-6 CASIMIR DEFICIT (2D ∫f(ω) conserved / 3D helicity conserved but enstrophy ×6) |
| NS-034 | ANALYSIS | algebraic + computed | :argued | PDE (criticality framing of NS-002↔NS-005; NOT a proof) | `scripts/manifold_3b_criticality.jl` (+.out.txt) — exact σ_X calculus; σ(Ḣ^s)=s−½ verified continuous-λ; PS locus 2/p+3/q=1 ⟺ σ=0 |
| NS-035 | RELATED | external-theorem | :cited | conceptual lens / methodology (NOT PDE) | Ryan, arXiv:nlin/0609011 (2006) — emergence coupled to SCOPE not resolution; gives the PRINCIPLE behind the σ=0 diagnostic (resolution=Class-I epistemic, scope=Class-II ontological), re-reads NS-002/006/034, new criterion + M\*↔CKN handle; companion `docs/ryan_scope_resolution_lens.md` |
| NS-036 | ANALYSIS | algebraic + computed | :argued | NS scaling + elementary interpolation + ideal-flow Casimirs (sharpens the wall, NOT a proof) | `scripts/criticality_casimir_hinge.jl` (+.out.txt) — interpolation `‖u‖²_{Ḣ^{1/2}}≤‖u‖_{L²}·‖u‖_{Ḣ¹}` verified (ratio≤0.87 generic, =1.000 iff scale-pure); companion `docs/criticality_casimir_hinge_companion.md`; write-up §5. (a)NS-034≡(b)NS-033-Slice6 joined at enstrophy (ladder −1/0/+1 symmetric about σ=0; one rung = the Casimir question); (c) curvature INDEPENDENT (SDiff(𝕋²)=2D regular). Test covers the interpolation sub-claim; entry-level equivalence stays :argued (conjunctive rule) |

| NS-037 | POSSIBILISTIC | algebraic + computed | :argued | EMPIRICAL phenomenology + exact 4/5 + realizability (prize-focus dropped; NOT PDE) | `scripts/turbulence_nogo_map.jl` + `turbulence_inverse_born.jl` + `mu_hard_bound.jl` (+.out.txt); companions `docs/turbulence_nogo_map_companion.md` + `turbulence_inverse_born_companion.md` + `mu_hard_bound_companion.md`. Inverse-Born = inverse Legendre of the multifractal formalism (ζ_p↔D(h)); attractor runs to the CKN wall; log-normal cascade FORBIDDEN (realizability null); μ∈[0,1] tight but no tighter (frame-dependent gap). Methodology: closure-v5 inverse_born_methodology.md. 2 honesty flags recorded (CKN-saturation=consistency-not-identity; random-μ-min=sampling-artifact) |

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
