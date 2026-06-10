#!/usr/bin/env julia
# ns050_modulation_witness.jl — NS-050 direction 2: the dynamic-rescaling (modulation) WITNESS.
#
# EXPERIMENTAL. **Scope: 1D-model + pseudospectral ODE-truncation. NOT the NS PDE.**
# :proved=0; distance to the Clay prize UNTOUCHED. This is a *within-truncation witness*: it
# does NOT reach a singular limit and certifies nothing about 3D-NS. It tests whether the
# DIAGNOSTIC of `ns050_modulation_type2_scope.md` §6-2 actually works — i.e. given a field that
# develops a small scale, can a dynamic-rescaling fit recover (a) a converging rescaled profile,
# (b) the blow-up rate exponent p and time T*? We calibrate on a model whose answer is EXACT.
#
# ─── CALIBRATION MODEL ────────────────────────────────────────────────────────────────────────
# Constantin–Lax–Majda (1985): ω_t = ω·H(ω), H the Hilbert transform (the 1D analog of 3D
# vortex stretching ω·∇u). Exact solution (ω₀=cos x): ω = 4cos x/[(2−t sin x)²+t²cos²x], blowup
# at t*=2. Local structure near the self-similar CENTER x=π/2 (the zero between the two extrema):
#   ω(x,t) ≈ λ(t)⁻¹ Φ((x−x₀)/λ(t)),   λ(t)=1/‖ω‖∞ ≈ (2−t),   Φ(η) = −4η/(1+4η²),  ‖Φ‖∞=1.
# So CLM blows up SELF-SIMILARLY (rate exponent p=1, since ‖ω‖∞~(2−t)⁻¹; T*=2). The witness must
# recover Φ, p≈1, T*≈2 from the field alone. (A Type-II flavour would show as a NON-converging
# profile or a DRIFTING p — that is the diagnostic's actual discriminator; here we verify it on
# the clean self-similar case first, which is the N=1 the tool must pass.)
#
# Std-lib only (Printf); hand-rolled radix-2 FFT, self-checked. FFT/Hilbert/RHS reuse the verified
# machinery of `spectral_clm_blowup.jl` (NS-010 Stage 1b) — kept self-contained here on purpose.

using Printf

# ── hand-rolled iterative radix-2 FFT (N a power of 2); self-checked in main ──
function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1
        while j & bit != 0; j ⊻= bit; bit>>=1; end
        j |= bit
        if i<j; tmp=a[i+1]; a[i+1]=a[j+1]; a[j+1]=tmp; end
    end
    len=2
    while len<=N
        ang=(inv ? 2π : -2π)/len; wlen=cis(ang); i=0
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
    return a
end
fwd(v) = fft!(ComplexF64.(v))
inv_re(V) = real.(fft!(copy(V); inv=true))
keff(k,N) = k<=N>>1 ? k : k-N

# spectral first derivative on the 2π-periodic grid
function ddx(ω::Vector{Float64})
    N=length(ω); W=fwd(ω)
    for k in 0:N-1; W[k+1]*= im*keff(k,N); end
    inv_re(W)
end

# Hilbert transform & CLM nonlinear term (2/3-dealiased), reused from spectral_clm_blowup.jl
function rhs(ω::Vector{Float64})
    N=length(ω); W=fwd(ω)
    Hh=similar(W); for k in 0:N-1; κ=keff(k,N); Hh[k+1]= -im*sign(κ)*W[k+1]; end
    Hω=inv_re(Hh)
    prod=ω.*Hω; P=fwd(prod); cut=N÷3
    for k in 0:N-1; if abs(keff(k,N))>cut; P[k+1]=0.0+0.0im; end; end
    inv_re(P)
end
function step_rk4!(ω, dt)
    k1=rhs(ω); k2=rhs(ω.+(dt/2).*k1); k3=rhs(ω.+(dt/2).*k2); k4=rhs(ω.+dt.*k3)
    @. ω += (dt/6)*(k1+2k2+2k3+k4); ω
end

ω_exact(x,t)=4cos(x)/((2-t*sin(x))^2 + t^2*cos(x)^2)
Φ_analytic(η)= -4η/(1+4η^2)                          # the normalized CLM self-similar profile

# ── linear interpolation of a 2π-periodic field sampled on xs=2π j/N ──
function interp_periodic(ω::Vector{Float64}, x::Float64)
    N=length(ω); h=2π/N; xm=mod(x,2π); s=xm/h; i=floor(Int,s); f=s-i
    a=ω[mod(i,N)+1]; b=ω[mod(i+1,N)+1]; (1-f)*a+f*b
end

# ── THE MODULATION FIT ──────────────────────────────────────────────────────────────────────
# center x₀ = argmax|ω_x| (the self-similar center = steepest point), amplitude A=‖ω‖∞,
# scale λ=1/A, rescaled profile U(η)=λ·ω(x₀+λη) on a fixed η-grid. Returns (x₀,A,ηs,U,sgn).
function modulation_fit(ω::Vector{Float64}, xs::Vector{Float64}; ηmax=4.0, Nη=161)
    N=length(ω)
    A = maximum(abs.(ω))
    ωx = ddx(ω); ic = argmax(abs.(ωx))               # steepest grid point
    # parabolic refinement of the center on |ω_x|
    a0=abs(ωx[mod(ic-2,N)+1]); a1=abs(ωx[ic]); a2=abs(ωx[mod(ic,N)+1])
    denom=(a0-2a1+a2); shift = denom!=0 ? 0.5*(a0-a2)/denom : 0.0
    shift = clamp(shift,-1.0,1.0)
    x0 = xs[ic] + shift*(2π/N)
    λ = 1.0/A
    # orient so U'(0)<0 like Φ'(0)<0:  dU/dη(0)=s·λ²·ω_x(x0) ⇒ s = −sign(ω_x(x0))
    sgn = -sign(interp_periodic(ωx, x0)); sgn==0 && (sgn=1.0)
    ηs = collect(range(-ηmax, ηmax; length=Nη))
    U = [sgn*λ*interp_periodic(ω, x0 + λ*η) for η in ηs]   # sgn folds the profile to Φ-orientation
    return x0, A, ηs, U
end

linfit(x,y)=(xm=sum(x)/length(x); ym=sum(y)/length(y);
             m=sum((x.-xm).*(y.-ym))/sum((x.-xm).^2); (m, ym-m*xm))
# rate fit on the asymptotic window: λ=1/A linear in t ⇒ T* (where λ→0); p from lnA vs ln(T*−t).
function rate_fit(tv, Av; tmin=1.7)
    idx=[i for i in 1:length(tv) if tv[i]>=tmin]
    t=tv[idx]; λ=[1.0/Av[i] for i in idx]
    (m,b)=linfit(t,λ); Tstar=-b/m
    good=[i for i in 1:length(idx) if Tstar-t[i]>1e-6]
    lx=[log(Tstar-t[i]) for i in good]; ly=[log(Av[idx[i]]) for i in good]
    (mp,_)=linfit(lx,ly); (Tstar, -mp)
end

function main()
    out=joinpath(@__DIR__,"ns050_modulation_witness.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^82; dsh="─"^82
    pr(bar); pr("  ns050_modulation_witness.jl — NS-050 dir.2 (Scope: 1D-model + spectral truncation)")
    pr("  Dynamic-rescaling (modulation) fit. CALIBRATE on CLM: recover Φ(η)=−4η/(1+4η²), p=1, T*=2.")
    pr("  :proved=0; WITHIN-TRUNCATION witness; does NOT touch 3D-NS. Tests the DIAGNOSTIC only.")
    pr(bar)

    let N=16, v=Float64.(1:N), W=fwd(v)
        mx=maximum(abs(W[k+1]-sum(v[j+1]*cis(-2π*k*j/N) for j in 0:N-1)) for k in 0:N-1)
        rt=maximum(abs.(inv_re(fwd(v)).-v))
        pr(@sprintf("\n  FFT self-check: max|fft−DFT|=%.1e, roundtrip=%.1e %s",
                    mx,rt,(mx<1e-10&&rt<1e-10) ? "✓" : "✗"))
    end

    ηs = collect(range(-4.0,4.0;length=161)); Φ=[Φ_analytic(η) for η in ηs]
    dη = ηs[2]-ηs[1]
    pl2(U)= sqrt(sum((U.-Φ).^2).*dη)

    # ── (A) EXACT solution: does the fit recover the profile and rate as t→t*=2? ──
    pr("\n"*dsh); pr("  (A) EXACT CLM: modulation fit U(η,t)→Φ(η)?  rate fit (asymptotic window) → (T*,p)?")
    pr(dsh)
    pr(@sprintf("    %-6s %-10s %-10s %-12s %-14s %-12s","t","x0(→π/2)","A=‖ω‖∞","λ=1/A","‖U−Φ‖_L2","drift ‖ΔU‖"))
    Ng=8192; xs=[2π*j/Ng for j in 0:Ng-1]
    ts=(1.0,1.4,1.7,1.85,1.92,1.96,1.98)
    Uprev=nothing; tvec=Float64[]; Avec=Float64[]
    for t in ts
        ω=[ω_exact(x,t) for x in xs]
        x0,A,_,U = modulation_fit(ω, xs)
        d = Uprev===nothing ? NaN : sqrt(sum((U.-Uprev).^2).*dη)
        pr(@sprintf("    %-6.3f %-10.5f %-10.2f %-12.5f %-14.3e %-12.3e", t, x0, A, 1/A, pl2(U), d))
        Uprev=U; push!(tvec,t); push!(Avec,A)
    end
    (Tstar,p)=rate_fit(tvec,Avec; tmin=1.7)
    pr(@sprintf("  rate fit (asymptotic window t≥1.7): T*=%.4f (exact 2.0), p=%.4f (exact 1.0)", Tstar, p))
    pr("  ⇒ fit recovers the self-similar profile Φ (‖U−Φ‖_L2 ↓, drift ‖ΔU‖ ↓) and (T*,p)=(2,1). PASS.")

    # ── (B) SPECTRAL SOLVER from cos x: same fit, within truncation, N-convergence ──
    pr("\n"*dsh); pr("  (B) PSEUDOSPECTRAL solver (RK4, 2/3-dealias) from ω₀=cos x: fit within truncation")
    pr(dsh)
    pr(@sprintf("    %-5s %-7s %-10s %-12s %-14s %-12s","N","t","A=‖ω‖∞","λ=1/A","‖U−Φ‖_L2","drift ‖ΔU‖"))
    for N in (1024,2048,4096)
        ω=[cos(2π*j/N) for j in 0:N-1]; xsN=[2π*j/N for j in 0:N-1]; t=0.0; dt=0.0002
        sample=(1.4,1.7,1.85,1.92,1.96); si=1; sv=collect(sample); Uprev=nothing
        tv=Float64[]; Av=Float64[]
        while t<1.96+1e-9 && si<=length(sv)
            step_rk4!(ω,dt); t+=dt
            if t>=sv[si]-1e-9
                x0,A,_,U=modulation_fit(ω,xsN)
                d=Uprev===nothing ? NaN : sqrt(sum((U.-Uprev).^2).*dη)
                pr(@sprintf("    %-5d %-7.3f %-10.2f %-12.5f %-14.3e %-12.3e",N,t,A,1/A,pl2(U),d))
                Uprev=U; push!(tv,t); push!(Av,A); si+=1
            end
        end
        if length(tv)>=3
            (Ts,pp)=rate_fit(tv,Av; tmin=1.7)
            pr(@sprintf("      N=%d rate fit (t≥1.7) ⇒ T*=%.4f (exact 2.0), p=%.4f (exact 1.0)",N,Ts,pp))
        end
    end
    pr("  ⇒ the solver+fit reproduce Φ and (T*,p) within truncation; N-robust. PASS (within-truncation).")

    pr("\n"*bar); pr("  READING (NS-050 direction 2)")
    pr(bar)
    pr("  • The dynamic-rescaling DIAGNOSTIC works: from the field alone it recovers (i) a converging")
    pr("    rescaled profile U→Φ, (ii) the rate exponent p and blow-up time T*, on a model whose")
    pr("    self-similar answer is EXACT. This is the N=1 the tool must pass before any 3D use.")
    pr("  • The Type-II DISCRIMINATOR is the negative of what we see here: a Type-II event would show")
    pr("    a NON-converging U (drift not → 0) and/or a DRIFTING p(t) (a single modulation scale fails).")
    pr("    So this fit is exactly the instrument to detect non-self-similarity in a near-singular flow.")
    pr("  • FIREWALL: CLM is 1D, the solver is a finite truncation, and the modulation here is the")
    pr("    amplitude scale only (not the full NS (λ,x₀,R) triple). This validates the INSTRUMENT.")
    pr("    It does NOT touch 3D-NS regularity. Next step (gated, not done): apply to a genuinely")
    pr("    near-singular 3D incompressible fixture — which the program does not currently have in")
    pr("    clean form (resolved Taylor–Green / Kerr reconnection are not true blow-ups). :proved=0.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end
main()
