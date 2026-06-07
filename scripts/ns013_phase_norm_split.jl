#!/usr/bin/env julia
# ns013_phase_norm_split.jl — the phase-blindness face of supercriticality (NS-002).
#
# WHY (the synthesis). Three recent within-truncation findings converge:
#   • real-vs-complex (1D): the production ∫g³ is a phase/odd-coherence object (≡0 on the one-sided
#     complex-blowup class);
#   • phase-production (3D): scrambling the phases (|û(k)| fixed) collapses the production ∫ω·Sω ~97-99%
#     while E,Z,H are preserved to machine precision;
#   • Besov (NS-047): the critical-Besov norm Ḃ⁰_{∞,1} is the regularity-deciding metric.
# This probe ties them to the CENTRAL obstruction (NS-002). It measures, under the SAME phase scramble,
# which norms are phase-BLIND and which are phase-SENSITIVE:
#   PHASE-BLIND (depend only on |û(k)|, by Parseval): energy E, enstrophy Z, helicity H — exactly the
#     a-priori-COERCIVE / CONTROLLED quantities (Leray, NS-003).
#   PHASE-SENSITIVE (depend on the conjugate/triadic phase coherence): ‖ω‖_∞ (BKM), the critical-Besov
#     vorticity norm ‖ω‖_{Ḃ⁰_{∞,1}}=Σ_j‖Δ_jω‖_∞ (Kozono–Taniuchi), the production ∫ω·Sω, the skewness S_ω
#     — exactly the regularity-DECIDING quantities.
# If the split is clean, supercriticality (NS-002: controlled σ<0 vs deciding σ=0, no overlap) gets a
# concrete PHASE-SPACE face: the controlled quantities are BLIND to the phase coherence where the
# production / singularity structure lives.
#
# HONEST SCOPE. Resolved-ish 3D DNS truncation; within-truncation witness (a phase surrogate diagnoses
# WHERE each norm's content sits, phase vs amplitude — not an analytic step). NOT the PDE; :proved=0;
# prize UNTOUCHED. This is a concrete ILLUSTRATION consistent with supercriticality, not a proof of it.
# Reuses the validated phase_scramble + dyadic-Besov machinery. CHAIN_CONVENTION: n/a.
# Run: julia -t auto scripts/ns013_phase_norm_split.jl   (SMOKE=1 for the N=16 gate first)
# Env: NS_N(64) NS_TDEV(4.0) NS_DT(0.01) NS_NU(1/1600) NS_NSEED(5)

using Printf, Random, Statistics
include(joinpath(@__DIR__, "dns_tg256.jl"))   # → solver + field_diag + diagnose + ICs + fft3/ifft3

# random-phase surrogate (preserves |û(k)| ⇒ E,Z,H; div-free); α scales the phase perturbation
function phase_scramble(U, op, seed; α=1.0)
    N=size(U[1],1); Random.seed!(seed); φ=zeros(N,N,N)
    cidx(a)= a==1 ? 1 : N+2-a; li(a,b,c)= a + (b-1)*N + (c-1)*N*N
    @inbounds for c in 1:N, b in 1:N, a in 1:N
        ac,bc,cc = cidx(a),cidx(b),cidx(c)
        (ac==a && bc==b && cc==c) && continue
        if li(a,b,c) < li(ac,bc,cc); θ=α*(2π*rand()-π); φ[a,b,c]=θ; φ[ac,bc,cc]=-θ; end
    end
    ph=exp.(im.*φ); (U[1].*ph, U[2].*ph, U[3].*ph)
end

# dyadic Littlewood–Paley shells (|k|≤cut) and the critical-Besov vorticity norm Σ_j‖Δ_jω‖_∞
function dyadic_shells(op)
    cut=op.cut; kmag=sqrt.(op.k2); sh=Vector{Array{Bool,3}}(); j=0
    while 2.0^j <= cut
        m=(kmag .>= 2.0^j) .& (kmag .< 2.0^(j+1)) .& (kmag .<= cut)
        count(m)>0 && push!(sh,m); j+=1
    end
    sh
end
function besov_omega(U, op, shells)
    ωxh,ωyh,ωzh = curl_hat(U[1],U[2],U[3],op); s=0.0
    for m in shells
        ωxj=real.(ifft3(ωxh.*m)); ωyj=real.(ifft3(ωyh.*m)); ωzj=real.(ifft3(ωzh.*m))
        s += maximum(sqrt.(ωxj.^2 .+ ωyj.^2 .+ ωzj.^2))
    end
    s
end

# the full norm panel on a state
function panel(U, op, N, shells)
    d=diagnose(U,op,N); fd=field_diag(U,op)
    (E=d.E, Z=d.Z, H=d.H, winf=d.winf, besov=besov_omega(U,op,shells), P=mean3(fd.Pd), Sw=fd.Sw)
end

function smoke()
    println("── SMOKE (N=16): phase-blind vs phase-sensitive split ──")
    N=16; op=make_ops(N); shells=dyadic_shells(op); U=random_helical_ic(N,op)
    for _ in 1:5; U=rk4(U,0.01,1/1600,op); end
    p0=panel(U,op,N,shells); ps=panel(phase_scramble(U,op,7; α=1.0),op,N,shells)
    @printf("  BLIND    : Z %.6f→%.6f  H %+.6f→%+.6f\n", p0.Z,ps.Z,p0.H,ps.H)
    @printf("  SENSITIVE: P %+.3e→%+.3e  (winf %.3f→%.3f Besov %.3f→%.3f — intermittency, needs developed field)\n",
            p0.P,ps.P,p0.winf,ps.winf,p0.besov,ps.besov)
    okblind = abs(ps.Z-p0.Z)/p0.Z<1e-8 && abs(ps.H-p0.H)/max(abs(p0.H),1e-12)<1e-6
    oksens  = abs(ps.P) < abs(p0.P)                        # production drops under scramble (core sensitivity)
    @printf("  Z,H phase-blind %s   production phase-sensitive %s  (winf/Besov split read on developed N=64 run)\n",
            okblind ? "✓" : "✗", oksens ? "✓" : "✗")
    println(okblind && oksens ? "  SMOKE PASS ✓" : "  SMOKE FAIL ✗")
end

function sweep(label, U, op, N, shells, pr; nseed=5, αs=(0.0,0.25,0.5,0.75,1.0))
    p0=panel(U,op,N,shells)
    pr(@sprintf("# %s — coherent: E=%.4f Z=%.4f H=%+.3e winf=%.2f Besov=%.2f P=%+.3e Sw=%+.4f",
                label,p0.E,p0.Z,p0.H,p0.winf,p0.besov,p0.P,p0.Sw))
    pr("#         ── PHASE-BLIND ──   ──────────── PHASE-SENSITIVE ────────────")
    pr("#  alpha   Z/Z0    |dH|       winf/w0   Besov/B0   P/P0     Sw")
    for α in αs
        zr=Float64[]; dh=Float64[]; wr=Float64[]; br=Float64[]; pr_=Float64[]; sw=Float64[]
        for s in 1:nseed
            p = α==0.0 ? p0 : panel(phase_scramble(U,op,1000+s;α=α),op,N,shells)
            push!(zr,p.Z/p0.Z); push!(dh,abs(p.H-p0.H)); push!(wr,p.winf/p0.winf)
            push!(br,p.besov/p0.besov); push!(pr_,p.P/p0.P); push!(sw,p.Sw)
            α==0.0 && break
        end
        pr(@sprintf("  %5.2f   %.4f  %.1e    %.4f    %.4f     %+.4f   %+.4f",
                    α, mean(zr), mean(dh), mean(wr), mean(br), mean(pr_), mean(sw)))
    end
end

function main()
    if get(ENV,"SMOKE","")=="1"; smoke(); return; end
    N=parse(Int,get(ENV,"NS_N","64")); Tdev=parse(Float64,get(ENV,"NS_TDEV","4.0"))
    dt=parse(Float64,get(ENV,"NS_DT","0.01")); ν=parse(Float64,get(ENV,"NS_NU",string(1/1600)))
    nseed=parse(Int,get(ENV,"NS_NSEED","5")); op=make_ops(N); shells=dyadic_shells(op)
    out=joinpath(@__DIR__,"ns013_phase_norm_split$(N==64 ? "" : "_N$(N)").out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout);flush(stdout))
    pr("# Phase-blindness face of supercriticality (NS-002): which norms see the phase coherence?")
    pr(@sprintf("# N=%d Re=%.0f Tdev=%.1f nseed=%d  Scope: DNS truncation; NOT the PDE; :proved=0.", N,1/ν,Tdev,nseed))
    for (lbl,U0) in (("TG (H=0)",taylor_green_ic(N,op)), ("HELICAL (H≠0)",random_helical_ic(N,op)))
        U=U0; t=0.0; while t<Tdev-1e-9; U=rk4(U,dt,ν,op); t+=dt; end
        pr(""); sweep("$lbl @ t=$(round(Tdev,digits=1))", U, op, N, shells, pr; nseed=nseed)
    end
    pr("")
    pr("# READ: Z/Z0≡1 and |dH|≈0 (phase-BLIND — the a-priori-coercive L² controls, NS-003) while")
    pr("# winf/w0, Besov/B0, P/P0, Sw all COLLAPSE (phase-SENSITIVE — the regularity-DECIDING critical/L∞")
    pr("# quantities). ⇒ the controlled quantities are blind to the phase coherence carrying the production")
    pr("# — a concrete phase-space face of supercriticality (NS-002). Within-truncation; :proved=0.")
    pr("# DONE")
    close(fout); println(stdout,"wrote: $out")
end

if abspath(PROGRAM_FILE)==@__FILE__; main(); end
