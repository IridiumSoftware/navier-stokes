#!/usr/bin/env julia
# ns046_critical_norm_race.jl — which critical (σ=0) norm is the sharpest blowup DETECTOR?
#
# WHY. Gallagher–Koch–Planchon (CMP 2016): at a finite-time singularity EVERY critical Besov norm
# `Ḃ^{-1+3/p}_{p,q}` (1<p,q<∞) blows up; ESS: the `L³` endpoint blows up. So all σ=0 norms MUST diverge
# (and none is controlled a priori — NS-002). But they are not equally SHARP detectors. This probe races
# them on the most singular-like resolved event the program has — the Kerr anti-parallel-tube reconnection
# (NS-038: `D30` touches the CKN ≤1 edge there) — to rank which σ=0 norm is the best practical early-warning.
#
# HONEST CAP. At Re=1600 the flow is REGULAR — no norm actually blows up. This is a DETECTOR-SENSITIVITY
# comparison on an intense transient (sharpness = peak/baseline + steepest log-rate), NOT a blowup race.
# Within-truncation; NOT the PDE; `:proved`=0; prize UNTOUCHED.
#
# THE FIELD (all spectral; raw fft3 coefficients, consistent in time ⇒ each normalized to its own baseline):
#   CRITICAL (σ=0) — the race:
#     L3   = ‖u‖_{L³}              (ESS endpoint; σ(L³)=1−3/3=0)
#     H12  = ‖u‖_{Ḣ^{1/2}}        = (Σ|k|·|û|²)^{1/2}        (≅L³ via NS-036 hinge; σ=0)
#     BesW = ‖ω‖_{Ḃ⁰_{∞,1}}       = Σ_j‖Δ_jω‖_∞              (Kozono–Taniuchi; time-integral-critical)
#     Bm1  = ‖u‖_{Ḃ⁻¹_{∞,∞}}      = sup_j 2^{-j}‖Δ_ju‖_∞     (Koch–Tataru; largest critical space)
#   REFERENCE detectors (the program's current tools):
#     winf = ‖ω‖_{L∞}             (BKM integrand)            Sw = S_ω = P/⟨|ω|²⟩^{3/2}  (production skewness)
#   CONTRAST (non-critical — frame the race):
#     L2   = ‖u‖_{L²}             (energy; σ=−1 SUPERcritical ⇒ controlled ⇒ should stay ~flat)
#     ensZ = ‖ω‖_{L²}            (enstrophy; σ=+1 SUBcritical ⇒ over-sensitive to small scales)
#
# Reuses the validated dns_tg256 chain + the dyadic-Besov band-pass. CHAIN_CONVENTION: n/a.
# Run: julia -t auto scripts/ns046_critical_norm_race.jl   (SMOKE=1 for the N=16 gate first)
# Env: NS_N(64) NS_T(6.0) NS_DT(0.01) NS_NU(1/1600) NS_SAMPLE(0.25)

using Printf, Statistics
include(joinpath(@__DIR__, "dns_tg256.jl"))   # → solver + field_diag + diagnose + vortex_tube_ic + ffts

function dyadic_shells(op)
    cut=op.cut; kmag=sqrt.(op.k2); sh=NamedTuple[]; j=0
    while 2.0^j <= cut
        m=(kmag .>= 2.0^j) .& (kmag .< 2.0^(j+1)) .& (kmag .<= cut)
        count(m)>0 && push!(sh,(lo=2.0^j, mask=m)); j+=1
    end
    sh
end

# the full critical-norm panel on a state
function norms(U, op, N, shells)
    uh,vh,wh = U
    u=real.(ifft3(uh)); v=real.(ifft3(vh)); w=real.(ifft3(wh))
    umag=sqrt.(u.^2 .+ v.^2 .+ w.^2)
    L2 = sqrt(mean3(umag.^2))
    L3 = (mean3(umag.^3))^(1/3)
    H12= sqrt(sum(sqrt.(op.k2).*(abs2.(uh).+abs2.(vh).+abs2.(wh))))     # (Σ|k|·|û|²)^{1/2}, raw-coef (consistent)
    ωxh,ωyh,ωzh = curl_hat(uh,vh,wh,op)
    BesW=0.0; Bm1=0.0
    for s in shells
        m=s.mask
        ωxj=real.(ifft3(ωxh.*m)); ωyj=real.(ifft3(ωyh.*m)); ωzj=real.(ifft3(ωzh.*m))
        BesW += maximum(sqrt.(ωxj.^2 .+ ωyj.^2 .+ ωzj.^2))             # Σ_j ‖Δ_jω‖_∞
        uxj=real.(ifft3(uh.*m)); uyj=real.(ifft3(vh.*m)); uzj=real.(ifft3(wh.*m))
        Bm1 = max(Bm1, (1.0/s.lo)*maximum(sqrt.(uxj.^2 .+ uyj.^2 .+ uzj.^2)))   # sup_j 2^{-j}‖Δ_ju‖_∞
    end
    d=diagnose(U,op,N); fd=field_diag(U,op)
    (L2=L2, L3=L3, H12=H12, BesW=BesW, Bm1=Bm1, winf=d.winf, Sw=abs(fd.Sw), ensZ=sqrt(2*d.Z))
end

function smoke()
    println("── SMOKE (N=16): critical-norm panel ──")
    N=16; op=make_ops(N); shells=dyadic_shells(op); U=vortex_tube_ic(N,op)
    n=norms(U,op,N,shells)
    for (k,val) in pairs(n); @printf("  %-5s = %.4e\n", k, val); end
    ok = all(isfinite, values(n)) && all(>(0), values(n))
    println(ok ? "  all critical/reference norms finite & positive ✓\n  SMOKE PASS ✓" : "  SMOKE FAIL ✗")
end

function main()
    if get(ENV,"SMOKE","")=="1"; smoke(); return; end
    N=parse(Int,get(ENV,"NS_N","64")); T=parse(Float64,get(ENV,"NS_T","6.0"))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    smp=parse(Float64,get(ENV,"NS_SAMPLE","0.25")); op=make_ops(N); shells=dyadic_shells(op)
    out=joinpath(@__DIR__,"ns046_critical_norm_race$(N==64 ? "" : "_N$(N)").out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout);flush(stdout))
    pr("# Critical-norm DETECTOR race — Kerr tube reconnection (Re=$(round(Int,1/ν)), N=$N). Sharpest σ=0 early-warning?")
    pr("# CAP: Re=1600 is REGULAR — sensitivity comparison on an intense transient, NOT a blowup race. :proved=0.")
    U=vortex_tube_ic(N,op)
    keys=(:L2,:L3,:H12,:BesW,:Bm1,:winf,:Sw,:ensZ)
    series=Dict(k=>Float64[] for k in keys); ts=Float64[]
    t=0.0; nexts=0.0
    pr("# t      L2(σ−1)  L3(σ0)   H12(σ0)  BesW(σ0) Bm1(σ0)  winf     Sw       ensZ(σ+1)")
    while t<=T+1e-9
        if t>=nexts-1e-9
            n=norms(U,op,N,shells); push!(ts,t); for k in keys; push!(series[k], getfield(n,k)); end
            pr(@sprintf("%.2f   %.4f   %.4f   %.3e %.3e %.3e %.3e %.4f   %.4f",
                t, n.L2, n.L3, n.H12, n.BesW, n.Bm1, n.winf, n.Sw, n.ensZ))
            nexts+=smp
        end
        U=rk4(U,dt,ν,op); t+=dt
    end
    # sharpness = peak/baseline (baseline = t=0); steepest forward log-rate over the run
    pr("")
    pr("# ── DETECTOR RACE (sharpness = peak/baseline; steepest d/dt log over the transient) ──")
    pr("# norm     class      baseline    peak       peak@t   peak/base   max d/dt log")
    rows=NamedTuple[]
    for k in keys
        s=series[k]; base=s[1]; pk,pi=findmax(s)
        rate=maximum((log(max(s[i+1],1e-30))-log(max(s[i],1e-30)))/(ts[i+1]-ts[i]) for i in 1:length(s)-1)
        cls = k==:L2 ? "σ−1 super" : k==:ensZ ? "σ+1 sub" : k in (:winf,:Sw) ? "ref" : "σ0 CRIT"
        ratio = pk/max(base, 1e-6*pk)                              # floor degenerate (~0) baselines, e.g. Sw
        push!(rows,(k=k,cls=cls,base=base,pk=pk,pt=ts[pi],ratio=ratio,rate=rate))
        pr(@sprintf("# %-7s  %-9s  %.4e  %.4e  %5.2f    %7.3f     %+7.3f", k, cls, base, pk, ts[pi], ratio, rate))
    end
    crit=[r for r in rows if r.cls=="σ0 CRIT"]; sort!(crit;by=r->-r.ratio)
    pr("# ── CRITICAL-NORM RANKING (by peak/baseline sharpness) ──")
    for (i,r) in enumerate(crit); pr(@sprintf("#  %d. %-5s  sharpness=%.2f×  rate=%+.2f", i, r.k, r.ratio, r.rate)); end
    pr("# READ: energy L2 (σ−1, controlled) should be ~flat (sharpness≈1); the σ0 CRIT norms are the")
    pr("# detector class (all must blow at a true singularity, GKP/ESS); the ranking says which is sharpest")
    pr("# on this reconnection. Within-truncation; NOT a blowup; :proved=0.")
    pr("# DONE")
    close(fout); println(stdout,"wrote: $out")
end

if abspath(PROGRAM_FILE)==@__FILE__; main(); end
