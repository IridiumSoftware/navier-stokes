# Companion — does the hard layer touch C_K or C_ε? (a touchability ranking)

**2026-06-02.** The hard-vs-frame-dependent test (after `mu_hard_bound.jl`) applied to the
**Kolmogorov constant `C_K`** (spectral amplitude) and the **dissipation anomaly `C_ε`**
("zeroth law"). Result: a clean **ranking** of how far NS's rigour reaches. Refines
**NS-037(c)**. Scope: empirical phenomenology + exact 4/5 + realizability + the Doering–Foias
bound. NOT the PDE; `:proved`=0; anti-anchoring kept (measured values used only as a final note).

## §1 — Computational basis

- **Source (new):** `scripts/kolmogorov_dissipation_hard_test.jl` (+ `.out.txt`). Std-lib
  Julia (`Printf`, `Random`). Reuses the admissible-spectrum machinery of `mu_hard_bound.jl`.
- **Definition of "touched":** a constant is touched by the hard layer iff it appears in an
  EXACT relation (the 4/5 law), a REALIZABILITY bracket (monotone+concave ζ_p with ζ_3=1),
  or a RIGOROUS NS INEQUALITY (the energy balance).
- **Run:** `julia scripts/kolmogorov_dissipation_hard_test.jl`.

## §2 — Results

**C_K (Kolmogorov constant), `E(k)=C_K ε^{2/3} k^{−(1+ζ_2)}` — split slope vs amplitude:**
- *Slope* `−(1+ζ_2)`: the hard layer **brackets** `ζ_2 ∈ [2/3, 1]` — concavity-above-chord
  gives `ζ_2 ≥ (2/3)ζ_3 = 2/3` (K41 floor), monotonicity gives `ζ_2 ≤ ζ_3 = 1` (ceiling).
  Tight (K41 extremal saturates 2/3 ⇒ slope −5/3; front-loaded extremal saturates 1 ⇒ slope
  −2; 8000-sample random admissible search lands inside). Measured `ζ_2≈0.70` ⇒ slope ≈−1.70,
  just off the K41 floor. **The slope is touched.**
- *Amplitude* `C_K`: **not touched.** The only exact law is the 4/5 law — a *third-order*
  relation (it pins the ζ_3 amplitude to exactly −4/5). No exact law at second order;
  realizability bounds exponents, not amplitudes. Only `C_K>0` holds. The value (≈1.6) is
  **purely frame-dependent** — worse than μ (which at least has the [0,1] bracket).

**C_ε (dissipation anomaly), `C_ε = εL/u'³` — three tiers:**
- `C_ε ≥ 0`: trivial (`ε = ν⟨|∇u|²⟩ ≥ 0`).
- `C_ε < ∞`: **RIGOROUS** — the Doering–Foias–Constantin upper bound from the NS energy
  balance + Poincaré: `C_ε ≤ c_1/Re + c_2`, so `C_ε ≤ c_2 < ∞` as Re→∞. The *form* is
  frame-independent (a theorem); the constant `c_2` is forcing-geometry-dependent. **This is
  the one turbulence "constant" NS bounds rigorously.**
- `C_ε > 0`: **EMPIRICAL** (the zeroth law) — not proven. It is the statement that the
  cascade is real (`ε` survives `ν→0`), equivalently that the 4/5 law's RHS `−⅘εr` is
  nonzero; tied to Onsager (NS-009); proving it = proving anomalous dissipation occurs (open).
- So `C_ε ∈ (0, c_2]`: upper end rigorous, lower end empirical, value ≈0.4–0.5 frame-dependent.
  **Partially touched — the most-touched of `{C_K, μ, C_ε}`.**

**The ranking (the discriminating finding):**

| constant | what the hard layer gives | kind |
|---|---|---|
| C_ε (dissipation rate) | rigorous **upper bound** (Doering–Foias) | NS energy-balance inequality |
| ζ_2, μ (exponents) | realizability **brackets** [2/3,1], [0,1] | monotone+concave+ζ_3=1 |
| C_K (amplitude) | only C_K>0 — **no bound** | purely frame-dependent |

**Principle:** NS's rigorous reach extends to (i) the third-order exponent *exactly* (the 4/5
law), (ii) the lower-order *exponents* by realizability brackets, and (iii) the *dissipation
rate* by the energy-balance inequality — but **not** to spectral *amplitudes*. "Touchability"
tracks whether a constant appears in a rigorous NS relation. `C_K` does not; `C_ε` does.

## §3 — Verification

**Type — algebraic + computed.**
- *Exact / algebraic:* the `ζ_2 ∈ [2/3,1]` bracket (concavity-above-chord + monotonicity,
  with `ζ_3=1`); the Doering–Foias bound *form* `C_ε ≤ c_1/Re + c_2` (cited theorem; the
  geometry constant is not re-derived hermetically); `C_K>0` and the absence of any exact
  2nd-order law.
- *Computed:* the two `ζ_2` extremals (K41 ⇒ 2/3, front-loaded ⇒ 1) are admissible and
  saturate the bracket; an 8000-sample random admissible ensemble stays inside [2/3,1].
- *Anti-anchoring:* measured `C_K≈1.6`, `C_ε≈0.5`, `ζ_2≈0.70` entered only as a final
  convergence note; no bound was tuned to them.

**Honest limits.** (i) The Doering–Foias constant `c_2` is forcing-geometry-dependent — the
rigour is in the *existence* of a finite Re-independent bound, not a universal number.
(ii) `C_ε > 0` (the anomaly itself) is the unproven zeroth law — stated as empirical, not
structural. (iii) Nothing here touches the PDE regularity problem.

## §4 — Spec impact

**Refines NS-037(c)** (no new entry): the prior "frame-dependent (μ, C_K, κ, C_ε)" lumping
was too coarse — `C_ε` is *not* purely frame-dependent (rigorous Doering–Foias upper bound),
and exponents are bracketed. Updated NS-037 to carry the touchability ranking + the principle.
Per the conjunctive-claim rule, NS-037 stays `:argued`; this adds the test + documents the
refinement. Source/companion added to the NS-037 row.

*Firewall: empirical phenomenology + exact 4/5 + realizability + the Doering–Foias bound; not
the PDE; `:proved`=0. Methodology: closure-v5 `inverse_born_methodology.md`. Metabolized by
Claude, 2026-06-02.*
