#!/usr/bin/env julia
# ns013_cfm_gpu_trend.jl — the GPU-deferred N-trend for NS-013's CFM-conditioned witness
# (+ the NS-049 δ_Λ ride-along), from metal/dns_gpu.swift spectral snapshots at N=256↔512.
#
# QUESTION (NS-013, claim-2 witness): at N=64 the vorticity-direction roughness ⟨|∇ξ|²⟩_w was
# LOWER in the intense cores than the bulk (top-0.1% 212 vs full 369, ratio 0.57 — ξ smoother
# where |ω| peaks, CFM-regular-leaning). Does that CORE/BULK RATIO persist under refinement
# (benign-in-truncation) or LIFT toward/past 1 (the NS-039 D30 artifact pattern)? The raw
# ⟨|∇ξ|²⟩ values grow with N (more resolved gradients) — the N-comparable objects are the
# DIMENSIONLESS core/bulk ratio and the conditioning PROFILE shape, not the raw numbers.
# RIDE-ALONG (NS-049): δ_Λ = 1 − λmax(M)/tr(M), M = Σ_{top-q|ω|} ω⊗ω — does the
# multi-directionality (δ_Λ bounded below ≈0.5, the wrong-way-for-Lockwood verdict) hold at N=512?
#
# Scope: resolved DNS truncation witness; vacuity-capped; :proved=0; distance UNTOUCHED.
# Bridge: T-12 (GPU float32 ≡ CPU float64 to 5–6 digits at N=256) licenses reading GPU snapshots
# with the CPU-validated diagnostics. Diagnostics MIRROR ns013_cfm_conditioned_probe.jl
# (cfm_pointwise) and ns049_anisotropy_defect_probe.jl (δ_Λ) — kept formula-identical.
#
# Usage: julia [--project] scripts/ns013_cfm_gpu_trend.jl snap_N256_tubes_t6.00.bin [snap_N512_...]
using Printf, LinearAlgebra, Statistics
include(joinpath(@__DIR__, "load_gpu_snapshot.jl"))   # load_snapshot + dns_tg256 chain (guarded mains)

# vorticity-direction roughness |∇ξ|² and |ω| per point — MIRRORS ns013_cfm_conditioned_probe.cfm_pointwise
function cfm_fields(U, op)
    ωxh,ωyh,ωzh = curl_hat(U[1],U[2],U[3],op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    wmag = sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2) .+ 1e-12
    ξx=ωx./wmag; ξy=ωy./wmag; ξz=ωz./wmag
    g2 = zeros(size(ωx))
    for ξ in (ξx,ξy,ξz)
        ξh = fft3(ξ)
        g2 .+= real.(ifft3(im.*op.kx.*ξh)).^2 .+ real.(ifft3(im.*op.ky.*ξh)).^2 .+ real.(ifft3(im.*op.kz.*ξh)).^2
        ξh = nothing
    end
    vec(g2), vec(wmag .- 1e-12), (ωx,ωy,ωz)
end

# δ_Λ on the top-q |ω| set — MIRRORS ns049_anisotropy_defect_probe (δ=0 one-directional, ½ planar, ⅔ isotropic)
function delta_lambda(ω, w, q)
    ωx,ωy,ωz = ω
    thrv = partialsort(w, max(1,round(Int,q*length(w))); rev=true)
    M = zeros(3,3)
    @inbounds for i in eachindex(w)
        if w[i] >= thrv
            M[1,1]+=ωx[i]^2; M[2,2]+=ωy[i]^2; M[3,3]+=ωz[i]^2
            M[1,2]+=ωx[i]*ωy[i]; M[1,3]+=ωx[i]*ωz[i]; M[2,3]+=ωy[i]*ωz[i]
        end
    end
    M[2,1]=M[1,2]; M[3,1]=M[1,3]; M[3,2]=M[2,3]
    1.0 - eigmax(Symmetric(M))/tr(M)
end

function analyze(path)
    s = load_snapshot(path); N=s.N; op=make_ops(N)
    d = diagnose(s.U, op, N)
    uh,vh,wh = s.U
    dvr = maximum(abs.(op.kx.*uh .+ op.ky.*vh .+ op.kz.*wh)) / maximum(sqrt.(abs2.(uh).+abs2.(vh).+abs2.(wh)))
    @printf("\n# %s   N=%d t=%.2f   E=%.6f Z=%.5f winf=%.2f div_rel=%.1e\n", basename(path), N, s.t, d.E, d.Z, d.winf, dvr)
    g2, w, ω = cfm_fields(s.U, op)
    ωflat = (vec(ω[1]), vec(ω[2]), vec(ω[3]))
    sw = sort(w; rev=true); thr(q)=sw[clamp(round(Int,q*length(sw)),1,length(sw))]
    println("    top-q |ω|     ⟨|∇ξ|²⟩      enstrophy-wtd ⟨|∇ξ|²⟩    δ_Λ(top-q)")
    rows=NamedTuple[]
    for q in (1.0,0.10,0.01,0.001)
        m = w .>= thr(q)
        cfm_w = sum(g2[m].*w[m])/sum(w[m])             # |ω|-weighted — FORMULA-IDENTICAL to the CPU probe
                                                       # (its comment says "enstrophy-weighted" but its code
                                                       # weights by wmag=|ω|; identity matters for the N-trend)
        δΛ = delta_lambda(ωflat, w, q)
        push!(rows,(q=q, mean=mean(@view g2[m]), cfm=cfm_w, dL=δΛ))
        @printf("    %6.1f%%      %10.4f    %10.4f          %.4f\n", 100q, rows[end].mean, cfm_w, δΛ)
    end
    (N=N, t=s.t, rows=rows, core_bulk = rows[end].cfm/rows[1].cfm, dL_core = rows[end].dL)
end

function main()
    isempty(ARGS) && error("usage: julia ns013_cfm_gpu_trend.jl <snap.bin> [<snap.bin> ...]")
    println("="^78)
    println("  NS-013 ξ N-trend (GPU snapshots) + NS-049 δ_Λ ride-along — vacuity-capped witness")
    println("  CPU N=64 reference: core/bulk ⟨|∇ξ|²⟩_w ratio = 0.57 (212/369); δ_Λ@.1% ≈ 0.54")
    println("="^78)
    res = [analyze(p) for p in ARGS]
    println("\n"*"="^78); println("  N-TREND VERDICT (dimensionless core/bulk ratio; the raw values grow with N by construction)"); println("="^78)
    @printf("    %-8s %-8s %-22s %-14s\n", "N", "t", "core/bulk ⟨|∇ξ|²⟩_w", "δ_Λ@top-0.1%")
    @printf("    %-8d %-8s %-22.3f %-14s   (CPU probe)\n", 64, "6.00", 0.57, "0.54 (helical@N=64)")
    for r in res
        @printf("    %-8d %-8.2f %-22.3f %-14.4f\n", r.N, r.t, r.core_bulk, r.dL_core)
    end
    if length(res) >= 2
        a,b = res[end-1], res[end]
        lift = b.core_bulk/a.core_bulk
        println()
        if b.core_bulk < 1.0 && lift < 1.3
            println("  ⇒ core ξ-smoothness is N-STABLE (ratio <1 and not lifting): the CFM-regular-leaning")
            println("    core geometry is NOT a resolution artifact at these N — within the vacuity cap")
            println("    (a regular truncation cannot reach the singular limit; this stays a witness).")
        elseif lift >= 1.3 || b.core_bulk >= 1.0
            println("  ⇒ the core ratio LIFTS with N (the NS-039 D30 artifact pattern): the N=64 ξ-smoothness")
            println("    reading does NOT survive refinement — record honestly; the claim-2 witness weakens.")
        end
        @printf("  δ_Λ@cores: %.3f (N=%d) → %.3f (N=%d) — %s\n", a.dL_core, a.N, b.dL_core, b.N,
            b.dL_core > 0.3 ? "stays MULTI-directional ⇒ the NS-049 wrong-way verdict holds at scale" :
                              "FALLS toward one-directional — would WEAKEN the NS-049 vacuity verdict (re-read!)")
    end
    println("  :proved=0; distance UNTOUCHED."); println("="^78)
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
