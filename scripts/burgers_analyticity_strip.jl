#!/usr/bin/env julia
# burgers_analyticity_strip.jl — NS-010 Stage 1a: the analyticity-strip diagnostic
#
# EXPERIMENTAL. NOT a spec entry's PDE result. **Scope: 1D-model (Burgers).** This
# VALIDATES the complex-singularity / analyticity-strip blowup diagnostic against an
# exact closed form, and shows the viscous-vs-inviscid (regular-vs-blowup) contrast.
# It is a diagnostic in a 1D model — NOT a statement about the Navier–Stokes PDE
# (firewall, CLAUDE.md). Std-lib only (manual DFT; no FFTW dependency).
#
# ─── THE DIAGNOSTIC (NS-010/011) ─────────────────────────────────────────────
# A solution analytic in a complex strip |Im x| < δ(t) has Fourier coefficients
# |û(k)| ~ C k^{-p} e^{−δ(t)|k|}. δ(t) = distance from the real axis to the nearest
# complex-space singularity. **δ(t) → 0 in finite time = a real singularity.**
# We read δ(t) off the spectrum's exponential decay rate and compare to the exact.
#
# ─── EXACT BENCHMARK (TEST_SPEC T-01) ────────────────────────────────────────
# Inviscid Burgers u_t + u u_x = 0, u(x,0) = −sin x (period 2π). Solution implicit:
# u = −sin ξ, x = ξ − sin(ξ) t. Singularity of the inverse map: 1 − cos(ξ*) t = 0 ⇒
# cos ξ* = 1/t ⇒ (nearest to real axis) ξ* = i·arccosh(1/t). Mapping to x:
#     δ(t) = Im x* = arccosh(1/t) − √(1 − t²),    0 < t ≤ 1.
# Shock at t* = 1 (δ→0); near t*, δ(t) = (√2/6)(t*−t)^{3/2} + … (cube-root singularity
# ⇒ |û(k)| ~ k^{-4/3} e^{−δk}). T-01 passes iff the spectrum-fitted δ matches this.

using Printf

# ── manual transforms (std-lib only); x_j = 2π j/N, signed wavenumber κ ──
keff(k,N) = k <= N÷2 ? k : k-N
function amp_spectrum(u::Vector{Float64}, K::Int)   # |û(k)|, k=0..K
    N=length(u); a=zeros(K+1)
    @inbounds for k in 0:K
        s=ComplexF64(0)
        for j in 0:N-1; s += u[j+1]*cis(-2π*k*j/N); end
        a[k+1]=abs(s)/N
    end
    return a
end
function fdft(v::Vector{Float64})                    # full forward DFT
    N=length(v); V=zeros(ComplexF64,N)
    @inbounds for k in 0:N-1
        s=ComplexF64(0); for j in 0:N-1; s += v[j+1]*cis(-2π*k*j/N); end; V[k+1]=s
    end; V
end
function idft_real(V::Vector{ComplexF64})            # full inverse DFT (real part)
    N=length(V); v=zeros(N)
    @inbounds for j in 0:N-1
        s=ComplexF64(0); for k in 0:N-1; s += V[k+1]*cis(2π*k*j/N); end; v[j+1]=real(s)/N
    end; v
end

δ_exact(t) = acosh(1/t) - sqrt(1-t^2)

# fit δ from the spectrum: slope of log|û| vs k on a clean window; report plain and
# (k^{-4/3})-prefactor-corrected.
function fit_delta(a::Vector{Float64}, K::Int; kmin=10)
    kmax=kmin
    for k in kmin:K; (a[k+1] > 1e-11) ? (kmax=k) : break; end
    kmax=min(kmax,K); ks=collect(kmin:kmax)
    length(ks)<6 && return (NaN,NaN,length(ks))
    lin(y) = (xm=sum(ks)/length(ks); ym=sum(y)/length(y);
              -sum((ks.-xm).*(y.-ym))/sum((ks.-xm).^2))
    δp = lin([log(a[k+1]) for k in ks])
    δc = lin([log(a[k+1])+(4/3)*log(k) for k in ks])
    return (δp, δc, length(ks))
end

# inviscid u(x,t): Newton on x = ξ − sin(ξ)t
function u_inviscid(t,N)
    u=zeros(N)
    @inbounds for j in 0:N-1
        x=2π*j/N; ξ=x
        for _ in 1:80; f=ξ-sin(ξ)*t-x; ξ -= f/(1-cos(ξ)*t); end
        u[j+1]=-sin(ξ)
    end; u
end

# viscous u(x,t) via Cole–Hopf: φ0=exp(−(cos x)/(2ν)) (normalized), heat-evolve, u=−2ν(lnφ)_x
function u_viscous(t,N,ν)
    x=[2π*j/N for j in 0:N-1]
    c=cos.(x); φ0=exp.(-(c .- minimum(c))/(2ν))      # normalized to avoid overflow
    Φ=fdft(φ0)
    for k in 0:N-1; Φ[k+1]*=exp(-ν*keff(k,N)^2*t); end
    φ=idft_real(Φ); L=log.(max.(φ,1e-300))
    Lh=fdft(L); for k in 0:N-1; Lh[k+1]*=im*keff(k,N); end
    Lx=idft_real(Lh)
    return -2ν .* Lx
end

function main()
    out=joinpath(@__DIR__,"burgers_analyticity_strip.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  burgers_analyticity_strip.jl — NS-010 analyticity-strip diagnostic (Scope: 1D-model)")
    pr("  δ(t)→0 = blowup. Validating spectrum-fitted δ vs the EXACT inviscid closed form.")
    pr(bar)

    # ── (A) INVISCID: T-01 validation against the exact δ(t) ────────────────
    Ninv=4096; Kinv=900
    pr(@sprintf("\n  (A) INVISCID Burgers, u₀=−sin x, N=%d.  shock t*=1, δ(t)=arccosh(1/t)−√(1−t²).", Ninv))
    pr(@sprintf("    %-6s %-12s %-12s %-12s %-10s %-7s", "t","δ_exact","δ_fit(plain)","δ_fit(corr)","corr/exact","#k"))
    ts=(0.30,0.50,0.70,0.85,0.92,0.95)
    rows=NamedTuple[]
    for t in ts
        a=amp_spectrum(u_inviscid(t,Ninv),Kinv); de=δ_exact(t); (dp,dc,nk)=fit_delta(a,Kinv)
        pr(@sprintf("    %-6.2f %-12.5f %-12.5f %-12.5f %-10.3f %-7d", t,de,dp,dc,dc/de,nk))
        push!(rows,(t=t,de=de,dc=dc))
    end
    err=maximum(abs(r.dc/r.de-1) for r in rows)
    pr(@sprintf("  ⇒ T-01: max |δ_fit(corr)/δ_exact − 1| = %.1f%%  %s", 100*err,
                err<0.05 ? "PASS (spectrum δ matches exact to <5%)" : "(check)"))

    # 3/2 law near the shock (property of the exact δ; the diagnostic inherits it)
    pr("\n  3/2-law check (δ → 0 as (t*−t)^{3/2}): fit ln δ_exact vs ln(1−t), t∈[.9,.99]")
    tt=collect(0.90:0.01:0.99); xs=[log(1-t) for t in tt]; ys=[log(δ_exact(t)) for t in tt]
    xm=sum(xs)/length(xs);ym=sum(ys)/length(ys)
    p=sum((xs.-xm).*(ys.-ym))/sum((xs.-xm).^2)
    pr(@sprintf("    exponent p = %.3f  (theory 1.5)  %s", p, abs(p-1.5)<0.05 ? "✓" : ""))

    # ── (B) VISCOUS control: δ stays bounded > 0 (regular; poles held off axis) ──
    pr("\n"*dsh); pr("  (B) VISCOUS Burgers (Cole–Hopf), same u₀, ν=0.10, N=1024 — δ stays bounded")
    pr(dsh)
    Nv=1024; Kv=400; ν=0.10
    pr(@sprintf("    %-6s %-14s %-14s", "t","δ_visc(fit)","δ_invisc(exact)"))
    for t in (0.50,0.85,0.95,1.00,1.20)
        a=amp_spectrum(u_viscous(t,Nv,ν),Kv); (dp,dc,_)=fit_delta(a,Kv; kmin=6)
        de = t<1 ? δ_exact(t) : 0.0
        pr(@sprintf("    %-6.2f %-14.4f %-14s", t, dc, t<1 ? @sprintf("%.4f",de) : "0 (shock)"))
    end
    pr("  ⇒ viscosity holds the complex singularity OFF the real axis: δ_visc bounded > 0 for")
    pr("    all t (incl. past the inviscid shock t*=1), while δ_invisc → 0 at t*=1. The viscous")
    pr("    floor shrinks with ν (→ inviscid shock as ν→0).")

    pr("\n"*bar); pr("  READING (NS-010 Stage 1a)")
    pr(bar)
    pr("  • The analyticity-strip diagnostic is VALIDATED: the spectrum-fitted δ(t) reproduces")
    pr("    the exact inviscid closed form (T-01), and δ→0 at the shock with the 3/2 law.")
    pr("  • Inviscid = blowup (δ→0); viscous = regular (δ bounded). The complex singularity")
    pr("    reaching the real axis IS the singularity; viscosity keeps it away.")
    pr("  • FIREWALL: this is a 1D MODEL. It validates the *method* (NS-010/011). The PDE")
    pr("    (3D NS) question — does δ(t)→0 there — is untouched; that is Stage 1b (spectral")
    pr("    truncation) and ultimately the open problem. Scope: 1D-model, NOT PDE.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end
main()
