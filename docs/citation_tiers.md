# Citation tiers (C0–C5) — the consolidated index

**The single place every load-bearing external citation's reliability tier is recorded.** The C0–C5 scale is
*defined* in the `SPEC.md` header (the "Citation reliability" block); the per-citation assignments were
previously scattered inline across entries and `docs/ns_blowup_generator_class.md` — this table gathers them.
**`:proved`=0; distance to the prize UNTOUCHED** — tiering a citation says how well *we* checked someone
else's theorem, never that *we* proved anything. A no-go's force in the obstruction map is
`tier × independence × scope-match` (*echo ≠ convergence*).

## The scale

| Tier | Meaning |
|---|---|
| **C0** | unverified mention |
| **C1** | secondary-source / restatement only (incl. paywalled-original-via-survey) |
| **C2** | primary statement read |
| **C3** | proof line-verified |
| **C4** | core mechanism independently re-derived |
| **C5** | adversarially checked |

> **Why this matters (the genuine value).** Verifying — not just citing — caught real errors the
> literature/our-own-transcription introduced: a **misattribution** (the Type-I⟺ancient equivalence was
> cited as *Seregin–Šverák*; it is **Albritton–Barker**, and is **Type-I-*conditioned***, not the general
> Liouville we'd implied), a **transcription/record error** in an NRŠ H-identity, and a **hardened endpoint**
> for a Wang fractional-Hardy bound. Citations are objects to verify, not trust.

---

## Hard obstructions (the `G1–G5` of the generator class — others' theorems)

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| Leray (1934); Hopf (1951) — weak solutions | **C2** (statement-level; not separately verified) | foundational; cited at statement level | NS-003 |
| Beale–Kato–Majda (1984) — BKM blow-up criterion | **C2** (statement-level) | the `∫‖ω‖∞` mechanism; standard | NS-004, the δ↔BKM diagnostic |
| Prodi (1959) / Serrin (1962) / **Escauriaza–Seregin–Šverák (2003)** — critical / `L³` endpoint | **ESS C2**; Gallagher–Koch–Planchon (every critical Besov) **C1** | the σ=0 critical-norm criterion (G1) | NS-005, G1 |
| **Caffarelli–Kohn–Nirenberg (1982)** — partial regularity, singular set ≤1-D | **C2** (statement; the `ε₀` constants **C1**) | the ≤1-D / `𝒫¹(S)=0` localization (G2) | NS-006, G2 |
| **Nečas–Růžička–Šverák (1996)** + **Tsai (1998)** — self-similar exclusion | **NRŠ C2** / **Tsai C3** (line-read) | no nontrivial `(−1/2)`-self-similar profile in `L³` (G3); `docs/nrs_ess_verification_2026-06-07.md` (an H-identity **record error caught + fixed**) | NS-007, G3 |
| **Tao (2016, JAMS)** — averaged-NS blow-up | **C2** (statement; the killed method-class C2, *not* line-verified) | energy-only methods are insufficient (G5) | NS-008, G5 |
| **Albritton–Barker (arXiv:1811.00502, 2019)** — Type-I singularity ⟺ ancient solution | **C3** (line-verified) | ⚠ **MISATTRIBUTION CAUGHT** (cited as Seregin–Šverák; it is Albritton–Barker) + **scope corrected** to **Type-I-*conditioned* (`I<∞`)**, NOT general Liouville; `docs/citation_verification_round2_2026-06-07.md` | G4, NS-048 |
| **KNSS — Koch–Nadirashvili–Seregin–Šverák (Acta 2009)** — ancient-solution Liouville foundation | **C3** (hypothesis-clean; Lemma 6.1 compactness) | the rescaling/compactness device; `docs/knss_verification_2026-06-07.md` | G4, NS-048 |
| Constantin–E–Titi (1994); Isett (2018); BDLSV (2019); Onsager (1949) — the 1/3 inviscid picture | **C2** (statement-level) | Onsager regularity / dissipation | NS-009 |

## Soft framings (`S1, S2` — in-repo arguments, not external theorems)

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| Supercriticality / scaling (Tao expositions) | **C2+ consensus**; exact exponents **algebraic (in-repo)** | the σ-calculus pinning critical ↔ supercritical | NS-002 / NS-034, S1 |
| Production-is-the-breaker (criticality–Casimir hinge) | **in-repo argued + algebraic** | the interpolation `‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²}‖u‖_{Ḣ¹}` + ideal-flow Casimirs | NS-036, S2 |

## Live / complex-data + the dynamic (NS-048) frontier

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| **Li & Sinai (2008, JEMS)** — complex-data 3D-NS finite-time blow-up | **C2** (statement-level) | the credibility of the complex-plane backward path | NS-012 |
| **Lei–Ren–Zhang / Lei–Zhang–Zhao (Thm 3.7)** — swirl-free reduction | **C3** (both) | "every known closer bypasses the `S`-source via `Γ`-decay"; `docs/citation_verification_round3_2026-06-07.md` | NS-048 |
| **Pan–Li** — sublinear-growth axisym Liouville | **C3** (line-verified) | the blow-down/Liouville-rescaling contrast; `docs/pan_li_verification_2026-06-07.md` | NS-048 (route-i) |
| **Tsai** — asymptotically-self-similar / Type-II | **C2/C3** | the Type-II ceiling on the ancient-Liouville machinery | NS-048 (type-II) |
| Yu / Wang–Huang–Wei–Yu — `|x₃|^α` axial-swirl criterion | **C1/C2** (named; not all line-read) | the anisotropic-`z` swirl port (a genuine new question, not implicit) | NS-048 |
| Tao (triple-log); Palasek (axisym double-log) — Type-II rate bounds | **C1/C2** (primary-read, partial) | the gap-to-full-exclusion is *qualitative* | NS-048 (type-II) |

## NS-049 — Lockwood "Singularity Surgery" (the one external regularity-*attack*)

| Citation | Tier | What we checked | Used by |
|---|---|---|---|
| Lockwood, *Singularity Surgery* Parts I–V (2026, self-contained working papers, no bibliography) | **C0/C1** (UNVERIFIED working papers) | **our** C3-on-line-read verdict (`docs/ns049_lockwood_verification.md`): a *conditional* anisotropy-depletion criterion (assumes `δ_Λ→0`, never derived; a resolved-DNS probe drives `δ_Λ` the *wrong* way) — **NOT** the unconditional proof its framing implies | NS-049 |

## NS-050 — modulation/Type-II prior art (all C1 — named/abstract, verify before citing as established)

| Citation | Tier | Note | Used by |
|---|---|---|---|
| **Merle–Raphaël–Rodnianski–Szeftel** (arXiv:1912.11009; Annals 2022 I/II; non-radial 2310.05325) | **C1** | smooth imploding self-similar **compressible** Euler/NS; their NS singularities are **Type-II** | NS-050 |
| **Elgindi** (Annals of PDE) | **C1** | `C^{1,α}` axisym Euler, no swirl — degraded regularity | NS-050 |
| **Chen–Hou** (arXiv:2210.07191 Analysis + 2305.05660 Rigorous Numerics) | **C1** | computer-assisted 2D Boussinesq / 3D axisym Euler **with boundary**, smooth data | NS-050 |
| **Chen–Hou–Huang** (arXiv:2308.01528) | **C1** | exact self-similar blow-up of the 1D Hou–Luo model; `c_ω=−1`, `c_l∈(2,4.53)` (the band the NS-050 instrument's `β=2.47` lands in) | NS-050 (T-26) |
| Conditional Type-II exclusion (arXiv:2304.04045; 2507.08733) | **C1** | ancient-Euler Liouville + generalized LPS = the NS-048 Hole-B machinery | NS-050, NS-048 |
| Hou — near-self-similar axisym NS (arXiv:2405.10916) | **C1 / numerical** | candidate seed for a DSS profile search | NS-050 |

## Related (non-PDE — kinship only, fenced)

| Citation | Tier | Note | Used by |
|---|---|---|---|
| Gosme (arXiv:2512.09352, 2025) — causal-symmetrization | **C1** | software-ecosystems / phenomenology; NOT PDE | NS-025 |
| Ryan (arXiv:nlin/0609011, 2006) — emergence coupled to scope not resolution | **C1** | conceptual lens behind the σ=0 diagnostic; NOT PDE | NS-035 |

---

## Honesty notes

- **"Statement-level (C2, not separately verified)"** means we read/know the primary statement but have no
  in-repo line-verification artifact; foundational theorems (Leray, BKM, CKN-statement, Onsager, Li–Sinai)
  sit here by default — high confidence in the *statement*, no claim of an independent proof-check.
- **C3 entries have a named verification doc** (`*_verification_2026-06-07.md`) recording the line-read.
- **No C4/C5 yet** — no external theorem has been independently re-derived (C4) or adversarially stress-tested
  to C5 in-repo (the over-reach discipline would require that bar before claiming it).
- Tiers can rise; when a citation is pushed to C3+, log the verification doc here and update the inline tag.

**Source/maintenance:** assignments collected from `docs/ns_blowup_generator_class.md` (G1–G5/S1–S2), the
`*_verification_2026-06-07.md` campaign docs, `docs/ns049_lockwood_verification.md`,
`docs/ns050_modulation_type2_scope.md`, and the SPEC entries. The C0–C5 scale + force-rule are defined in the
`SPEC.md` header.
