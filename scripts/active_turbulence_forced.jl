#!/usr/bin/env julia
# active_turbulence_forced.jl — NS-042 (Phase 1): the PASSIVE forced-turbulence control.
#
# SCOPE: phenomenology / 2D forced-turbulence truncation. **NOT the NS PDE.**
#
# Before adding active agents (Phase 2), prove the FAITHFUL fluid (NS-041) is a real
# turbulence engine: force it with a standard band-limited (passive, steady random)
# vorticity forcing at an injection scale k_f, dissipate by real ν∇² at small scales
# and a large-scale drag, and check it reaches a statistically steady state with the
# canonical 2D DUAL CASCADE — a forward ENSTROPHY cascade E(k) ~ k^{-3} for k>k_f
# (Kraichnan) and an inverse ENERGY range for k<k_f. This is the control that licenses
# trusting the fluid under agents, and the sharp contrast with the fluoddity engine
# (whose uniform drag has NO inertial range; its spectral slope was a forcing-dial).
#
# Vorticity form, IF-RK4 (exact ν∇² + drag via integrating factor), 2/3 dealias —
# the NS-041 fluid with: (1) a low-k Rayleigh drag −μ (arrests the inverse cascade so
# a steady state exists); (2) a steady band-limited vorticity forcing S at k_f.
# Std-lib only.
#
# AT-04 (→ TEST_SPEC T-18): a statistically steady state whose forward (k>k_f) range
# is a STEEP enstrophy cascade (slope ≈ −3, clearly steeper than the inverse range) —
# the dual-cascade signature a real 2D NS fluid has and the fluoddity dial does not.

using Printf
using Random

function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1
        while j & bit != 0; j ⊻= bit; bit>>=1; end
        j |= bit
        if i<j; t=a[i+1]; a[i+1]=a[j+1]; a[j+1]=t; end
    end
    len=2
    while len<=N
        wlen=cis((inv ? 2π : -2π)/len); i=0
        while i<N
            w=ComplexF64(1)
            for k in 0:(len>>1)-1
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w
                a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end
    a
end
function fft2(Ar)
    A=ComplexF64.(Ar); N=size(A,1)
    for i in 1:N; r=A[i,:]; fft!(r); A[i,:]=r; end
    for jc in 1:N; c=A[:,jc]; fft!(c); A[:,jc]=c; end
    A
end
function ifft2(A)
    B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for jc in 1:N; c=B[:,jc]; fft!(c;inv=true); B[:,jc]=c; end
    B
end
keff(k,N)= k<=N>>1 ? k : k-N
function make_ops(N)
    kx=[Float64(keff(a-1,N)) for a in 1:N, b in 1:N]
    ky=[Float64(keff(b-1,N)) for a in 1:N, b in 1:N]
    k2=kx.^2 .+ ky.^2
    k2p=copy(k2); k2p[1,1]=1.0
    cut=N÷3
    deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut for a in 1:N, b in 1:N]
    return (kx=kx,ky=ky,k2=k2,k2p=k2p,deal=deal)
end

# nonlinear advection (Fourier); viscosity+drag are in the integrating factor
function nonlin(W, op)
    ψ = W ./ op.k2p; ψ[1,1] = 0
    u  = real.(ifft2(-im .* op.ky .* ψ))
    v  = real.(ifft2( im .* op.kx .* ψ))
    ωx = real.(ifft2( im .* op.kx .* W))
    ωy = real.(ifft2( im .* op.ky .* W))
    Aadv = fft2(u .* ωx .+ v .* ωy); Aadv[.!op.deal] .= 0
    return -Aadv
end

# IF-RK4 with G(W)=nonlin(W)+S (S steady forcing); E,E2 = exp(L·dt), exp(L·dt/2)
function step!(W, dt, op, S, E, E2)
    k1 = dt .* (nonlin(W, op) .+ S)
    k2 = dt .* (nonlin(E2 .* (W .+ k1 ./ 2), op) .+ S)
    k3 = dt .* (nonlin(E2 .* W .+ k2 ./ 2, op) .+ S)
    k4 = dt .* (nonlin(E .* W .+ E2 .* k3, op) .+ S)
    @. W = E*W + (E*k1 + 2*E2*(k2+k3) + k4)/6
    return W
end

# steady band-limited vorticity forcing, physical rms = amp (generated once)
function make_forcing(op, N, kf, amp, seed)
    rng = MersenneTwister(seed)
    ann = [ (kf-1.0 <= sqrt(op.k2[a,b]) <= kf+1.0) ? 1.0 : 0.0 for a in 1:N, b in 1:N ]
    Sp = real.(ifft2(fft2(randn(rng, N, N)) .* ann))   # real band-limited field
    s = sqrt(sum(Sp.^2)/length(Sp))
    s > 0 && (Sp .*= amp / s)
    return fft2(Sp)
end

# 2D energy spectrum E(k) = ½ Σ_shell |ω̂|²/|k|²  (radial bins)
function spectrum(W, op, N)
    cut = N÷3; Ek = zeros(cut)
    for a in 1:N, b in 1:N
        k = round(Int, sqrt(op.k2[a,b]))
        (1 <= k <= cut) && (Ek[k] += 0.5*abs2(W[a,b])/op.k2p[a,b])
    end
    return Ek
end
function fitslope(Ek, klo, khi)
    xs=Float64[]; ys=Float64[]
    for k in klo:khi
        (k>=1 && k<=length(Ek) && Ek[k]>0) && (push!(xs, log(Float64(k))); push!(ys, log(Ek[k])))
    end
    length(xs)<3 && return (0.0, 0.0)
    xm=sum(xs)/length(xs); ym=sum(ys)/length(ys)
    sxx=sum((xs.-xm).^2); b = sum((xs.-xm).*(ys.-ym))/sxx
    yhat = b.*(xs.-xm).+ym; ss=sum((ys.-yhat).^2); tot=sum((ys.-ym).^2)
    return (b, tot>0 ? 1-ss/tot : 0.0)
end
energy(W,op)    = 0.5*sum(abs2.(W)./op.k2p)/length(W)^2
enstrophy(W)    = 0.5*sum(abs2.(W))/length(W)^2

function main()
    out=joinpath(@__DIR__,"active_turbulence_forced.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout))
    bar="═"^78
    pr(bar); pr("  active_turbulence_forced.jl — NS-042 Phase 1: PASSIVE forced-turbulence control")
    pr("  Scope: phenomenology (2D forced-turbulence truncation). NOT the NS PDE.")
    pr(bar)

    # ── parameters ──
    N=128; op=make_ops(N); cut=N÷3
    kf=8.0; ν=1.5e-4; μ=0.5; kdrag=3.0; amp=4.0; dt=0.005
    warmup=2500; accum=600; sample=5
    pr(@sprintf("\n  N=%d (cut=%d), k_f=%.0f, ν=%.1e, drag μ=%.2f (k<%.0f), amp=%.1f, dt=%.3f",
        N, cut, kf, ν, μ, kdrag, amp, dt))
    pr(@sprintf("  warmup=%d steps, then average E(k) over %d steps (every %d).", warmup, accum, sample))

    # integrating factor: exact ν∇² (all k) + Rayleigh drag (low k only)
    drag = [ sqrt(op.k2[a,b]) < kdrag ? μ : 0.0 for a in 1:N, b in 1:N ]
    L  = -(ν .* op.k2 .+ drag)
    E  = exp.(L .* dt); E2 = exp.(L .* (dt/2))
    S  = make_forcing(op, N, kf, amp, 1234)

    W = fft2(1e-3 .* randn(MersenneTwister(7), N, N))   # tiny seed
    pr("\n  spinning up to statistical steady state…")
    pr(@sprintf("    %-8s %-12s %-12s", "step","E","Z"))
    for s in 1:warmup
        step!(W, dt, op, S, E, E2)
        if s % (warmup÷6) == 0
            pr(@sprintf("    %-8d %-12.5f %-12.3f", s, energy(W,op), enstrophy(W)))
        end
    end

    Eacc = zeros(cut); nacc=0
    for s in 1:accum
        step!(W, dt, op, S, E, E2)
        if s % sample == 0; Eacc .+= spectrum(W, op, N); nacc += 1; end
    end
    Ek = Eacc ./ max(1,nacc)

    kfi = round(Int, kf)
    binv, rinv = fitslope(Ek, 2, kfi-2)                 # inverse-energy range  (k<k_f)
    bfwd, rfwd = fitslope(Ek, kfi+2, round(Int,0.6cut)) # forward-enstrophy range (k>k_f)
    pr(@sprintf("\n  STEADY STATE (avg over %d snapshots): E=%.4f  Z=%.3f", nacc, energy(W,op), enstrophy(W)))
    pr("\n  E(k) (every 2nd k):")
    for k in 1:2:cut
        bar2 = "#"^clamp(round(Int, 10+5*log(max(Ek[k],1e-30))), 0, 60)
        pr(@sprintf("    k=%2d  E=%.4e  %s", k, Ek[k], bar2))
    end
    pr(@sprintf("\n  inverse range  k∈[2,%d]   slope = %+.2f (R²=%.2f)   [2D expects ~ -5/3]", kfi-2, binv, rinv))
    pr(@sprintf("  forward range  k∈[%d,%d]  slope = %+.2f (R²=%.2f)   [2D enstrophy cascade ~ -3]",
        kfi+2, round(Int,0.6cut), bfwd, rfwd))

    # AT-04: forward range is a steep enstrophy cascade AND steeper than the inverse range
    at04 = (bfwd < -2.3) && (rfwd > 0.85) && (bfwd < binv - 0.5)
    pr(@sprintf("\n  AT-04 (dual cascade: steep forward enstrophy range, distinct from inverse): %s",
        at04 ? "PASS" : "CHECK — tune ν/k_f/amp"))
    pr("\n"*bar)
    pr("  • A real 2D NS fluid: forward range STEEP (enstrophy cascade ~ -3), inverse range shallower —")
    pr("    the dual-cascade structure fluoddity's uniform-drag dial lacks (NS-041 vs the dial).")
    pr("  • FIREWALL: Scope phenomenology, NOT the PDE. Distance to prize: UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
    return at04
end

ok = main()
exit(ok ? 0 : 1)
