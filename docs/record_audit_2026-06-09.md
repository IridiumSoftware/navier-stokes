# Systematic record-audit — every transcribed closed-form identity, symbolically checked

**Date:** 2026-06-09. Triggered by the NRŠ H-identity catch (`docs/disproof_probes_2026-06-08.md`): one
human-transcribed identity in our record was false, so **sweep all of them**. Script:
`disproof/record_audit.py` (sympy 1.14.0). **Citation/record verification, not PDE progress; `:proved`=0;
distance UNTOUCHED.**

**Verdict: ALL 7 remaining transcribed identities VERIFIED — the NRŠ error was the only false
transcription in the record.**

## 1. Scope

Three classes of closed-form claims in our docs/SPEC:
- **Already machine-verified** (before this audit): the Rung-0 scaling-criticality calculus; the Rung-1
  axisymmetric structural calculus (Γ source-free, Ω source `S`, `(3/r)∂_r` transform, Biot–Savart,
  pressure elimination) — 4 layers each; the **NRŠ Π-identity** (probe-corrected + verbatim-confirmed).
- **This audit (B1–B7):** every remaining transcribed closed-form identity found by grep sweep of the
  NS-048/NS-046/machinery docs + SPEC.
- **Out of scope for this instrument:** inequalities and asymptotics (Carleman, CKN ε-regularity,
  Gagliardo–Nirenberg, rate bounds, decay estimates) — not closed-form; they remain at their C-tiers.
  Integral identities reduce to the pointwise cores checked here modulo integration by parts
  (boundary-term caveats live with the analysis, not the algebra).

## 2. Checks (all PASS)

| # | Identity | Recorded at | Method |
|---|---|---|---|
| B1 | `G=∂_zΓ`: `∂_tG+b·∇G = νL_ΓG − [(∂_zu^r)∂_rΓ+(∂_zu^z)G]` | `ns048_swirl_sign_condition_attack.md` (C-ii) | `∂_z` of the Γ-equation, generic `Γ,u^r,u^z(r,z,t)` — the recorded bracket (incl. signs) is exactly right |
| B2 | `L_Γ(r²u₁) = r²(∂_r²+(3/r)∂_r+∂_z²)u₁` (the 4-D radial-heat substitution) | same doc, §4 sharpened note | operator identity on generic `u₁` |
| B3 | `Δ_axi − (2/r)∂_r = L_Γ` — the frontier doc's `∂_tΓ+b·∇Γ+(2/r)∂_rΓ−ΔΓ=0` form ⇔ the `νL_Γ` form | `ns048_swirl_source_frontier.md:37` | operator identity (the two docs' Γ-equation forms are consistent) |
| B4 | `div(momentum) = Δp + ∂_iu_j∂_ju_i` ⇒ pressure-Poisson `−Δp=∂_iu_j∂_ju_i` | `ns046_target.md:27` | generic polynomial `u=curl A` (div-free identically) + generic `p` |
| B5 | `curl(momentum) = ∂_tω+(u·∇)ω−(ω·∇)u−νΔω` (3D vorticity equation; `∇p` drops) | `ns048_machinery_study.md:286` | same instance; *note:* the doc writes `ν=1` (normalization, fine) |
| B6 | `ωᵀ(∇u)ω = ωᵀSω`, `S=sym∇u` (the production algebra behind `P=∫ω·Sω=∫|ω|²(ξ·Sξ)`) | SPEC NS-036 / `ns046_target.md` | generic 3×3 matrix + vector; antisymmetric part annihilates |
| B7 | rescaling covariance `NSop(u_λ,p_λ)(x,t)=λ³·NSop(u,p)(x₀+λx,T+λ²t)`, `u_λ=λu(x₀+λx,T+λ²t)`, `p_λ=λ²p(·)` — the **M1 cornerstone** under every blow-up argument | `ns048_machinery_study.md:43` | generic polynomial instance; exact in `λ` |

Generic-instance philosophy (B4/B5/B7): polynomial fields with ~12 free coefficients per component,
`u=curl A` so `div u≡0` by construction — same standard as the Rung-1 Laurent checks; the identities are
low-degree multilinear in `(u,p)`, so a generic polynomial instance closing exactly is decisive.

## 3. Net

- **Record integrity after the sweep:** every closed-form identity in the program's record is now
  machine-checked (Rungs 0–1 + NRŠ probe + this audit). **One error total was found across the entire
  record (NRŠ; corrected + verbatim-confirmed); everything else closes exactly.**
- The audit cost ~1 script; the NRŠ catch demonstrates the failure mode is real, and this sweep bounds it:
  no other transcription of that class is wrong.
- **Standing rule going forward:** any *new* closed-form identity transcribed into the record from a cited
  paper gets a symbolic check at transcription time (add to `disproof/record_audit.py`), before it is
  cited by an attack or synthesis. Cheap (minutes), and it is the exact failure mode we've now seen once.

`:proved`=0; distance UNTOUCHED.
