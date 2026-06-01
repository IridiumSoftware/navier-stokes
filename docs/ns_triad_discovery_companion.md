# Companion — TCE TriadDiscovery on the NS obstruction program

**2026-06-01.** "Run the TCE so we're fully prepped before 3D." This is the
pre-3D structural reconnaissance: feed the NS obstruction ledger (SPEC.md
NS-001..030) to the Triadic Coordination Engine's discovery component as a
corpus, and read off the **triadic coordination structure of the program
itself** — which obstructions/diagnostics/results cohere into stable triples —
to focus the 3D attack (NS-010 Stage 1c-3D). **This is a map of our own
program, not a PDE result. Distance to the prize: UNTOUCHED.**

---

## §1 — Computational basis

**Engine.** `triadic-coordination-2.0.0` in the TCE repo
(`~/Desktop/triadic-coordination-engine`), the `Discovery.Triadic` component
reached via the `SpecBridge` JSON adapter and driven by the
`triadic-coordination-runonspec` test-suite. Toolchain: GHC 9.6.7,
cabal 3.14.2.0. The engine is **corpus-agnostic**: it enumerates unordered
triples over an anchor set, keeps those where all three pairwise edges satisfy
the similarity relation R and the triple is not subsumed (`isAlreadyCollapsed`),
scores survivors by the mean of their three pairwise Jaccard indices, and ranks.

**R (the edge predicate), verbatim from `SpecBridge.areRelated`:** two entries
are related iff
1. **layer-adjacent** — `|layer_a − layer_b| ≤ 2`;
2. **tier-compatible** — same `logic` tier, *or* one endpoint is `bridge`;
3. **Jaccard on transitive premises ≥ 0.40** — `jaccardOnDeps` over the BFS
   closure of `deps` (each entry's own name and the other endpoint deleted, so a
   descendant doesn't score 1.0 against an ancestor).

**Corpus.** `discovery/ns_obstruction_corpus.json` (20 entries, this repo). The
encoding is faithful to `SPEC.md`:

- **`deps`** = the genuine logical premises read off the SPEC prose. E.g.
  NS-005 → `[NS-002, NS-003]` ("reduces regularity to controlling a *critical*
  norm [NS-002] … for Leray solutions [NS-003]"); NS-008 → `[NS-002, NS-003]`
  ("no proof can use *only* the energy identity [NS-003] + scaling [NS-002]");
  NS-010 → `[NS-004]` (δ(t)↔BKM); NS-011 → `[NS-010]`; NS-012 →
  `[NS-011, NS-007]` (complex blowup succeeds where the real self-similar path
  is dead); NS-013 → `[NS-012, NS-010]`; NS-023 → `[NS-021, NS-022]`;
  NS-024 → `[NS-023, NS-009]`; NS-025 → `[NS-023]`; NS-030 → `[NS-001, NS-024]`.
- **`layer`** = depth in the program: problem 0; foundational obstructions 1
  (NS-002/003/004); regularity-criteria/no-go 2 (NS-005..009, NS-020/021);
  diagnostics/closure-arc 3–4; live frontier / method 5.
- **`logic` tier** carries the **Scope firewall** structurally:
  `classical` = the PDE-analysis domain (NS-001..013, NS-020);
  `other:closure` = the closure/turbulence-model arc, a *separate domain*
  (NS-021/022/023/025); `bridge` = **NS-024 and NS-030 only** — the witnessed
  convergence and the methodology, the *only* entries permitted to link the two
  domains. By R's tier rule, a `classical`↔`other:closure` edge can exist
  *only* through a `bridge` endpoint.
- **`status: proved_conditional` on every entry** is the engine's
  **anchor-eligibility flag only** (the engine forms triples from `isProved`
  anchors). It reads "established *within its declared Scope/condition*"
  (external theorems are proved in the literature; our diagnostics are
  tested-in-model; the problem/conjectures are conditionally posed). **It is
  wholly decoupled from the SPEC.md PDE-proof firewall, where `:proved`
  (unconditional, Scope: PDE) remains 0.** No SPEC.md/registry status is
  altered by the corpus file. Runs pass `FILTER_PROVED_ONLY=0`.

**Invocation** (reproducible; full log `discovery/ns_triad_discovery.out.txt`):

```
SPEC_JSON=discovery/ns_obstruction_corpus.json \
  FILTER_PROVED_ONLY=0 MIN_LAYER_SPREAD=0 MIN_KINDS=1 FILTER_DEDUP=0 TOP_N=64 \
  cabal run triadic-coordination-runonspec        # View A: full map
# View B: drop FILTER_DEDUP=0  (edge-disjoint dedup → independent units)
# View C: MIN_LAYER_SPREAD=2 MIN_KINDS=2           (engine-default cross-domain)
```

The runner's `MIN_LAYER_SPREAD`/`MIN_KINDS` are closure-v5 "cross-domain proxy"
filters tuned for a several-hundred-entry corpus; for a 20-node program they are
relaxed (`0`/`1`) for the structural map (Views A/B) and left at default for the
bridge view (C).

---

## §2 — Results

The engine returns **64 triads** over the 20 nodes. Edge-disjoint dedup
(greedy by score) collapses them to **10 independent coordination units**:

| # | Triad | Score | Reading |
|---|---|---|---|
| 1 | **NS-002 · NS-003 · NS-004** | **1.000** | **The keystone obstruction triad.** Supercriticality + energy-only-coercivity + BKM vortex-stretching — the three foundational walls hanging directly off the problem (NS-001). The tightest coordination unit in the program. |
| 2 | NS-002 · NS-007 · NS-009 | 1.000 | The pure-scaling cluster: supercriticality + no-self-similar + Onsager 1/3 (all rooted in the scaling symmetry, no energy term). |
| 3 | **NS-023 · NS-024 · NS-025** | **1.000** | The closure-arc unit, mediated by the bridge: the (M,R) gate + the witnessed convergence + Gosme's external operationalization. **Tier-isolated from the PDE side.** |
| 4 | NS-005 · NS-006 · NS-008 | 0.778 | The Leray-energy regularity cluster: critical-norm regularity + CKN partial regularity + Tao's energy-only no-go (all share {NS-002, NS-003}). |
| 5 | NS-005 · NS-007 · NS-020 | 0.778 | Critical-norm + no-self-similar + the **falsified** homological approach — NS-020 sits in this neighborhood precisely because it is rooted at NS-002 (the norm) and could see nothing past it. |
| 6 | NS-008 · NS-009 · NS-020 | 0.778 | Tao no-go + Onsager + falsified homology. |
| 7 | **NS-011 · NS-012 · NS-013** | **0.700** | **The complex-plane attack triad** — the live frontier: complex-singularity tracking + Li–Sinai complex-data blowup + the open real⇐complex conjecture. |
| 8 | NS-022 · NS-024 · NS-030 | 0.700 | Helical-triad model + bridge + the program method. |
| 9–10 | NS-003·NS-005·NS-009; NS-003·NS-007·NS-008 | 0.556 | Lower-coherence energy/scaling residue. |

**The cross-domain bridge view** (View C, engine-default filters) surfaces the
one PDE-side bridge worth naming:

- **NS-003 · NS-004 · NS-010 @ 0.833** — energy-control + BKM + the
  analyticity-strip diagnostic: the link from *what the walls are* (NS-003/004)
  *up to the tool we are building* (NS-010). This is the bridge the 3D step
  must honor: a 3D δ(t)→0 is only meaningful if it **co-moves with BKM
  (NS-004)** under the energy budget (NS-003).
- NS-023 · NS-024 · NS-030 @ 0.944 (the closure-arc method bridge); NS-022 ·
  NS-025 · NS-030 @ 0.652.

**The firewall is reproduced, not assumed.** A programmatic scan of all 64
triads finds **zero** that mix the `classical` (PDE-analysis) tier with the
`other:closure` tier. The bridge NS-024 has exactly **one** pairwise cross-tier
edge — to NS-009 (Onsager, Jaccard exactly 0.40) — and it **never closes into a
triangle** (NS-024 relates to no second classical node; NS-030 relates to no
classical node at the 0.40 threshold). This is an *independent* structural
reproduction of NS-024's externally-witnessed verdict — "the closure↔turbulence
convergence is broad/generic, with no analytic purchase on the PDE" — now
delivered by the discovery engine rather than by the witness panel.

**Two collapse facts** (the novelty filter doing its job):
- {NS-010, NS-011, NS-012} is **absent** — it is subsumed by NS-013, whose
  premise-closure contains all three. The open conjecture NS-013 already
  "contains" the complex-diagnostic triple; the surviving live triad is
  {NS-011, NS-012, NS-013}.
- NS-001 (root) and NS-021 (MFE phenomenology) appear in **no** triad. NS-001
  is the universal premise (Jaccard 0 against everything). NS-021 is the most
  *isolated* substantive node: it roots only at NS-001 and is tier-walled from
  the PDE side — honest, the 9-mode model is the least-connected piece of the arc.

---

## §3 — Verification

**Type / evidence.** `computed` (the engine ran; output is deterministic and
reproducible from the committed corpus + the run log). The result is a
**structural map of the program's own dependency graph**, not a statement about
the Navier–Stokes PDE.

- *What the numbers are:* score = mean of three pairwise Jaccard indices on
  transitive premises; an edge requires layer-adjacency (≤2), tier-compatibility,
  and Jaccard ≥ 0.40. All thresholds are `SpecBridge.defaultSimilarityConfig`,
  unmodified.
- *Reproduction:* `discovery/ns_obstruction_corpus.json` +
  `cabal run triadic-coordination-runonspec` with the env vars in §1; full
  transcript in `discovery/ns_triad_discovery.out.txt`.
- *Sanity:* hand-computed top triads ({NS-002,003,004}@1.0;
  {NS-011,012,013}@0.7; the {005,007,008,009}-cluster@0.778) match the engine
  output exactly; the firewall scan returns empty.

**Scope: methodology.** This maps the obstruction program. **It is not, and
cannot become, PDE progress** — there is no PDE theorem here, only a graph over
our own ledger. `:proved` count unchanged (0).

**Honesty notes.**
- The corpus `status` field is repurposed as an anchor flag (§1); flagged
  loudly there and in the JSON `_note`. Anyone re-reading must not mistake
  `proved_conditional` in the corpus for a `:proved` SPEC status.
- The high scores among the layer-2 classical cluster (1.000 for triads sharing
  only {NS-002} or {NS-001}) are partly an artifact of *shallow* shared
  premises — a pair whose only common ancestor is a single root scores Jaccard
  1.0. The *structure* (which nodes cohere) is the signal; the exact decimal is
  not a precision instrument. Reported as a map, not a ranking to be over-read.

---

## §4 — Spec impact

Proposed entry (PROGRAM class, methodology Scope):

- **NS-031 — The program's own triadic coordination structure (TCE self-map).**
  Running TCE's `Discovery.Triadic` on the NS obstruction ledger yields a stable
  triadic structure: the keystone obstruction triad {NS-002, NS-003, NS-004};
  the live complex-plane attack triad {NS-011, NS-012, NS-013}; the
  energy/scaling clusters; and a tier-walled closure arc whose only links to the
  PDE side run through the bridges NS-024/NS-030 and never close a cross-domain
  triangle (reproducing NS-024's witnessed verdict). Used to focus the 3D step
  (Stage 1c-3D): coordinate the analyticity-strip diagnostic (NS-010) with BKM
  (NS-004) against the supercriticality wall (NS-002), and track the complex
  singularity (NS-011) toward the real axis (NS-012/013).
  - Evidence: computed. **Status: :tested. Scope: methodology (program self-map
    — NOT the PDE).**
  - Depends_on: NS-030 (the method), and structurally references all of
    NS-001..025.
  - Source: `discovery/ns_obstruction_corpus.json`,
    `discovery/ns_triad_discovery.out.txt`, this companion.

**The actionable takeaway for 3D.** The discovery confirms the attack geometry
the program already pointed at: the 3D escalation should be built as the triple
**(NS-002 wall) — (NS-004 BKM / NS-010 strip) — (NS-011 complex singularity)**,
because (a) {NS-002, NS-003, NS-004} is the keystone the proof must coordinate,
(b) {NS-003, NS-004, NS-010} is the bridge from the walls to our validated tool,
and (c) {NS-011, NS-012, NS-013} is the live frontier where blowup is *known* to
exist (complex data) and the open question is whether the singularity reaches
the real axis. Everything in the closure arc remains, by the engine's own
structure, off to the side of the PDE.
