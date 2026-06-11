# Carleman ladder-0: full-text audit of Tao 1908.04958 §4 — the "IBP-only" reading CONFIRMED

**Date:** 2026-06-10. **Scope:** ladder-0 of the Carleman formalization plan (see changelog
v0.15.0 *Next* note and the deep-research recalibration of the "summit" framing): verify, against
the full PDF, that Tao's §4 Carleman inequalities — the load-bearing ingredient of the triple-log
bound (NS-008's quantitative form) — use only integration-by-parts-class machinery. The
deep-research pass had this reading from a single (truncated) fetch; this audit reads the proofs
end-to-end and machine-checks every transcribed identity.

**Verdict: CONFIRMED.** §4 (pp. 27–36) contains **no pseudodifferential operators, no microlocal
analysis, no Fourier analysis, no spectral theory, and no compactness arguments.** The complete
toolkit is itemized in §2. Every closed-form identity transcribed from the section is verified in
sympy (`disproof/record_audit.py` B8–B13, all PASS; one deliberately-false variant rejected).

## §1 — Computational basis

- Source: arXiv **1908.04958** (Tao, *Quantitative bounds for critically bounded solutions to the
  Navier-Stokes equations*), current version fetched 2026-06-10
  (`curl -sL https://arxiv.org/pdf/1908.04958`, 834 KB; working copies `/tmp/tao_1908.pdf`,
  `/tmp/tao_1908.txt` via `pdftotext`; §4 at extraction lines 2545–3791, PDF pp. 27–36).
- Verification artifact: `disproof/record_audit.py` (B8–B13 appended per the standing
  transcription-audit rule), run via `disproof/.venv/bin/python disproof/record_audit.py`
  — exit 0, all 18 checks (B1–B13) PASS.

## §2 — Findings: the complete §4 toolkit

§4 = **Lemma 4.1** (General Carleman inequality, cf. ESS Lemma 2) + **Proposition 4.2** (First
Carleman inequality; annulus; weight `g = α(T0−t)|x| + |x|²/C0T`; gain `e^{−r−r+/4C0T}`) +
**Proposition 4.3** (Second Carleman inequality; cylinder; log-Gaussian weight
`g = −|x|²/4(t+t1) − (3/2)log(t+t1) − α·log((t+t1)/(T0+t1)) + α(t+t1)/(T0+t1)`; gain
`e^{−r²/500t0}`). Tao notes the results are "essentially contained in [ESS2], [ESS]" made
quantitative — the ESS backward-uniqueness lineage.

The proofs use, exhaustively:

1. **Weighted time-dependent L² inner product** `⟨u,v⟩ = ∫ uv·e^g dx`, differentiation under the
   integral sign, and integration by parts (test functions compactly supported in space — no
   boundary terms).
2. **Symmetric/antisymmetric splitting**: `F := ∂tg − Δg − |∇g|²`; `S := Δ + ∇g·∇ − F/2` is the
   e^g-self-adjoint part of `L = ∂t + Δ`; the operator-algebra chain
   `∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩`; the commutator quadratic form
   `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)|u|²)e^g`; drop-the-square; FTC in time.
3. **Explicit weight calculus**: exact `F`, `LF`, and Hessian computations for the two weights
   (verified: B11a/b/c, B12a/b/c).
4. **Smooth cutoffs** with `|∇ʲψ| = O(·)` bounds (annulus and ball — the same bump technology as
   the Littlewood–Paley layer).
5. **Pigeonhole-in-time** (select a good time slice by averaging).
6. **Integrating-factor energy method** (Prop 4.3): define `E(t)`, product rule, differential
   inequality, FTC — elementary ODE manipulation, no Grönwall lemma needed.
7. **One elementary single-variable max inequality** `−a/t − b·log t ≤ b·log(b/(ae))` (B13).
8. **Region-wise exponential-weight comparisons and constant bookkeeping** — the bulk of the page
   count, and (per the De Giorgi–Nash–Moser calibration) the actual cost center of a
   formalization.

**Formalization divergence points** (where Lean will deviate from the paper's presentation):

- (i) Tao determines the zeroth-order coefficient of `[L,S]` by the trick `H = [L,S]1 = −½LF`,
  evaluating at `u ≡ 1` — not compactly supported. A formalization computes `[L,S]` directly in
  coordinates (a finite Leibniz computation; B8–B10 verify the surrounding identities).
- (ii) Lemma 4.1 hypothesizes `g` smooth on `[t1,t2] × R^d`, but Prop 4.2 applies it with
  `g` containing `α(T0−t)|x|` — not smooth at `x = 0` — under a cutoff vanishing near 0. The
  formal statement needs `g` smooth on a neighborhood of `supp(u)`.
- (iii) `∂t` under the integral needs an explicit dominated-convergence justification (easy with
  compact support).

## §3 — Verification

Evidence type: **algebraic** (sympy, exact symbolic) for the transcribed identities; **manual**
(full-text reading) for the no-heavier-machinery inventory.

- **B8** — the pointwise divergence identity behind Lemma 4.1's IBP step:
  `Δ(uv)e^g = div(∇(uv)e^g − uv·e^g∇g) + uv(Δg+|∇g|²)e^g`. PASS (generic u, v, g in 3 vars).
- **B9** — `(Su)v·e^g − u(Sv)·e^g = div((v∇u − u∇v)e^g)` for **arbitrary** F (the cancellation is
  structural). PASS.
- **B10** — `⟨Lu,Sv⟩+⟨Su,Lv⟩−2⟨Su,Sv⟩ = ½⟨Lu,Lv⟩ − ½⟨(L−2S)u,(L−2S)v⟩` (pure bilinear algebra).
  PASS.
- **B11a/b** — Prop 4.2's `F` and `LF` displays for `g = α(T0−t)r + r²/C0T` (d = 3):
  `F = −αr − 2αs/r − 6/C0T − α²s² − 4αsr/C0T − 4r²/C0²T²`,
  `LF = 2α²s + 4αr/C0T − 8αs/(C0Tr) − 24/C0²T²` (`s = T0−t`). PASS. (The pdftotext extraction of
  the LF display was garbled; the sympy recomputation **is** the check, and it matches the
  legible parts exactly.)
- **B11c** — `Hess(|x|) = (I − x̂x̂ᵀ)/|x|` (PSD; the convexity input giving `D²g ≥ (2/C0T)I`).
  PASS.
- **B12a/b/c** — Prop 4.3's `F = α/(T0+t1) − α/(t+t1)`, `LF = α/(t+t1)²`, and
  `D²g = −I/(2(t+t1))` exactly. PASS.
- **B13a/b** — the max inequality via critical point `t* = a/b`, value `b·log(b/(ae))`, and the
  deficit function `1/u − 1 + log u` with derivative `(u−1)/u²`, value 0 at `u = 1`, and `+∞`
  limits at both ends (unique global min ⇒ inequality). PASS.
- **False variant**: Prop 4.2's `LF` with the sign of the `8αs/(C0Tr)` term flipped — residual
  `16αs/(C0Tr) ≠ 0`, correctly REJECTED (one-off, not committed to the script).

## §4 — Spec impact

None — this is a citation/transcription audit (ladder-0), not new engine or program content. No
S-ID/NS-ID changes. It hard-verifies the §4 computations *of* the NS-008-adjacent citation at the
algebraic tier and fixes the formalization plan:

**Carleman ladder (next):** (1) Lemma 4.1's S/A-split + commutator chain as Lean operator algebra
(B8–B10 are its exact blueprint); (2) the weight calculus (B11/B12 as Lean lemmas); (3) Prop 4.2;
(4) Prop 4.3; (5) the backward-uniqueness wrapper. `:proved` = 0 for the PDE; distance to the
prize UNTOUCHED — these would be *library infrastructure plus citation verification*, not NS
theorems.
