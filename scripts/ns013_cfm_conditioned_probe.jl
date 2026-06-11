#!/usr/bin/env julia
# ns013_cfm_conditioned_probe.jl — NS-013, the surviving reduction's CLAIM 2 (the CFM/Hou–Li mechanism).
#
# CONTEXT. NS-013's original complex⇏real obstruction-map was triad-REFUTED + withdrawn. The surviving
# `:argued` reduction: reality's protective direction reduces to the EMERGENT GEOMETRIC depletion —
# the Constantin–Fefferman conditional criterion (the vorticity DIRECTION ξ=ω/|ω| regular where |ω| is
# large ⇒ no blowup; Hou–Li alignment). Claim 1 (production = phase-coherence object) is DONE
# (`ns013_phase_production_3d`: scramble kills 97–99% of ∫ω·Sω). Claim 2 — the CFM mechanism's LOCAL
# content — is what this probes: in the intense-vorticity cores (where CFM regularity is decided), is
# ξ SMOOTH (|∇ξ| controlled ⇒ CFM-regular, geometric depletion active) or does it ROUGHEN — and is the
# answer N-stable or a resolution artifact (the NS-039 D30 pattern: a ≤-threshold that lifts with N)?
#
# FIREWALL. Scope: resolved 3D pseudospectral DNS truncation (Kerr-tube worst case). :proved=0; distance
# UNTOUCHED. The CFM criterion is a CONDITIONAL (sufficient, unproven for general data) regularity
# theorem; a regular truncation has NO singular set, so ξ-smoothness here is a WITNESS of where the
# geometry sits, NEVER a statement that the criterion holds in the limit. The N-trend is the only part
# that bites (a core that roughens with N is the dangerous signature; one that stabilizes is benign-in-truncation).
#
# Reuses the gradxi/NS-045 machinery (solver, ICs, ξ & ∇ξ). Run: julia -t auto scripts/ns013_cfm_conditioned_probe.jl

using Printf, LinearAlgebra, Statistics
include(joinpath(@__DIR__, "ns046_gradxi_pressure_probe.jl"))   # machinery (guarded main); → ns045 solver + ICs

# per-point vorticity-direction smoothness |∇ξ|² and |ω|, from the velocity-Fourier state
function cfm_pointwise(U, op)
    ωxh,ωyh,ωzh = curl_hat(U[1],U[2],U[3],op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    wmag = sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2) .+ 1e-12
    ξx=ωx./wmag; ξy=ωy./wmag; ξz=ωz./wmag
    g2 = zeros(size(ωx))
    for ξh in (fft3(ξx), fft3(ξy), fft3(ξz))
        g2 .+= real.(ifft3(im.*op.kx.*ξh)).^2 .+ real.(ifft3(im.*op.ky.*ξh)).^2 .+ real.(ifft3(im.*op.kz.*ξh)).^2
    end
    vec(g2), vec(wmag .- 1e-12)
end

# run TUBES (Kerr worst case) to the enstrophy peak at resolution N; return |∇ξ|² and |ω| at the peak
function peak_fields(N, ν, T, dt)
    op=make_ops(N); U=vortex_tube_ic(N,op)
    t=0.0; Zpk=0.0; Upk=U
    while t<=T+1e-9
        d=diagnose(U,op,N); d.Z>Zpk && (Zpk=d.Z; Upk=deepcopy(U))
        U=rk4(U,dt,ν,op); t+=dt
    end
    g2,w = cfm_pointwise(Upk,op)
    (g2=g2, w=w, Z=Zpk, N=N)
end

# conditioned CFM diagnostics on top-q |ω| sets
function conditioned(g2, w)
    sw=sort(w; rev=true); thr(q)=sw[clamp(round(Int,q*length(sw)),1,length(sw))]
    rows=NamedTuple[]
    for q in (1.0,0.10,0.01,0.001)
        m = w .>= thr(q)
        mean_g2 = mean(@view g2[m])                       # ⟨|∇ξ|²⟩ on the set
        cfm_dens = sum(g2[m].*w[m])/sum(w[m])             # enstrophy-weighted ⟨|∇ξ|²⟩ (the CFM density)
        push!(rows,(q=q, mean_g2=mean_g2, cfm_w=cfm_dens))
    end
    rows
end

function main()
    out="scripts/ns013_cfm_conditioned_probe.out.txt"; fo=open(out,"w"); pr(a...)=(println(stdout,a...);println(fo,a...))
    ν=1/1600; T=6.0
    pr("="^78); pr("  NS-013 CLAIM 2 — is the vorticity DIRECTION ξ smooth in the intense cores? (CFM mechanism)")
    pr("  |∇ξ|² conditioned on top-q |ω|, Kerr-tube peak. Scope: resolved DNS truncation; :proved=0."); pr("="^78)
    # CPU does the conditioned read at N=64; the N-TREND is GPU work (this program's convention — see NS-039 /
    # step2_gate at N=256↔512 via metal/dns_gpu.swift). N=128 on a uniform CPU grid is impractically slow here.
    f = peak_fields(64, ν, T, 0.01)
    rows = conditioned(f.g2, f.w)
    pr(@sprintf("\n  N=64  (enstrophy peak Z=%.3f)", f.Z))
    pr("    top-q |ω|     ⟨|∇ξ|²⟩      enstrophy-wtd ⟨|∇ξ|²⟩ (CFM density)")
    for r in rows
        pr(@sprintf("    %6.1f%%      %10.4f    %10.4f", 100r.q, r.mean_g2, r.cfm_w))
    end
    core = rows[end].cfm_w; bulk = rows[1].cfm_w
    pr("\n"*"="^78); pr("  WITNESS READING (vacuity-capped — NOT the inequality)"); pr("="^78)
    pr(@sprintf("  • Core vs bulk: ⟨|∇ξ|²⟩_w  top-0.1%% = %.1f  vs  full = %.1f  (ratio %.2f)", core, bulk, core/bulk))
    pr("    ⇒ ξ-roughness " * (core > 1.2*bulk ? "CONCENTRATES in the cores (the dangerous direction — ξ roughens where |ω| peaks)." :
                                                  "does NOT concentrate in the cores — ξ is comparatively SMOOTH where |ω| peaks (CFM-regular-leaning;" *
                                                  "\n      consistent with NS-038's c²_int≈0.72 Hou–Li alignment — the cores are geometrically organized)."))
    pr("  • N-TREND (the part that actually bites) — DEFERRED TO GPU. Whether the core ξ-geometry is N-STABLE")
    pr("    (benign-in-truncation) or LIFTS with resolution (the dangerous NS-039 D30 pattern) cannot be settled")
    pr("    on a uniform CPU grid; it needs N=256↔512 (metal/dns_gpu.swift). At N=64 alone this is a")
    pr("    single-resolution witness of WHERE ξ-roughness sits — vacuity-capped, not the limit.")
    pr("  • FIREWALL: the CFM criterion is CONDITIONAL/unproven for general data; this witnesses WHERE ξ-roughness")
    pr("    sits in a resolved flow, it does NOT establish (or refute) the criterion. NS-013 stays :open. :proved=0.")
    pr("="^78); close(fo); println(stdout,"\nwrote: $out")
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
