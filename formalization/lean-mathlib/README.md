# `formalization/lean-mathlib/` — universal Lean theorems (Mathlib-backed)

The Mathlib upgrade of Rung 0: the scaling-criticality calculus proved for **ALL**
parameters (`∀ α p q : ℚ`), not just at exemplar triples. Complements — does not
replace — the hermetic, zero-dependency `../lean/Scaling.lean` (which proves the
concrete instances by `native_decide`, no Mathlib).

`:proved` = 0 for the PDE, and stays 0: these are theorems about the **scaling
exponents** (criticality bookkeeping), the algebra the analysis stands on — not the
inequalities/theorems.

## What is proved (`ScalingUniversal.lean`)
- **`lebExp_critical_iff (α p q : ℚ)`** — the norm `‖|x₃|^α u^θ‖_{L^q_t L^p_x}` is
  scale-invariant iff `2/q + 3/p = 1 − α` (the WHWY criticality), for **all** α,p,q.
- **`sobExp_critical_iff (s : ℚ)`** — Ḣ^s critical iff `s = 1/2`, for all s.
- **`energy_supercritical`** — `[L²] < 0` (NS-002), and `lebExp_eq` / `energy_gap`
  give the exact algebraic form and the σ=−1 vs σ=0 gap.
Proofs: `linarith` / `norm_num` over ℚ (the criticality iff is a linear rearrangement
in the atoms {α, 3/p, 2/q}).

## Verification status
**Verified** by `lake env lean ScalingUniversal.lean` against the built Mathlib of the
TCE `src/lean4-cv` project (Mathlib rev `5d69f04…`, toolchain `v4.30.0-rc2`). A
deliberately-false variant (`= 2−α` in place of `1−α`) was correctly **rejected** by
`linarith` — confirming Mathlib genuinely loaded and the checker is sound, not
rubber-stamping.

## Reproduce standalone
```
cd formalization/lean-mathlib
lake exe cache get      # fetch the prebuilt Mathlib oleans for the pinned rev (no rebuild)
lake build              # exits 0 iff ScalingUniversal type-checks
```
Pinned (lockfile discipline): `lean-toolchain` (v4.30.0-rc2) + `lake-manifest.json`
(Mathlib `5d69f04…` + transitive deps), mirroring TCE `src/lean4-cv` so the populated
global Mathlib cache (`~/.cache/mathlib`) is reused.

## Rung 1 universal (`AxisymUniversal.lean`) — ✅ done
The load-bearing axisymmetric structural identities proved for **ALL fields**
(`∀ u : MvPolynomial (Fin 3) ℚ`, vars r=X0, z=X1, t=X2), via `pderiv` + `ring`:
- **`gamma_source_free_operator`** — the Γ source-free operator identity (maximum-principle basis);
- **`gamma_transport`** — the Γ transport identity (with the above ⇒ `∂_tΓ+b·∇Γ−νL_ΓΓ=0`);
- **`omega_operator_transform`** — the `Ω=ω^θ/r` transform: the **`(3/r)∂_r` emerges**, `1/r²` cancels;
- **`source_chain`** (`∂_z(Γ²)=2Γ∂_zΓ`) + **`z_indep_r_power`** (`∂_z(rᵏf)=rᵏ∂_zf`) ⇒ the source
  `S=(1/r⁴)∂_z(Γ²)=∂_z(u₁²)`, `u₁=Γ/r²`.

- **`pderiv_comm`** — mixed partials commute (proved by induction on the polynomial), and the corollary
  **`pressure_elimination`** (`∂_z∂_r p = ∂_r∂_z p` ⇒ the curl kills `∇p`);
- **`biot_savart`** — the Stokes stream function relation `ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ`, cleared `×r²`.

**Denominator-clearing:** the `1/r`,`1/r²` structural identities are stated in their `×rᵏ` polynomial
form — equivalent to the `1/r` form wherever `r≠0`, and `∀`-quantified over the polynomial ring (the
formal differential-algebraic content; the `native_decide` file checks only a monomial grid). **Soundness
sanity:** a false variant (`2/r ∂_r` for the correct `3/r`) was correctly rejected — `ring` reduced the
true side to coefficient 3. The full Rung-1 operator structure (incl. pressure elimination + Biot–Savart)
is now universal.

Verified by `lake env lean AxisymUniversal.lean` against the same built Mathlib. `:proved`=0 for the PDE.

## Rung 2 — the inequalities (started bite-by-bite) — `WeakLp.lean`
A 2026-06-08 survey corrected an earlier over-estimate: much of the substrate is already formalized
(Sobolev + Gagliardo–Nirenberg–Sobolev in Mathlib core; De Giorgi–Nash–Moser regularity, Armstrong–Kempe
2026; Fefferman's NS Millennium statement). Remaining gaps are discrete library additions. **First bite:**
- **`WeakLp.lean`** — the **weak-Lᵖ (Lorentz `L^{p,∞}`) quasinorm** `wnorm`, the membership predicate
  `MemWLp`, and theorems: the foundational **`Lᵖ ⊆ L^{p,∞}` embedding** `wnorm_le_eLpNorm` (from Mathlib's
  Chebyshev–Markov `mul_meas_ge_le_pow_eLpNorm'`); **monotonicity** `wnorm_mono`; the
  **quasi-triangle inequality** `wnorm_add_le` (`‖f+g‖_{p,∞} ≤ 2(‖f‖_{p,∞}+‖g‖_{p,∞})` for `1≤p<∞` —
  weak-Lᵖ is a *quasi*-normed space; via the `t/2`-split + `ENNReal.rpow_add_le_add_rpow`); the
  **distribution-function bound** `meas_le_wnorm_div_rpow` (`μ{s ≤ ‖f‖ₑ} ≤ (‖f‖_{p,∞}/s)^p`); and the
  **Marcinkiewicz core** — **`eLpNorm_lt_top_of_wnorm` / `MemWLp.memLp`**: `f` in weak-Lᵖ ∩ weak-L^q with
  `0<p<r<q<∞` lies in `Lʳ`. Proof: the `‖·‖ₑ`→real bridge (`enorm` is never `∞`) + Mathlib's layer-cake
  `lintegral_rpow_eq_lintegral_meas_lt_mul` + the **two-tail split at `t=1`** (the `p`-tail integrable at
  `0` since `r>p`, the `q`-tail integrable at `∞` since `r<q`, via `intervalIntegrable_rpow'` /
  `integrableOn_Ioi_rpow_of_lt`). **Soundness sanity:** a false exponent variant (`r−e+1` for `r−e−1`)
  is correctly rejected. Plus the **operator form**: `HasWeakType T p μ ν C` (weak-type `(p,p)` with
  constant) and **`HasWeakType.memLp_interpolate`** — `T` weak-(p,p) + weak-(q,q) (finite constants) maps
  `Lᵖ ∩ L^q → Lʳ` for `p<r<q`, *qualitative* (no sublinearity needed).

  **And the full STRONG-TYPE Marcinkiewicz (diagonal case):** supporting lemmas — level truncations
  `truncGT`/`truncLE` with the **exact** pointwise split `truncGT f t + truncLE f t = f`, their
  AE-strong-measurability and `MemLp` (large part ∈ `Lᵖ` for `p<r`, small part ∈ `L^q` for `r<q`), the
  model `t`-integrals (`lintegral_Ioo_rpow_ofReal`, `lintegral_Ioi_rpow_ofReal`), and the Tonelli
  swap-and-evaluate lemmas (`swap_eval_low`, `swap_eval_high`). Main theorems:
  - **`lintegral_rpow_le_of_hasWeakType`** — for sublinear `T` of weak types `(p,p)`,`(q,q)` (finite
    constants), `0<p<r<q<∞`, `f ∈ Lʳ`: `∫‖Tf‖ₑ^r ≤ K·∫‖f‖ₑ^r` with the **explicit constant
    `K = r·(Cp^p·2^p/(r−p) + Cq^q·2^q/(q−r))`**. Proof: layer-cake on `Tf` → exact level-`t` split of
    `f` → sublinearity + the two weak-type bounds at threshold `t/2` → Tonelli swap → inner-integral
    evaluation. (`T f`-measurability is a hypothesis — it does not follow from sublinearity. `[SFinite μ]`
    for Tonelli.)
  - **`memLp_of_hasWeakType`** — the membership form: sublinear `T` of weak types `(p,p)`,`(q,q)` maps
    `Lʳ → Lʳ` for all `p<r<q`. **The full Marcinkiewicz interpolation theorem (diagonal case).**
  **Soundness sanity:** a false exponent variant of the threshold-absorption identity is correctly
  rejected; no `sorry`. A confirmed Mathlib gap; upstreamable.

## Littlewood–Paley layer (`LittlewoodPaley.lean`)
- **The dyadic partition of unity** — `lpChi` (canonical `ContDiffBump`), `lpSymbol ψ(ξ)=χ(ξ)−χ(2ξ)`,
  `lpSymbolAt j ξ = ψ(2^{−j}ξ)`; machine-verified: every-order smoothness, `0≤ψ≤1`, annulus support
  (`1/2 < ‖ξ‖ < 2`; dyadic `2^{j−1} < ‖ξ‖ < 2^{j+1}`), gap-2 support disjointness, and
  **`hasSum_lpSymbolAt : ∀ ξ ≠ 0, HasSum (fun j : ℤ => ψ(2^{−j}ξ)) 1`** (≤3-term window at
  `Int.log 2 ‖ξ‖`, telescoping). Generic over `[HasContDiffBump E]`.
- **Frequency projections + Besov seminorm** — `lpProj j : 𝓢(V,F) →L[ℂ] 𝓢(V,F)` (`P_j = ψ_j(D)`, built
  on Mathlib's `SchwartzMap.fourierMultiplierCLM`; the symbol's temperate growth from compact support);
  `lpProj_comp_eq_zero` (`P_j ∘L P_k = 0` for `j+2 ≤ k`, via the multiplier composition law + symbol
  disjointness); **`besovSeminorm s p q μ`** — the homogeneous `Ḃ^s_{p,q}` seminorm on Schwartz functions
  (`ℓ^q(ℤ)` of `2^{js}‖P_j f‖_{L^p}`), the space NS-046's target is stated in; `besovSeminorm_zero`.
- **Bernstein (L²)** — `eLpNorm_lineDerivOp_lpProj_le`: `‖∂_m P_j f‖_{L²} ≤ 2π‖m‖·2^{j+1}·‖P_j f‖_{L²}`
  via the lineDeriv-multiplier identity + composition law + the annulus bound + the L² Fourier isometry
  (`eLpNorm_fourierInv_two`). ℂ/ℝ-scalar bridge `lpProj_eq_realMultiplier` (restricted smul is `rfl`);
  `SMulCommClass ℂ ℝ W` provided as a local instance (only the `ℝ ℂ` order is global).
- **Young + the multiplier–convolution bridge** — `eLpNorm_convolution_le` (Young `L¹⋆Lᵖ→Lᵖ`, new to
  Mathlib's ecosystem; Hölder + Tonelli + translation invariance); `fourierMultiplierCLM_schwartz_eq_convolution`;
  `eLpNorm_fourierMultiplierCLM_le` (Schwartz-symbol multipliers bounded on every `Lᵖ` with constant
  `‖𝓕⁻σ‖_{L¹}` — the structural `Lᵖ` Bernstein).
- **Sharp `Lᵖ` Bernstein** — `eLpNorm_lineDerivOp_lpProj_le_lp_sharp`:
  `‖∂_m P_j f‖_p ≤ 2π·2^j·‖𝓕⁻σ₀(m)‖_{L¹}·‖P_j f‖_p` (`1 ≤ p < ∞`, constant j-independent). Via the
  fattened symbol `lpFat`, the Schwartz kernel family `bernSymbol`, the ℝ/ℂ multiplier bridge, and the
  dilation chain (`bernSymbolFun_eq_smul` → `fourierInv_bernSymbol_eq` → `eLpNorm_fourierInv_bernSymbol`,
  via `Real.fourierInv_eq` + `Measure.integral_comp_smul`).
- **Besov space (opened)** — `hasSum_lpSymbolAt_nat` (inhomogeneous partition, all `ξ`); `lpLowProj`;
  **`besovNormI`** + **`besovNormI_eq_zero_iff`** (the inhomogeneous Besov expression is a genuine
  NORM on 𝓢 — nondegeneracy via multiplier-vanishing + the partition + Fourier injectivity);
  `lpProjD`/`lpProjD_comp_eq_zero` on 𝓢' (NB: the 𝓢'-composition lemma in Mathlib is reversed).
- **Distributional Besov space** — `sum_range_lpSymbolAt` (finite telescoping, every `ξ`/`M`);
  `lpLowProjD`/`lpLowProjDAt`/`lpProjD_eq_sub` + **`lpLowProjDAt_eq_add_sum`** (the EXACT finite LP
  decomposition of `𝓢′`: `S_M = S₀ + Σ_{j<M} P_{j+1}` as operators); `lpProjD_coe`/`lpLowProjD_coe`
  (the distributional projections extend the Schwartz ones); `HasLpRep` + injectivity of `Lᵖ→𝓢′` +
  `lpNormD` (well-defined unique-representative `Lᵖ` size); **`besovNormD`/`MemBesovD`** (membership
  forces every block into `Lᵖ`: `hasLpRep_low`/`hasLpRep_block`) + **`besovNormD_coe`** (extension
  theorem: restricted to `𝓢` it IS `besovNormI`, so nondegeneracy transfers).
- **Approximation of identity + the LP expansion of `𝓢′`** — `exists_seminorm_smulLeft_lpChiAtC_sub_le`
  (every Schwartz seminorm of `χ_M·ψ−ψ` is `≤ K·2^{−M}`: support localization + Leibniz + uniform
  dilated-bump bounds + one extra Schwartz-decay power); `tendsto_smulLeftCLM_lpChiAtC` (`→` in `𝓢`);
  `tendsto_lpLowProjDAt` (`S_M u → u` weak-* in `𝓢′`); **`tendsto_lowProjD_add_sum`** (every tempered
  distribution = the weak-* sum of its LP series); `eq_zero_of_lp_blocks_eq_zero` +
  **`besovNormD_eq_zero_iff`** (full nondegeneracy on ALL of `𝓢′` ⇒ `B^s_{p,q}(𝓢′)` is a genuine
  normed space).

## Carleman layer (`Carleman.lean`) — Tao 1908.04958 §4, the backward-uniqueness machinery

The §4 Carleman inequalities, formalized bite-by-bite per the ladder plan (see `changelog.md`
v0.15.3→ and `docs/carleman_ladder0_tao_sec4_audit.md`). **Library infrastructure plus citation
verification; `:proved` = 0 for the PDE — distance to the prize UNTOUCHED.**

- **Ladder-0 (audit)** — full-text read of §4 confirms IBP-only machinery; every transcribed
  identity machine-checked in `disproof/record_audit.py` (B8–B13).
- **Ladder-1 (the abstract commutator method)** — `CommutatorMethod` structure +
  `hasDerivAt_pair_S` (Tao's chain `∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩`) +
  `deriv_pair_S_le` (drop-the-square inequality).
- **Ladder-2 (`WeightCalculus`)** — the two radial weights g42/g43 with every `F`, `LF`, Hessian
  display as an exact field identity (B11/B12).
- **Ladder-3 (`NormCalculus` + `WeightedGreen`/`WeightedGreenAux`)** — norm calculus (∇‖x‖,
  Hess‖x‖, radial Laplacian — a filled Mathlib gap); the weighted Green identity (B8), `S_g`
  self-adjointness (B9), `Δ(e^g)` chain rule, and the spatial + full master differential identity.
- **Ladder-4/5 (`CommutatorInstance` + `SliceCalculus`)** — the weighted-L² `CommutatorMethod`
  instance with `mem_S` as its single assumed field, then BOTH Clairaut keystones that discharge
  it: `hasDerivAt_fderiv_slice` (`∂t∂ₓ = ∂ₓ∂t`) and `hasDerivAt_laplacian_slice`
  (`∂tΔₓ = Δₓ∂t`, the instance-safe `iteratedFDeriv` route around the nested-CLM instance gap).
- **Ladder-5c (`JointAdmissible`)** — `AdmissibleJoint` (jointly C^∞ test curves; every ladder-4
  witness derives), `admissibleJoint_mem_S` (the `mem_S` discharge), and
  **`commutatorMethod_weighted_joint`**: the full `CommutatorMethod` structure from the single
  hypothesis `ContDiff ℝ ⊤ G` — every field proved, the abstract chain now unconditional on the
  real weighted-L² objects.
- **Ladder-6a (`Lemma41`)** — `weightedPairing_S_self`, the energy identity
  `⟨S_g(t)u, u⟩_g = −∫(‖∇u‖² + ½F·u²)e^g` (Tao's `⟨Su,u⟩` display; weighted Green with `v := u`).
- **Ladder-6b-α substrate i (`CommutatorSubstrate`)** — the pure-spatial calculus toward the
  commutator quadratic form: `laplacian_mul` (the Laplacian Leibniz rule `Δ(uv) = uΔv + vΔu +
  2⟪∇u,∇v⟫`, a filled Mathlib gap), `inner_grad_eq_sum` (spatial Parseval), `laplacian_fun_sum`
  (finite-sum additivity). False coefficient-1 variant rejected; no `sorry`.
- **Ladder-6b-α substrate ii** — the 5b-ii third-derivative swap chain ported to the E-domain
  (`eIFD3_eq_left`/`eIFD2_apply_dir`/`eIFD3_swap12`/`eIFD3_swap23`/`fderiv_iFD2_coeff`) and
  `laplacian_deriv_swap`: the spatial Clairaut commutation `Δ(∂_w f) = ∂_w(Δf)` for `f` C³.
  False wrong-slot variant rejected; no `sorry`.
- **Ladder-6b-α substrate iii (the spatial substrate COMPLETE)** — `fderiv_fderiv_dir`
  (`∂_v∂_d f = iFD2 f ![v,d]`) and **`laplacian_inner_grad`, the four-index identity**
  `Δ⟪∇f,∇h⟫ = ⟪∇(Δf),∇h⟫ + 2⟨D²f,D²h⟩_HS + ⟪∇f,∇(Δh)⟫` (the engine of `Δ(∇g·∇u)`; assembled
  from the Leibniz rule, the spatial Clairaut swap, Parseval and `Finset.sum_comm`). False
  coefficient-1 variant rejected; no `sorry`.
- **Ladder-6b-β substrate i+ii (`CommutatorTime`)** — the time-derivative toolkit for the
  S-operator's coefficients: `hasDerivAt_slice_inner` (`∂t⟪∇ₓF,∇ₓH⟫ = ⟪∇ₓ∂tF,∇ₓH⟫ +
  ⟪∇ₓF,∇ₓ∂tH⟫`, from the 5a slice keystone + `HasDerivAt.fun_sum`) and `hasDerivAt_slice_F`
  (`∂tF = gtt − Δ(∂tg) − 2⟪∇∂tg,∇g⟫` for the Carleman potential `F = ∂tg − Δg − ‖∇g‖²`).
  False missing-term variant rejected; no `sorry`.
- **Ladder-6b-β assembly** — `hasDerivAt_Sslice`: the full time derivative of `S(t)u(t)` in
  commutator-decomposed form `∂t(Su) = S(∂tu) + (⟪∇gt,∇u⟫ − ½(∂tF)u)`, exhibiting the
  commutator's time part `[L,S]u|_time = ⟪∇gt,∇u⟫ − ½(∂tF)u`. Assembled from the three β/5b
  time-derivative combinators + `ring`. False missing-term variant rejected; no `sorry`.
- **Ladder-6b-γ i (`CommutatorIBP`)** — `integral_fderiv_mul_weight`, the weighted directional
  integration by parts `∫(∂ᵥφ)ψe^g = −∫φ(∂ᵥψ + ψ∂ᵥg)e^g` (φ compactly supported), the
  workhorse for the spatial-commutator `A+B` collapse — the `e^g` weight contributes the
  `ψ∂ᵥg` term that produces the cancelling `D²g(∇g,∇u)` cross-terms. Built on Mathlib's
  n-dim compact-support IBP. False missing-weight-term variant rejected; no `sorry`.
- **Ladder-6b-γ ii core** — `integral_inner_grad_mul_weight`, the triple-product weighted Green
  identity `∫⟪∇a,∇b⟫·c·e^g = −∫ b·(Δa·c + ⟪∇a,∇c⟫ + c·⟪∇a,∇g⟫)·e^g` (b compactly supported) —
  the heart of the `A`-collapse, assembled from γ-i summed over the basis. False
  dropped-weight-term variant rejected; no `sorry`.
- **Ladder-6b-γ ii complete (`integral_hessianHS_collapse`)** — the `A`-collapse:
  `∑ⱼ∫⟪∇∂ⱼg,∇∂ⱼu⟫·u·e^g = −∫⟪∇u,∇Δg⟫u·e^g − ∫D²g(∇u,∇u)·e^g − ∫D²g(∇g,∇u)u·e^g` (`u` C²
  compactly supported, `g` C³), via the core lemma per-`j` + the spatial Clairaut swap + Parseval.
  False flipped-sign variant rejected; no `sorry`.
- **Ladder-6b-γ iii (`inner_grad_normSq_eq`)** — the `∇‖∇g‖² = 2 D²g ∇g` identity:
  `⟪∇‖∇g‖²,∇u⟫ = 2·∑ⱼ ∂ⱼu·⟪∇∂ⱼg,∇g⟫` (γ-ii's `D²g(∇g,∇u)` form), via Parseval + per-`i`
  differentiation + Hessian Schwarz symmetry. The last ingredient of the `A+B` cancellation.
  False coefficient-1 variant rejected; no `sorry`. **6b-γ complete.**

Next rungs: ladder-6b (the concrete commutator `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)u²)e^g`,
staged α spatial-substrate / β time-derivative / γ Bochner-IBP / δ assembly) → Lemma 4.1's
displayed inequality → Props 4.2/4.3 → the backward-uniqueness wrapper.
