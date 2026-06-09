# Disproof probes — NRŠ H-identity (symbolic) + Wang anisotropic Hardy–Sobolev (numerical)

**Date:** 2026-06-08. Two **cheap disproof instruments** (the C5 "try to disprove / rigorous-numerics +
computer-algebra" rung) run against two load-bearing citations. Scripts in `disproof/` (uv venv:
numpy 2.4.6, sympy 1.14.0). **Citation-verification, not PDE progress; `:proved`=0; distance UNTOUCHED.**

Headline: **one genuine record-error found (NRŠ), one citation hardened (Wang).** Neither cited *theorem*
is disproved — but the symbolic check caught a real mistake in *our own line-read record*, exactly the
supply-chain failure mode this discipline targets.

---

## 1. NRŠ H-identity — **RECORD ERROR FOUND** (`disproof/nrs_h_identity.py`, sympy)

**Target.** Nečas–Růžička–Šverák (Acta 176, 1996), self-similar non-existence. Profile equation
`−νΔU + aU + a(y·∇)U + (U·∇)U + ∇P = 0`, `div U = 0`; auxiliary `H = ½|U|² + P + a(y·U)`.
**Our recorded identity** (`docs/nrs_ess_verification_2026-06-07.md`, ledger NS-007):
`−νΔH + (U·∇)H = −ν|∇U+aI|² + ν(∂ᵢUⱼ)(∂ⱼUᵢ) ≤ 0`.

**Method.** Treat every partial derivative as an independent symbol; substitute `ΔU_k` from the profile
equation and `ΔP` from the pressure-Poisson relation (= divergence of the profile eq, using `div U=0`);
impose `div U=0`. A true identity must then reduce the LHS−RHS difference to `0`.

**Result (verbatim outputs).**
- `(−νΔH + (U·∇)H) − RHS_recorded` = a **messy `y`-dependent nonzero** polynomial ⇒ the identity **as
  recorded is FALSE**.
- `(−νΔH + (U·∇)H + a(y·∇)H) − RHS_recorded` = **`3a²ν`** (a pure constant).
- `−νΔH + (U·∇)H + a(y·∇)H` reduces **exactly** to
  `−ν[(∂₁U₂−∂₂U₁)² + (∂₁U₃−∂₃U₁)² + (∂₂U₃−∂₃U₂)²]` — a manifestly **≤ 0** antisymmetric-gradient square.

**The corrected identity:**
> `−νΔH + (U·∇)H + a(y·∇)H = −ν Σ_{i<j}(∂ᵢUⱼ − ∂ⱼUᵢ)² = −ν|∇U|² + ν(∂ᵢUⱼ)(∂ⱼUᵢ) ≤ 0`.

**Two errors in our record:** (i) it **dropped the `a(y·∇)H` self-similar drift** from the elliptic
operator — without which the identity is literally false; (ii) the recorded RHS `−ν|∇U+aI|²+…` is **off by
a constant `+3νa²`** from the clean true RHS `−ν|∇U|²+…` (since `|∇U+aI|²=|∇U|²+3a²` for div-free `U`).

**Impact: the NRŠ *theorem* is unaffected.** Both RHS forms are `≤0`, so the max-principle chain
(`LΠ ≤ 0` + decay ⇒ `Π ≤ 0` ⇒ `U≡0`) stands. The defect is entirely in **our transcription**.

**[VERBATIM CONFIRMATION 2026-06-08]** Re-fetched NRŠ Lemma 3.3 (Acta p. 290; scanned PDF via the Tsinghua
archive mirror, read visually). The original states: `Π(y) = ½|U(y)|² + P(y) + ay·U(y)` satisfies the
maximum principle; proof sets `Ũ := U + ay`, `P̃ := P − ½a²|y|²` (so the system becomes
`−νΔŨ+(Ũ·∇)Ũ+∇P̃ = 0`, `div Ũ = 3a`), and derives
`−νΔ(½|Ũ|²+P̃) + (Ũ·∇)(½|Ũ|²+P̃) = −ν|∇Ũ|² − νΔP̃ = −ν|∇U+aI|² − νΔP + 3νa² = −ν|∇U|² + ν(∂ᵢUⱼ)(∂ⱼUᵢ) ≤ 0`,
with `½|Ũ|²+P̃ = Π`. This **matches the symbolic finding term-for-term**: (a) the advection is the **full
self-similar velocity `Ũ = U + ay`** — the `a(y·∇)Π` drift IS present in the original; our doc's `(U·∇)H`
dropped the `ay`. (b) NRŠ's **final** RHS is exactly `−ν|∇U|² + ν(∂ᵢUⱼ)(∂ⱼUᵢ)`; the `−ν|∇U+aI|²` we
recorded was their **intermediate** line, recorded as if final → the `+3νa²` gap (the `3` is the spatial
dimension, from `Δ(½a²|y|²) = 3a²` — not a normalization artifact). **Verdict: the NRŠ original is
correct; both errors were entirely ours.** Corrected in `docs/nrs_ess_verification_2026-06-07.md`.

**Why it matters:** a *human line-read graded C3* recorded a false identity; a **2-minute symbolic check
caught it.** This is the concrete payoff of the computer-algebra disproof rung — it finds what reading
misses.

---

## 2. Wang anisotropic Hardy–Sobolev — **CITATION HARDENED** (`disproof/wang_hardy.py`, numpy)

**Target.** Wang–Huang–Wei–Yu (arXiv:2205.13893) Thm 1.2 (fractional Hardy–Sobolev),
`‖f/∏|rⱼ|^{αⱼ}‖_{Lᵖ} ≤ C‖Λ^{Σαⱼ}f‖_{Lᵖ}`, constraint `0<αⱼ<kⱼ/p`; used in Thm 1.4 (the `|x₃|^α u^θ`
criterion, `0≤α<1/4`).

**Key analytic finding (resolves the triad's "α→1/4" suspicion).** For the NS weight `|x₃|^α` this is the
single-variable case `k=1`, so the constraint is `α < 1/p`. At the **critical** `p = 3/(1−α)` (the lower
end of Thm 1.4's `p`-range), `α < 1/p ⟺ α < (1−α)/3 ⟺ **α < 1/4**`. So **`α<1/4` is exactly the
fractional-Hardy integrability endpoint `α<k/p` at the critical exponent**, and the sharp constant is
known to diverge there. The triad's "endpoint is a genuine barrier" suspicion is **confirmed, with the
mechanism** — and it is *correct, necessary* citation behavior, not a flaw.

**Numerical probe (1-D `k=1` slice, FFT, `p=4 ⇒ 1/p=0.25`).**
- **(A) Violation search:** max ratio `R[f]=‖f/|x|^α‖_p/‖Λ^α f‖_p` over a wide shape family + 400 random
  superpositions at fixed `α=0.20<1/p` ≈ **1.9, bounded** — **no gross violation; the inequality holds.**
- **(B) Endpoint trend:** max `R` rises monotonically as `α→1/p` (1.27 → 2.98 as `α/(1/p)`: 0.16 → 0.996).
- **(C) Divergence mechanism:** for a fixed Gaussian (`f(0)=1`), `‖f/|x|^α‖_p` *converges* as the grid
  refines for `α=0.20` (`αp=0.8<1`, integrable) but grows with ever-slower convergence as `α→0.25`
  (`αp→1`, the weight `|x|^{−αp}` becomes non-integrable). The clean divergence is analytic
  (`∫|x|^{−αp}` near 0 `~ 1/(1−αp) → ∞`); the numerics corroborate the onset (grid-capped at `|x|~dx/2`).

**Net:** the inequality is **not disproved** — it holds, and the `α<1/4` restriction is the genuine,
necessary fractional-Hardy endpoint. Citation **hardened**; the triad refinement is explained mechanistically.

---

## 3. Method note
The cheap disproof instruments (symbolic verification for closed-form/algebraic claims; numerical
violation-search + scaling for clean inequalities) — the *lower ladder rungs (Julia/Python)*, not full
Lean — did the work here, inside the C5 "computer-algebra / rigorous-numerics" bar. Lean remains the
back-loaded certainty instrument; for *finding* discrepancies, these are the efficient first pass. `:proved`=0.
