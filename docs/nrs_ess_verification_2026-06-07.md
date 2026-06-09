# NRŠ + ESS originals line-read — both C2 → C3 (the two global no-go anchors)

**Date:** 2026-06-07. Line-read the two previously-paywalled/Russian originals to upgrade the two
remaining load-bearing-C2 global anchors. **Both promote to C3.** Foundation-hardening, NOT PDE progress;
`:proved`=0; distance UNTOUCHED.

---

## 1. Nečas–Růžička–Šverák, Acta Math. 176 (1996) 283–294 — **C2 → C3** (NS-007)

**Fetched** the genuine primary PDF via **Project Euclid open access** (Institut Mittag-Leffler; the
`journalArticle/Download?urlId=10.1007%2FBF02551584` endpoint), confirmed as the scanned Acta original
(pp. 283–294, © 1996 Institut Mittag-Leffler).

**Theorem 1 (p. 291):** a *weak* solution `U` of the profile equation
`−νΔU + aU + a(y·∇)U + (U·∇)U + ∇P = 0`, `div U=0` (`a>0`) **belonging to `L³(ℝ³)`** satisfies `U≡0`.
"Weak solution" = `U∈W^{1,2}_loc`, div-free, weak form against div-free `C_c^∞` (smooth by Stokes
bootstrap). **Hypothesis is exactly `L³`** — and the paper explicitly notes (p. 284, eq. 1.5) that
*purely local energy bounds do NOT imply `U∈L³`*, so it does **not** rule out locally-energy-bounded
self-similar singularities. **This confirms our records verbatim:** `L³` is faithful; the local-energy
strengthening is genuinely **Tsai's** (1998), correctly attributed.

**Proof mechanism (line-read):** auxiliary scalar **`H=½|U|²+P+a(y·U)`** (Lemma 3.3) satisfies an
elliptic max-principle inequality `LH ≤ 0`; the `L³` hypothesis forces decay
`|∇^kU|=O(|y|^{−3−k})`, `|∇^kP|=O(|y|^{−2−k})` (Lemma 3.2, via CKN ε-regularity) so `H=O(|y|^{−2})` ⇒
`H≤0` everywhere ⇒ the energy identity (`∫½|U|²≤0`) ⇒ `U≡0`. Matches the `Π`-functional mechanism we'd
recorded.

**Minor terminology note:** NRŠ's ansatz (`a>0`) is the finite-time-blowup profile they call a
"self-similar singularity"; the now-standard adjective "**backward** self-similar" is a downstream
convention (Tsai et al.). The substance — *the only `L³` self-similar blowup profile is trivial* — is
exactly Theorem 1. Our "no nontrivial backward self-similar in `L³`" is correct in substance.

**[CORRECTION 2026-06-08 — symbolic disproof probe, `docs/disproof_probes_2026-06-08.md`.]** This doc
originally recorded the Lemma-3.3 identity as `−νΔH+(U·∇)H = −ν|∇U+aI|²+ν(∂_iU_j)(∂_jU_i)`. A sympy check
(substituting the profile eq for `ΔU`, pressure-Poisson for `ΔP`, `div U=0`) found that **false as written**
— it (i) **drops the `a(y·∇)H` self-similar drift** and (ii) has an RHS **off by `+3νa²`**. The
**verified-correct identity** is
`−νΔH + (U·∇)H + a(y·∇)H = −ν Σ_{i<j}(∂_iU_j−∂_jU_i)² = −ν|∇U|²+ν(∂_iU_j)(∂_jU_i) ≤ 0`. The error was in
**this transcription only**; both RHS forms are `≤0`, so NRŠ Thm 1 and its `LH≤0` max-principle chain are
**unaffected**. (Re-check NRŠ Lemma 3.3 verbatim for full certainty on the original wording.)

**Tier: C3 (proof line-read, primary Acta PDF; H-identity transcription corrected 2026-06-08).**

---

## 2. Escauriaza–Seregin–Šverák, Russ. Math. Surveys 58 (2003) 211–250 — **C2 → C3** (NS-005)

**Fetched two authentic artifacts:** (i) the authors' **verbatim English version** ("On L_{3,∞}-Solutions
to the Navier–Stokes Equations and Backward Uniqueness," ESS, UMN Conservancy DSpace handle 11299/3858) —
fully readable, **proof line-read**; (ii) the **published RMS PDF** (mathnet.ru `rm609`) — prose is
legacy-font mojibake, so **rendered to image and read visually** for title/abstract/space/TOC. The two are
identical section-for-section (§1 Intro, §2 suitable weak solutions, §3 proof, §4 unique continuation, §5
backward uniqueness half-space, §6 Carleman, §7 appendix).

**Endpoint space CONFIRMED: `L_{3,∞}` (weak-`L³`/Lorentz), not `L³`.** Published title:
"L_{3,∞}-solutions of the Navier–Stokes equations and backward uniqueness"; abstract: "L_{3,∞}-solutions
… are smooth." **Theorem 1.3:** a Leray–Hopf solution with `ess sup_t ‖v(t)‖_{L_{3,∞}(ℝ³)}<∞` (cond.
1.13) on `[0,T)` is smooth — i.e. the spatial `L³`-norm must blow up at any singular time. (Theorem 1.4 =
the local interior-Hölder version ⇒ 1.3.)

**Proof structure (line-read):** §3 reduces regularity to backward-uniqueness/unique-continuation; assume
a singular point, take a **blow-up sequence `λ_k→0` → an ancient limit** solving NS with linear
lower-order terms; the rescaled **vorticity is killed by unique continuation** (Thm 4.1). §4 **unique
continuation** (Thm 4.1: `|∂_tw+Δw|≤C(|w|+|∇w|)` + infinite-order zero ⇒ `w≡0`). §5 **backward uniqueness**
in the half-space (Thm 5.1: `+ w(·,0)=0 +` Gaussian growth ⇒ `w≡0`). §6 the two **Carleman inequalities**
(Props 6.1, 6.2). All present exactly as we'd characterized. Notably the **original uses a
blow-up/compactness step** — distinguishing it from Tao's (2019) quantitative-Carleman-only re-proof.

**Tier: C3 (proof line-read via the authors' verbatim English version; published-RMS metadata —
title/`L_{3,∞}` space/TOC — visually confirmed).** This is the **endpoint RMS paper**, not the ARMA
backward-uniqueness tool-paper (not needed; the endpoint paper's §5–§6 contains the backward-uniqueness +
Carleman machinery).

---

## 3. Tier upgrades + net effect on the load-bearing C2s

- **NS-007 (NRŠ): C2 → C3.** **NS-005 (ESS): C2 → C3.** (Tsai already C3; together the self-similar
  no-go and the critical-endpoint anchor are now C3 at primary source.)

**Net — the five load-bearing global anchors are now essentially C3 throughout:**
- **NS-002 supercriticality** — self-derivable (the program's own NS-034 scaling calculus; C3-equivalent).
- **NS-005 ESS** — **C3** (this pass).
- **NS-006 CKN** — C2 *statement* (mainstream; the C1 `ε₀` constants are **unused** by any conclusion);
  used qualitatively. The only remaining load-bearing C2, and it is de-risked (statement-only need).
- **NS-007 NRŠ** — **C3** (this pass).
- **NS-008 Tao averaged-NS** — blowup result C3; the no-go *scope* C2 (Tao's own framing).

**So no program conclusion now rests on an un-corroborated, un-line-read C2.** The obstruction manifold's
load-bearing foundation is C3 (or self-derivable / mainstream-statement) end to end. `:proved`=0.

---

## 4. Sources + flags

**Verified (C3, primary, line-read):**
- NRŠ — Project Euclid open-access Acta PDF (`10.1007/BF02551584`), `pdftotext -layout`; Thm 1 (p.291),
  Lemmas 3.1–3.3, eq. (1.5).
- ESS — authors' verbatim English version (UMN Conservancy handle 11299/3858), proof §3–§6 read; published
  RMS PDF (mathnet.ru `rm609`) title/abstract/space/TOC confirmed by visual render.

**Flagged:** the ESS *proof text* was read from the authors' verbatim English version (same authors, same
section/equation numbering as the published RMS); the published RMS prose itself is not machine-extractable
(legacy Cyrillic fonts), so the metadata was confirmed visually rather than by text extraction. The ARMA
companion ("Backward uniqueness for parabolic equations," 2003) was not opened (not needed — its machinery
is in ESS §5–§6). NRŠ OCR has mangled accents (scanned original) but the mathematics extracted cleanly.
