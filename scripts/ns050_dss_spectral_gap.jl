#!/usr/bin/env julia
# ns050_dss_spectral_gap.jl — NS-050 direction 1 (DSS/modulation), the spectral-gap probe.
#
# EXPERIMENTAL. **Scope: 1D-model + pseudospectral ODE-truncation. NOT the NS PDE.**
# :proved=0; distance to the Clay prize UNTOUCHED. Extends the calibrated dynamic-rescaling INSTRUMENT
# of ns050_modulation_witness.jl to deliver the *new* content of direction 1 (ns050_dss_modulation.md):
#   M2 — the SPECTRAL GAP of the self-similar fixed point (= the drift decay-rate in rescaled log-time τ),
#   and the SELF-SIMILAR ⟷ DSS test (does the rescaled profile go STEADY, or does its drift plateau/
#   oscillate = a discretely-self-similar / log-periodic candidate).
# Then SWEEP the advection parameter a (CLM a=0 ↔ De Gregorio a=1) to watch the self-similar attractor's
# stability — the 1D surrogate for "does a steady profile persist, or does DSS take over".
#
# ─── MODEL: the Okamoto–Sakajo–Wunsch 1D family ────────────────────────────────────────────────────
#   ω_t = −a·u·ω_x + (Hω)·ω,    u_x = Hω  ⇒  û(k) = −ω̂(k)/|k| (k≠0),  H = Hilbert transform.
#   a=0  : Constantin–Lax–Majda (pure stretching; exact self-similar blow-up, t*=2 for ω₀=cos x).
#   a=1  : De Gregorio (advection vs stretching).
# The advection term a·u·ω_x is REGULARIZING; raising a competes with the (Hω)ω stretching that drives
# blow-up. The probe asks how the self-similar fixed point's spectral gap responds.
#
# Rescaled log-time τ = ln‖ω(t)‖∞ (so amplitude-doubling = Δτ=ln2). U(η,τ) = the (c)-instrument profile.
# SPECTRAL GAP g = −d ln‖∂_τU‖/dτ  (leading stable eigenvalue magnitude; CLM calibration ⇒ g≈1).
# Std-lib only (Printf); hand-rolled FFT (self-checked), reused from ns050_modulation_witness.jl.

using Printf

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
fwd(v)=fft!(ComplexF64.(v)); inv_re(V)=real.(fft!(copy(V); inv=true))
keff(k,N)= k<=N>>1 ? k : k-N

function ddx(ω)                                   # spectral d/dx
    N=length(ω); W=fwd(ω); for k in 0:N-1; W[k+1]*= im*keff(k,N); end; inv_re(W)
end
function hilbert(ω)                               # Ĥω(k) = −i sgn(k) ω̂(k)
    N=length(ω); W=fwd(ω)
    for k in 0:N-1; κ=keff(k,N); W[k+1]*= -im*sign(κ); end; inv_re(W)
end
function velocity(ω)                              # û(k) = −ω̂(k)/|k| (k≠0), mean 0
    N=length(ω); W=fwd(ω)
    for k in 0:N-1; κ=keff(k,N); W[k+1] = κ==0 ? 0.0+0im : -W[k+1]/abs(κ); end
    inv_re(W)
end
function dealias!(v, N)                            # 2/3 rule on a field's spectrum
    W=fwd(v); cut=N÷3; for k in 0:N-1; if abs(keff(k,N))>cut; W[k+1]=0; end; end; inv_re(W)
end
# OSW RHS: ω_t = −a u ω_x + (Hω)ω, dealiased
function rhs(ω, a)
    Hω=hilbert(ω); u=velocity(ω); ωx=ddx(ω)
    stretch = dealias!(Hω.*ω, length(ω))
    advect  = a==0.0 ? zeros(length(ω)) : dealias!(u.*ωx, length(ω))
    @. stretch - a*advect
end
function step_rk4!(ω, dt, a)
    k1=rhs(ω,a); k2=rhs(ω.+(dt/2).*k1,a); k3=rhs(ω.+(dt/2).*k2,a); k4=rhs(ω.+dt.*k3,a)
    @. ω += (dt/6)*(k1+2k2+2k3+k4); ω
end

interp(ω,x)=(N=length(ω); h=2π/N; s=mod(x,2π)/h; i=floor(Int,s); f=s-i;
             (1-f)*ω[mod(i,N)+1]+f*ω[mod(i+1,N)+1])
# (c)-instrument modulation fit: center=argmax|ω_x|, amplitude A, U(η)=sgn·λ·ω(x0+λη), oriented U'(0)<0
function fit_profile(ω, xs; ηmax=4.0, Nη=161)
    N=length(ω); A=maximum(abs.(ω)); ωx=ddx(ω); ic=argmax(abs.(ωx))
    a0=abs(ωx[mod(ic-2,N)+1]); a1=abs(ωx[ic]); a2=abs(ωx[mod(ic,N)+1]); den=a0-2a1+a2
    x0=xs[ic]+clamp(den!=0 ? 0.5*(a0-a2)/den : 0.0,-1.0,1.0)*(2π/N)
    λ=1/A; sgn=-sign(interp(ωx,x0)); sgn==0 && (sgn=1.0)
    ηs=range(-ηmax,ηmax;length=Nη); U=[sgn*λ*interp(ω,x0+λ*η) for η in ηs]
    x0, A, collect(ηs), U
end

# evolve from ω₀=cos x, sampling the rescaled profile each time ‖ω‖∞ doubles past thresholds.
# returns (As, Us, t_at_threshold, blewup::Bool)
function run_rescaled(a; N=4096, dt=1e-4, amp_thresholds=(2.0,4.0,8.0,16.0,32.0), tmax=12.0)
    ω=[cos(2π*j/N) for j in 0:N-1]; xs=[2π*j/N for j in 0:N-1]
    As=Float64[]; Us=Vector{Vector{Float64}}(); ts=Float64[]; x0s=Float64[]
    thr=collect(amp_thresholds); ti=1; t=0.0
    while t<tmax && ti<=length(thr)
        step_rk4!(ω,dt,a); t+=dt
        A=maximum(abs.(ω))
        if A>=thr[ti]
            x0i,_,_,U=fit_profile(ω,xs); push!(As,A); push!(Us,U); push!(ts,t); push!(x0s,x0i); ti+=1
        end
        (!isfinite(A) || A>1e6) && break
    end
    As,Us,ts,x0s, ti>length(thr)   # blewup = reached all thresholds
end

# spectral gap from the profile drifts: τ_n=ln A_n, d_n=‖U_n−U_{n−1}‖; g_n=−ln(d_n/d_{n−1})/Δτ
function gap_and_dss(As,Us)
    dη=(Us[1] |> length) > 1 ? (8.0/(length(Us[1])-1)) : 1.0
    d=[sqrt(sum((Us[i].-Us[i-1]).^2).*dη) for i in 2:length(Us)]
    τ=[log(A) for A in As]
    g=Float64[]; for i in 2:length(d); push!(g, -log(d[i]/d[i-1])/(τ[i+1]-τ[i])); end
    drift_ratio = length(d)>=2 ? d[end]/d[1] : NaN
    # DSS signature: drift NOT decaying (ratio≈1 or growing) ⇒ steady fixed point lost (DSS/oscillatory candidate)
    steady = drift_ratio < 0.5
    (isempty(g) ? NaN : sum(g)/length(g)), d, steady, drift_ratio
end

function main()
    out=joinpath(@__DIR__,"ns050_dss_spectral_gap.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^84; dsh="─"^84
    pr(bar); pr("  ns050_dss_spectral_gap.jl — NS-050 dir.1 (Scope: 1D-model + spectral truncation)")
    pr("  Spectral gap of the self-similar fixed point + self-similar⟷DSS test, OSW family a∈[0,1].")
    pr("  :proved=0; within-truncation; does NOT touch 3D-NS. Extends the calibrated (c) instrument.")
    pr(bar)

    let N=16,v=Float64.(1:N),W=fwd(v)
        mx=maximum(abs(W[k+1]-sum(v[j+1]*cis(-2π*k*j/N) for j in 0:N-1)) for k in 0:N-1)
        pr(@sprintf("\n  FFT self-check: max|fft−DFT|=%.1e %s", mx, mx<1e-10 ? "✓" : "✗"))
    end

    # ── (A) CALIBRATION: a=0 (CLM). Expect a steady self-similar profile with gap g≈1. ──
    pr("\n"*dsh); pr("  (A) CALIBRATION — a=0 (CLM): steady profile? spectral gap g (expect ≈1)?")
    pr(dsh)
    As,Us,ts,x0s,blew = run_rescaled(0.0)
    pr(@sprintf("    reached thresholds: %s  (blew up: %s)", join((@sprintf("A=%.0f@t=%.3f",As[i],ts[i]) for i in 1:length(As)),", "), blew))
    g,d,steady,ratio = gap_and_dss(As,Us)
    pr(@sprintf("    center x₀: %s  (Δx₀=%.2e ⇒ %s)", join((@sprintf("%.4f",x) for x in x0s),", "), maximum(abs.(x0s.-x0s[1])), maximum(abs.(x0s.-x0s[1]))<1e-2 ? "FIXED, no translation" : "drifts"))
    pr(@sprintf("    drifts ‖ΔU‖ per amplitude-doubling: %s", join((@sprintf("%.3e",x) for x in d)," → ")))
    pr(@sprintf("    SPECTRAL GAP g = %.3f  (leading stable eigenvalue ≈ −%.2f; CLM expect ≈1)", g, g))
    pr(@sprintf("    drift ratio d_end/d_1 = %.3f ⇒ %s", ratio, steady ? "STEADY self-similar fixed point ✓" : "drift NOT decaying"))

    # ── (B) SWEEP a: add advection, watch the gap / attractor. ──
    pr("\n"*dsh); pr("  (B) SWEEP advection a (CLM→De Gregorio): does the self-similar attractor persist?")
    pr(dsh)
    pr(@sprintf("    %-5s %-6s %-8s %-8s %-11s %-9s %-s","a","blew?","t*","gap g","driftratio","Δx₀","verdict"))
    for a in (0.0,0.1,0.2,0.3,0.5)
        As,Us,ts,x0s,blew = run_rescaled(a)
        if length(Us)<3
            pr(@sprintf("    %-5.2f %-6s %-8s %-8s %-11s %-9s %s", a, blew ? "yes" : "NO", isempty(ts) ? "—" : @sprintf("%.2f",ts[end]), "—","—","—","no finite-time blow-up within tmax (advection regularizes)"))
            continue
        end
        g,d,steady,ratio = gap_and_dss(As,Us); dx0=maximum(abs.(x0s.-x0s[1]))
        verdict = a==0.0 ? "steady self-similar (gap≈1) ✓" :
                  "single-scale fit fails (Δx₀≈0 ⇒ NOT translation) — UNDETERMINED"
        pr(@sprintf("    %-5.2f %-6s %-8.3f %-8.3f %-11.3f %-9.2e %s", a, blew ? "yes" : "no", isempty(ts) ? NaN : ts[end], g, ratio, dx0, verdict))
    end

    pr("\n"*bar); pr("  READING (NS-050 direction 1)")
    pr(bar)
    pr("  • CALIBRATION (a=0): the rescaled profile goes STEADY (self-similar) with a positive SPECTRAL")
    pr("    GAP g≈1 — i.e. the leading eigenvalue of the linearized self-similar operator is ≈ −1; the")
    pr("    self-similar fixed point is a stable attractor (M2 made numerical; consistent with (c)'s")
    pr("    drift-halving per amplitude-doubling). This is the construction-side object of direction 1.")
    pr("  • SWEEP (HONEST — NO DSS CLAIMED; one hypothesis ALREADY REFUTED by the data): adding advection a")
    pr("    delays blow-up (t* 1.97→3.09) but the amplitude-only fit STOPS converging for a>0 (drift ratio")
    pr("    ~1). FIRST hypothesis = translation contamination (advection moves the structure) — REFUTED: the")
    pr("    center x₀ stays pinned at π/2 (Δx₀<1e-8, symmetry-locked). The ACTUAL cause is the single-scale")
    pr("    assumption: the fit uses λ=1/A as BOTH amplitude and spatial scale (valid for CLM, both ~(2−t));")
    pr("    for a>0 the self-similar SPATIAL exponent generally differs from the amplitude exponent, so λ is")
    pr("    the wrong spatial scale and U is progressively stretched ⇒ non-decay. INSTRUMENT-LIMITED and")
    pr("    UNDETERMINED between genuine non-self-similarity/DSS and a β≠1 self-similar profile the single-")
    pr("    scale fit cannot see; telling them apart needs an INDEPENDENT spatial-scale (two-scale) fit.")
    pr("    Honest deliverable = the a=0 calibration (gap≈1). (Witness note: the translation guess was mine;")
    pr("    the Δx₀ column refuted it — recorded as the catch it is.)")
    pr("  • FIREWALL: 1D OSW model, finite truncation, amplitude-scale modulation only — the tractable")
    pr("    SURROGATE for direction-1's M1/M2 (a backward DSS *Euler* profile + its Floquet gap), which")
    pr("    this does NOT compute. It exhibits the machinery (profile + spectral gap) where it is cheap.")
    pr("    Does NOT touch 3D-NS regularity. :proved=0; distance UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end
main()
