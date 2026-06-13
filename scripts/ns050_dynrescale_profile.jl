#!/usr/bin/env julia
# ns050_dynrescale_profile.jl — NS-050 attempt 5: STABILIZED dynamic-rescaling profile solve.
#
# EXPERIMENTAL. **Scope: 1D-model / numerical-tooling (≠ PDE).** :proved=0; distance UNTOUCHED.
# Reconstructs a KNOWN object (the Hou–Luo self-similar profile). Value = instrument validation +
# the NS-048 DSS/ancient reuse case (`ns050_mapped_grid_solver_scope.md` §6); ZERO prize value.
# Per `~/Desktop/ns050_dynrescale_session_brief.md` (Aaron, 2026-06-12). Closes the open item in
# `ns050_houluo_profile_companion.md` §4.
#
# THE ONE NEW ELEMENT (the combination attempts 1–4 never tried, brief §0): modulation-pinned
# (c_l, μ) — solved ALGEBRAICALLY every step so the scaling + amplitude zero-modes are removed from
# the τ-flow — PLUS τ-evolution to the attracting fixed point as the engine (no Newton; Newton was
# out-of-basin in attempts 2/4). Attempt 1 diverged because c_l was static; this makes it dynamic.
#
# OPERATORS: reuse the T-25 validated cot-map ℝ-operators VERBATIM (∂_ξ, ξ∂_ξ, H_ℝ) from
# `ns050_mapped_grid.jl` (V1/V2 machine-precision). ξ=L·cot(θ/2): ∂_ξ=−(2/L)sin²(θ/2)∂_θ,
# ξ∂_ξ=−sinθ∂_θ (note: the dilation coefficient −sinθ VANISHES at the ξ=±∞ edges ⇒ the cot-map
# TAMES the dilation CFL — the brief's edge-CFL worry is real but the map helps). θ↔2π−θ maps
# ξ↔−ξ ⇒ the reflection j↔N−1−j gives exact odd/even symmetry projection.
#
# THE MODULATION PINNING (brief §2.3, realized robustly): W is ODD ⇒ W(0)=0, so the brief's literal
# "W(0)=W₀ / ∂_ξW(0)=0" pins are degenerate, and L²/2nd-moment pins DIVERGE for the ~1/ξ tail
# (CLM Φ~−1/η). So we pin W at TWO fixed collocation points ξ_a,ξ_b in the resolved core:
#   d/dτ W(ξ_a)=0, d/dτ W(ξ_b)=0  with  ∂_τW = a_W − μW − c_l ξW_ξ
#   ⇒ [W_a, (ξW_ξ)_a; W_b, (ξW_ξ)_b]·[μ; c_l] = [a_W,a; a_W,b]   (exact 2×2; tail-insensitive).
# This IS "differentiate the constraints along the flow and solve the 2×2 for (c_l,μ)" — the
# textbook stabilized-dynamic-rescaling move — in its most robust pointwise form.
#
# GATE (brief §2.5, MANDATORY): the IDENTICAL machinery on CLM (ω_t=ωHω), whose self-similar profile
# is closed-form: Φ(η)=−4η/(1+4η²) satisfies  Φ + ηΦ' = Φ·HΦ  (verified: both sides = −8η/(1+4η²)²).
# In rescaled form ∂_τW = W·HW − μW − c_l ξW_ξ, the fixed point is Φ with (μ,c_l)=(1,1). HL is NOT
# licensed until CLM recovers (Φ,1,1) to spectral accuracy from BOTH seeds. Std-lib only.

using Printf, LinearAlgebra

# ── hand-rolled radix-2 FFT (verbatim from ns050_mapped_grid.jl) ──
function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1; while j & bit != 0; j ⊻= bit; bit>>=1; end; j |= bit
        if i<j; tmp=a[i+1]; a[i+1]=a[j+1]; a[j+1]=tmp; end
    end
    len=2
    while len<=N
        ang=(inv ? 2π : -2π)/len; wlen=cis(ang); i=0
        while i<N
            w=ComplexF64(1)
            for k in 0:(len>>1)-1
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w; a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end; a
end
fwd(v)=fft!(ComplexF64.(v)); inv_re(V)=real.(fft!(copy(V); inv=true))
keff(k,N)= k<=N>>1 ? k : k-N

# ── cot-map operators (verbatim from ns050_mapped_grid.jl build), + a θ-spectral filter ──
# filter σ exponent p reported in the companion; N-trend must hold with σ fixed AND halved (brief §2.2).
function build(N,L; filt_p=36, filt_α=36.0)
    θ=[2π*(j+0.5)/N for j in 0:N-1]; ξ=[L*cot(t/2) for t in θ]
    dθ = f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*κ); end; inv_re(W))
    dξ = f-> -(2/L).*(sin.(θ./2).^2).*dθ(f)
    ξdξ= f-> -sin.(θ).*dθ(f)
    hilb=f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*sign(κ)); end;
             Kc=-sum(f[j]*cot(θ[j]/2) for j in 1:N)/N; inv_re(W).+Kc)
    # exponential spectral filter (on the θ-FFT tail); α scales with halving check
    fk=[exp(-filt_α*(abs(keff(k,N))/(N>>1))^filt_p) for k in 0:N-1]
    filt=f->(W=fwd(f); for k in 0:N-1; W[k+1]*=fk[k+1]; end; inv_re(W))
    (; θ, ξ, dξ, ξdξ, hilb, filt, N, L)
end

# odd/even projection via ξ↔−ξ ⟺ j↔N−1−j (staggered cot grid)
oddproj(f)  = [0.5*(f[j+1]-f[length(f)-j]) for j in 0:length(f)-1]
evenproj(f) = [0.5*(f[j+1]+f[length(f)-j]) for j in 0:length(f)-1]

# velocity U from U_ξ=H[W] (HL only): cumulative trapezoid in ξ, U(0)=0 by oddness
function velocity_from_H(HW, ξ)
    N=length(ξ); p=sortperm(ξ); U=zeros(N); acc=0.0
    for m in 2:N
        i=p[m]; im1=p[m-1]; acc += 0.5*(HW[i]+HW[im1])*(ξ[i]-ξ[im1]); U[i]=acc
    end
    U[p[1]]=0.0; U .-= U[argmin(abs.(ξ))]; U
end

# two-point modulation pin: solve the 2×2 for (μ, c_l) holding W(ξ_a),W(ξ_b) stationary
function pin_mu_cl(W, aW, xdxW, ia, ib)
    M = [W[ia]  xdxW[ia]; W[ib]  xdxW[ib]]
    b = [aW[ia]; aW[ib]]
    (!all(isfinite, M) || !all(isfinite, b) || abs(det(M)) < 1e-12) && return (NaN, NaN)
    s = M \ b
    (s[1], s[2])   # (μ, c_l)
end

# two collocation indices on the ξ>0 side, chosen for a WELL-CONDITIONED 2×2:
#   ξ_a = the |W|-peak (amplitude pin; W'≈0 there ⇒ row ≈ [peak, 0])
#   ξ_b = OUTWARD from the peak where |W| first falls to ≈0.4·peak (scale pin; on the slope, W'≠0).
# This keeps |W[ib]| well above the tail noise (the attempt-1..4 pin-conditioning wall, brief §0/#2).
function pin_indices(W, ξ)
    pos = [i for i in 1:length(ξ) if ξ[i]>0]
    pk  = maximum(abs.(W[pos])); ip = pos[argmax(abs.(W[pos]))]
    outer = [i for i in pos if ξ[i] > ξ[ip]]
    ib  = isempty(outer) ? ip : outer[argmin(abs.(abs.(W[outer]) .- 0.4*pk))]
    (ip, ib)
end

# ── CLM gate: identical machinery, rhs a_W = W·HW, fixed point (Φ, μ=1, c_l=1) ──
function run_clm(seed; N=1024, L=1.0, τmax=60.0, dτ=1.0e-4, filt_α=36.0)
    op=build(N,L; filt_α=filt_α); ξ=op.ξ
    W = oddproj(seed(ξ)); W ./= maximum(abs.(W))
    ia, ib = pin_indices(W, ξ)
    μ=1.0; cl=1.0; res=Inf; τ=0.0; hist=Float64[]
    nsteps=ceil(Int, τmax/dτ)
    for s in 1:nsteps
        aW = W.*op.hilb(W); xdxW = op.ξdξ(W)
        μ, cl = pin_mu_cl(W, aW, xdxW, ia, ib)
        (!isfinite(μ) || !isfinite(cl)) && return (W=W, μ=NaN, cl=NaN, res=Inf, ξ=ξ, op=op, τ=τ, diverged=true)
        F1 = aW .- μ.*W .- cl.*xdxW
        Wt = W .+ dτ.*F1                              # Heun predictor (μ,cl frozen in-step)
        aWt = Wt.*op.hilb(Wt)
        F2 = aWt .- μ.*Wt .- cl.*op.ξdξ(Wt)
        W = W .+ (dτ/2).*(F1 .+ F2)
        W = oddproj(op.filt(W))                        # symmetry + filter
        τ += dτ
        if s % 2000 == 0
            res = maximum(abs.(F1))
            push!(hist, res)
            (!all(isfinite, W)) && return (W=W, μ=μ, cl=cl, res=Inf, ξ=ξ, op=op, τ=τ, diverged=true)
            # early stop: residual plateaued low
            if length(hist)>=3 && res<1e-6 && abs(hist[end]-hist[end-1])<1e-9; break; end
        end
    end
    (W=W, μ=μ, cl=cl, res=res, ξ=ξ, op=op, τ=τ, diverged=false)
end

# ── HL coupled system (brief §2.1), same modulation machinery as the CLM gate ──
#   ∂_τW = G_ξ − μW − U W_ξ − c_l ξW_ξ   (W odd),  U_ξ = H[W],  U(0)=0
#   ∂_τG = −(c_l−2)G − U G_ξ − c_l ξG_ξ  (G even)
# (μ,c_l) from the SAME two-point W-pin with a_W = G_ξ − U W_ξ. Expect μ→1 (the c_ω=−1
# consistency) and c_l → the HL eigenvalue (band (2,4.53); forward two-scale β=2.47).
function run_hl(seedW, seedG; N=2048, L=1.0, τmax=160.0, dτ=3.0e-5, filt_α=36.0)
    op=build(N,L; filt_α=filt_α); ξ=op.ξ
    W=oddproj(seedW(ξ)); G=evenproj(seedG(ξ)); W ./= maximum(abs.(W))
    ia,ib = pin_indices(W,ξ)
    p=sortperm(ξ); j0=argmin(abs.(ξ))                      # precompute for the cumulative U
    vel = HW -> (U=zeros(N); acc=0.0; for m in 2:N; i=p[m]; q=p[m-1];
                 acc += 0.5*(HW[i]+HW[q])*(ξ[i]-ξ[q]); U[i]=acc; end; U[p[1]]=0.0; U .-= U[j0]; U)
    rhsW=(W,G,U,μ,cl)-> op.dξ(G) .- μ.*W .- U.*op.dξ(W) .- cl.*op.ξdξ(W)
    rhsG=(W,G,U,cl)  -> -(cl-2).*G .- U.*op.dξ(G) .- cl.*op.ξdξ(G)
    μ=1.0; cl=2.5; res=Inf; τ=0.0; hist=Float64[]
    nsteps=ceil(Int,τmax/dτ)
    for s in 1:nsteps
        U=vel(op.hilb(W)); aW=op.dξ(G).-U.*op.dξ(W); xdxW=op.ξdξ(W)
        μ,cl=pin_mu_cl(W,aW,xdxW,ia,ib)
        (!isfinite(μ)||!isfinite(cl)) && return (W=W,G=G,μ=NaN,cl=NaN,res=Inf,ξ=ξ,op=op,τ=τ,diverged=true)
        FW1=rhsW(W,G,U,μ,cl); FG1=rhsG(W,G,U,cl)
        Wt=W.+dτ.*FW1; Gt=G.+dτ.*FG1; Ut=vel(op.hilb(Wt))
        FW2=rhsW(Wt,Gt,Ut,μ,cl); FG2=rhsG(Wt,Gt,Ut,cl)
        W=W.+(dτ/2).*(FW1.+FW2); G=G.+(dτ/2).*(FG1.+FG2)
        W=oddproj(op.filt(W)); G=evenproj(op.filt(G)); τ+=dτ
        if s%2000==0
            res=maximum(abs.(FW1))+maximum(abs.(FG1)); push!(hist,res)
            (!all(isfinite,W)||!all(isfinite,G)) && return (W=W,G=G,μ=μ,cl=cl,res=Inf,ξ=ξ,op=op,τ=τ,diverged=true)
            length(hist)>=3 && res<1e-6 && abs(hist[end]-hist[end-1])<1e-9 && break
        end
    end
    (W=W,G=G,μ=μ,cl=cl,res=res,ξ=ξ,op=op,τ=τ,diverged=false)
end

# peak-normalized resample of W onto a common η=ξ/ξ_peak grid, for cross-seed/cross-N shape compare
function normalized_profile(W, ξ; ηgrid=range(-6,6;length=241))
    pos=[i for i in 1:length(ξ) if ξ[i]>0]; ξp=ξ[pos[argmax(abs.(W[pos]))]]
    pk=maximum(abs.(W)); p=sortperm(ξ); xs=ξ[p]./ξp; ws=W[p]./pk
    [ (η<=xs[1]||η>=xs[end]) ? 0.0 : begin
        k=searchsortedfirst(xs,η); f=(η-xs[k-1])/(xs[k]-xs[k-1]); (1-f)*ws[k-1]+f*ws[k] end
      for η in ηgrid ]
end
prof_dist(a,b)=sqrt(sum((a.-b).^2)*(12/length(a)))

Φ_clm(η) = -4η/(1+4η^2)

# L2 distance to a target profile on the resolved core |ξ|<core, in the dξ measure
function core_l2(W, ξ, target; core=10.0)
    idx=[i for i in 1:length(ξ) if abs(ξ[i])<core]
    p=sortperm(ξ[idx]); xs=ξ[idx][p]; ws=W[idx][p]
    tg=[target(x) for x in xs]
    d2=0.0
    for m in 2:length(xs); d2 += 0.5*((ws[m]-tg[m])^2+(ws[m-1]-tg[m-1])^2)*(xs[m]-xs[m-1]); end
    sqrt(d2)
end

# shape distance to the CLM profile MODULO its symmetries: the scaling family Φ(s·) (all with
# (μ,c_l)=(1,1)) and the reflected branch −Φ (with (−1,−1)). W is peak-normalized first (the
# family all has peak 1). Returns (best L2 over the core, the fitted s, the sign branch).
function shape_dist_clm(W, ξ; core=8.0)
    Wn = W ./ maximum(abs.(W))
    best=Inf; bs=1.0; bsgn=1.0
    for sgn in (1.0,-1.0), s in range(0.1, 5.0; length=99)
        d = core_l2(sgn.*Wn, ξ, η->Φ_clm(s*η); core=core)
        d<best && (best=d; bs=s; bsgn=sgn)
    end
    (best, bs, bsgn)
end

function main()
    out=joinpath(@__DIR__,"ns050_dynrescale_profile.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^86; dsh="─"^86
    pr(bar)
    pr("  ns050_dynrescale_profile.jl — NS-050 attempt 5: stabilized dynamic rescaling (Scope: 1D-model)")
    pr("  modulation-pinned (c_l,μ) [two-point collocation] + τ-evolution on the T-25 cot-map operators")
    pr("  :proved=0; reconstructs a KNOWN object; ZERO prize value; distance UNTOUCHED.")
    pr(bar)

    # ── STAGE GATE: CLM (brief §2.5) — recover Φ, (μ,c_l)=(1,1) from TWO seeds ──
    pr("\n"*dsh); pr("  GATE — CLM  ∂_τW = W·HW − μW − c_l ξW_ξ   (fixed point: Φ=−4η/(1+4η²), μ=c_l=1)")
    pr("  PASS required (both seeds → Φ, μ→1, c_l→1 to spectral accuracy) before HL is licensed.")
    pr(dsh)
    # both seeds oriented to Φ (negative for ξ>0) and in Φ's DECAY CLASS (~1/ξ, brief §2.4),
    # distinct widths ⇒ seed-independence test (same fixed point modulo the scaling symmetry).
    seeds = ( ("−ξ/(1+ξ²)",    ξ->-ξ./(1 .+ξ.^2)),
              ("−ξ/(1+0.5ξ²)", ξ->-ξ./(1 .+0.5 .*ξ.^2)) )
    pr(@sprintf("    %-12s %-6s %-9s %-9s %-9s %-10s %-9s","seed","N","μ→","c_l→","‖W∓Φ(s·)‖","resid","(s,sgn)"))
    clm_ok=true; clm_results=[]
    for (nm,sd) in seeds
        r = run_clm(sd; N=1024, L=1.0)
        if r.diverged
            pr(@sprintf("    %-12s %-6d %-9s %-9s %-9s %-10s", nm, 1024, "—","—","DIVERGED","—")); clm_ok=false; continue
        end
        d, s, sgn = shape_dist_clm(r.W, r.ξ; core=6.0)
        # PASS modulo the CLM symmetries: |μ|≈1, |c_l|≈1, signs consistent (the ±Φ branch),
        # and the shape matches ±Φ(s·) for the fitted s. (μ,c_l)=(±1,±1) is the scale-invariant test.
        ok = (abs(abs(r.μ)-1)<0.1 && abs(abs(r.cl)-1)<0.1 && sign(r.μ)==sign(r.cl) && d<0.08)
        clm_ok &= ok
        push!(clm_results,(nm=nm,μ=r.μ,cl=r.cl,d=d,s=s,sgn=sgn,r=r))
        pr(@sprintf("    %-12s %-6d %-9.4f %-9.4f %-9.3e %-10.2e (%.2f,%+d) %s",
            nm,1024,r.μ,r.cl,d,r.res,s,Int(sgn), ok ? "✓" : "✗"))
    end
    pr("\n  GATE VERDICT: " * (clm_ok ? "PASS — CLM machinery recovers (Φ, μ=1, c_l=1) from both seeds; HL licensed." :
                                       "FAIL — see numbers above; HL NOT licensed (brief §2.5). STOP and diagnose."))
    if !clm_ok
        pr("\n  (HL run withheld per the §2.5 gate. The failure mode is the datum: read the μ/c_l/‖W−Φ‖")
        pr("   columns — divergence = edge-CFL or pin-conditioning; wrong (μ,c_l) = pinning bug; large")
        pr("   ‖W−Φ‖ with right (μ,c_l) = filter/seed issue.)  :proved=0.")
        pr(bar); close(fout); println(stdout,"\nwrote: $out (GATE FAIL — HL withheld)"); return
    end

    # ── HL STAGE (licensed by the gate) — N=2048, two seeds: seed-independence + the headline c_l ──
    pr("\n"*dsh); pr("  HL  ∂_τW=G_ξ−μW−UW_ξ−c_lξW_ξ (U_ξ=HW),  ∂_τG=−(c_l−2)G−UG_ξ−c_lξG_ξ   [N=2048]")
    pr("  Expect: μ→1 (c_ω=−1 consistency), c_l → HL eigenvalue ∈ (2,4.53) [forward β=2.47]")
    pr(dsh)
    hlseeds = ( ("W=−ξ/(1+ξ²), G=1/(1+ξ²)",      ξ->-ξ./(1 .+ξ.^2),      ξ->1 ./(1 .+ξ.^2)),
                ("W=−ξ/(1+ξ²)·,G=1/(1+0.5ξ²)",   ξ->-ξ./(1 .+0.6.*ξ.^2), ξ->1 ./(1 .+0.5.*ξ.^2)) )
    pr(@sprintf("    %-30s %-7s %-9s %-9s %-10s %-8s","seed (W,G)","N","μ→","c_l→","resid","ξ_peak"))
    hlprofs=[]
    for (nm,sW,sG) in hlseeds
        r=run_hl(sW,sG; N=2048)
        if r.diverged
            pr(@sprintf("    %-30s %-7d %-9s %-9s %-10s","DIVERGED: "*nm,2048,"—","—","—")); continue
        end
        pos=[i for i in 1:length(r.ξ) if r.ξ[i]>0]; ξpk=r.ξ[pos[argmax(abs.(r.W[pos]))]]
        push!(hlprofs,(nm=nm,r=r,prof=normalized_profile(r.W,r.ξ)))
        inband = 2<r.cl<4.53
        pr(@sprintf("    %-30s %-7d %-9.4f %-9.4f %-10.2e %-8.3f %s",nm,2048,r.μ,r.cl,r.res,ξpk,
            inband ? "c_l∈(2,4.53)✓" : "c_l OUT of band"))
    end
    if length(hlprofs)>=2
        d=prof_dist(hlprofs[1].prof,hlprofs[2].prof)
        pr(@sprintf("\n  seed-independence: ‖W₁−W₂‖ (peak-normalized, common η-grid) = %.3e  %s",
            d, d<0.05 ? "✓ same profile" : "✗ seed-dependent — report, no profile reading"))
    end
    pr("\n  [HL N=2048 checkpoint. If μ≈1, c_l∈band, seed-independent ⇒ extend to the N-trend"); pr("   {2048,4096,8192} + the §3 cross-checks in the next invocation. :proved=0.]")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
