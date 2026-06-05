#!/usr/bin/env julia
# active_turbulence_fluid.jl — NS-041 (Phase 0): the FAITHFUL 2D fluid.
#
# SCOPE: phenomenology / 2D forced-active-turbulence truncation. **NOT the NS PDE.**
# Nothing here bears on global regularity; this is the fluid substrate for an
# active-matter (active-turbulence) phenomenology study — the rigorous version of
# the fluoddity agent engine.
#
# This extends the validated 2D vorticity–streamfunction pseudospectral solver
# (scripts/spectral_2d_control.jl, NS-010 Stage-1c) with the two pieces the
# active-matter track needs, while keeping its exact, dealiased, invariant-
# conserving core:
#   (1) EXACT viscosity via an INTEGRATING FACTOR (IF-RK4): the linear term −νk²
#       is integrated exactly (exp(−νk²dt)), RK4 only the nonlinear+forcing part.
#       This is non-stiff (dt limited by advective CFL only) and makes the ν>0
#       decay machine-exact — the faithful replacement for fluoddity's scale-
#       independent uniform drag (which has NO inertial range).
#   (2) a curl-of-force RHS HOOK: an external body force f(x) enters the vorticity
#       equation as (∇×f)_z = i(k_x f̂_y − k_y f̂_x). In vorticity form the curl
#       AUTO-DISCARDS f's compressive part, so active forcing couples with NO extra
#       projection. Here f≡0 (Phase 0 validates the bare fluid); agents arrive in
#       Phase 2.
#
# Vorticity form: ω_t + u·∇ω = νΔω + (∇×f)_z,  u=∇⊥ψ,  Δψ=−ω  ⇒ ψ̂=ω̂/|k|².
# Std-lib only (hand-rolled radix-2 FFT, as in Stage 1b/1c). State stored as ω̂
# (Fourier) so the integrating factor (diagonal in k) is exact.

using Printf
#
# Validation (becomes TEST_SPEC T-15/T-16):
#   AT-01 — unforced inviscid (ν=0,f=0): energy AND enstrophy conserved (2D Euler
#           Tier-1 invariants) — regression vs spectral_2d_control.jl (T-05).
#   AT-02 — viscous decay (ν>0,f=0): a single Fourier mode (an exact 2D-Euler
#           steady state — u·∇ω≡0 for one mode) must decay as exp(−ν|k|²t),
#           matching the closed form to machine precision (licenses IF-RK4).

# ── 1D radix-2 FFT (as in Stage 1b/1c), 2D via rows-then-columns ──
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
    k2p=copy(k2); k2p[1,1]=1.0                 # guard the (0,0) mode for ψ
    cut=N÷3
    deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut for a in 1:N, b in 1:N]
    return (kx=kx,ky=ky,k2=k2,k2p=k2p,deal=deal)
end

# ── nonlinear + forcing term in FOURIER space (viscosity handled by the IF) ──
# N(ω̂) = −dealias( FFT(u·∇ω) ) + (∇×f)_z.  fhat = (x=f̂_x, y=f̂_y) or `nothing`.
function nonlin(W, op; fhat=nothing)
    ψ = W ./ op.k2p; ψ[1,1] = 0
    u  = real.(ifft2(-im .* op.ky .* ψ))
    v  = real.(ifft2( im .* op.kx .* ψ))
    ωx = real.(ifft2( im .* op.kx .* W))
    ωy = real.(ifft2( im .* op.ky .* W))
    Aadv = fft2(u .* ωx .+ v .* ωy)
    Aadv[.!op.deal] .= 0                        # 2/3 dealias the nonlinear term
    Nl = -Aadv
    if fhat !== nothing                         # curl of the body force, (∇×f)_z
        Nl .+= im .* (op.kx .* fhat.y .- op.ky .* fhat.x)
        Nl[.!op.deal] .= 0
    end
    return Nl
end

# ── integrating-factor RK4: exact on −νk², RK4 on the (non-stiff) nonlinear part ──
function step_ifrk4!(W, dt, ν, op; fhat=nothing)
    L  = -ν .* op.k2
    E  = exp.(L .* dt); E2 = exp.(L .* (dt/2))
    k1 = dt .* nonlin(W, op; fhat=fhat)
    k2 = dt .* nonlin(E2 .* (W .+ k1 ./ 2), op; fhat=fhat)
    k3 = dt .* nonlin(E2 .* W .+ k2 ./ 2, op; fhat=fhat)
    k4 = dt .* nonlin(E .* W .+ E2 .* k3, op; fhat=fhat)
    @. W = E*W + (E*k1 + 2*E2*(k2+k3) + k4)/6
    return W
end

# ── diagnostics (from real-space ω) ──
function velocity(ω, op)
    W=fft2(ω); ψ=W./op.k2p; ψ[1,1]=0
    real.(ifft2(-im.*op.ky.*ψ)), real.(ifft2(im.*op.kx.*ψ))
end
energy(ω,op) = (uv=velocity(ω,op); 0.5*sum(uv[1].^2 .+ uv[2].^2)/length(ω))
enstrophy(ω) = 0.5*sum(ω.^2)/length(ω)
ωreal(W)     = real.(ifft2(W))

function main()
    out=joinpath(@__DIR__,"active_turbulence_fluid.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  active_turbulence_fluid.jl — NS-041 Phase 0: the FAITHFUL 2D fluid")
    pr("  Scope: phenomenology (2D active-turbulence truncation). NOT the NS PDE.")
    pr("  Faithful vs fluoddity: uniform-drag → exact ν∇² (IF-RK4); + curl-of-force hook (f≡0 here).")
    pr(bar)

    # FFT2 round-trip self-check (same as the Stage-1c control)
    let N=8, A=[Float64(a+2b) for a in 1:N, b in 1:N]
        rt=maximum(abs.(real.(ifft2(fft2(A))).-A))
        pr(@sprintf("\n  2D-FFT roundtrip self-check: max err = %.1e %s", rt, rt<1e-10 ? "✓" : "✗"))
    end

    # ── AT-01: unforced inviscid (ν=0, f=0) — energy + enstrophy conserved ──────
    N=128; op=make_ops(N)
    x=[2π*(i-1)/N for i in 1:N]
    ω0=[sin(x[a])*cos(x[b]) + 0.5*sin(2x[a]+x[b]) for a in 1:N, b in 1:N]
    W=fft2(ω0); E0=energy(ω0,op); Z0=enstrophy(ω0)
    pr(@sprintf("\n  (AT-01) 2D EULER (ν=0, f=0), N=%d. Energy & enstrophy must be conserved.", N))
    pr(@sprintf("    %-6s %-14s %-14s", "t","E/E0","Z/Z0"))
    pr(@sprintf("    %-6.1f %-14.8f %-14.8f", 0.0, 1.0, 1.0))
    dt=0.004; maxEdrift=0.0; maxZdrift=0.0
    for t in 1:4
        for _ in 1:Int(round(1.0/dt)); step_ifrk4!(W, dt, 0.0, op); end
        w=ωreal(W); eR=energy(w,op)/E0; zR=enstrophy(w)/Z0
        maxEdrift=max(maxEdrift, abs(eR-1)); maxZdrift=max(maxZdrift, abs(zR-1))
        pr(@sprintf("    %-6.1f %-14.8f %-14.8f", Float64(t), eR, zR))
    end
    at01 = maxEdrift < 1e-6
    pr(@sprintf("  ⇒ energy drift %.2e (<1e-6 %s); enstrophy drift %.2e (leaks only at the 2/3",
        maxEdrift, at01 ? "✓" : "✗", maxZdrift))
    pr("    cutoff — same honest caveat as the Stage-1c control, T-05). AT-01: " * (at01 ? "PASS" : "CHECK"))

    # ── AT-02: viscous single-mode decay vs closed form exp(−ν|k|²t) ────────────
    pr("\n"*dsh); pr("  (AT-02) VISCOUS single-mode decay (ν>0, f=0): a single Fourier mode is an")
    pr("  exact 2D-Euler steady state (u·∇ω≡0) ⇒ must decay as exp(−ν|k|²t) to machine precision.")
    pr(dsh)
    N2=64; op2=make_ops(N2); ν=0.05; kx0=3; ky0=2; k2m=Float64(kx0^2+ky0^2)
    y=[2π*(j-1)/N2 for j in 1:N2]
    ω1=[cos(kx0*(2π*(i-1)/N2) + ky0*(2π*(j-1)/N2)) for i in 1:N2, j in 1:N2]
    W2=fft2(ω1); A0=abs(W2[kx0+1, ky0+1])
    pr(@sprintf("    mode k=(%d,%d), |k|²=%.0f, ν=%.3f.   %-12s %-12s %-10s",
        kx0,ky0,k2m,ν,"|ŵ|/|ŵ0|","exp(−νk²t)","rel.err"))
    dt2=0.01; maxerr=0.0
    for t in 1:5
        for _ in 1:Int(round(0.4/dt2)); step_ifrk4!(W2, dt2, ν, op2); end
        tt=0.4*t
        meas=abs(W2[kx0+1, ky0+1])/A0; pred=exp(-ν*k2m*tt); err=abs(meas-pred)/pred
        maxerr=max(maxerr, err)
        pr(@sprintf("    t=%-4.1f                              %-12.6e %-12.6e %-10.2e", tt, meas, pred, err))
    end
    at02 = maxerr < 1e-6
    pr(@sprintf("  ⇒ max relative error vs closed form: %.2e (<1e-6 %s). AT-02: %s",
        maxerr, at02 ? "✓" : "✗", at02 ? "PASS" : "CHECK"))

    pr("\n"*bar); pr("  READING (NS-041 Phase 0)")
    pr(bar)
    pr("  • The faithful 2D fluid conserves the 2D-Euler invariants (AT-01) and integrates real")
    pr("    viscosity EXACTLY (AT-02, IF-RK4) — the cascade-bearing fix over fluoddity's uniform drag.")
    pr("  • The curl-of-force hook is in place (f≡0 here); active-dipole agents couple through it")
    pr("    in Phase 2 with no extra projection (vorticity form discards f's compressive part).")
    pr("  • FIREWALL: Scope phenomenology, NOT the PDE. Distance to prize: UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
    return at01 && at02
end

ok = main()
exit(ok ? 0 : 1)
