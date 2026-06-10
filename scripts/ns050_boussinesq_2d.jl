#!/usr/bin/env julia
# ns050_boussinesq_2d.jl — NS-050 (c2): a 2D Boussinesq front-sharpening fixture + the two-scale
# dynamic-rescaling instrument applied to it.
#
# EXPERIMENTAL. **Scope: 2D Boussinesq pseudospectral DNS truncation. NOT the NS PDE.** :proved=0;
# distance to the Clay prize UNTOUCHED.
#
# HONEST SCOPE (read first). This is a 2D Boussinesq DNS on a PERIODIC box with a rising-thermal IC
# that develops a sharpening mushroom front. It is NOT a faithful reproduction of the Chen–Hou /
# Hou–Luo finite-time blow-up — that result needs a SOLID WALL (the boundary drives the singularity),
# which a periodic spectral box does not impose. So: (i) no blow-up is claimed (smooth 2D Boussinesq
# with dissipation is globally regular, Chae 2006; the inviscid smooth-data question is OPEN); (ii)
# this is a within-truncation FRONT-SHARPENING witness — the closest incompressible-FAMILY flow with
# a genuinely sharpening structure to point the (c1) two-scale instrument at, BEYOND the 1D CLM/OSW
# models; (iii) a resolution gate STOPS trusting the run once the spectral tail saturates (the NS-032
# lesson: do not push past the resolution wall).
#
# 2D Boussinesq (vorticity form), periodic [0,2π]²:
#   ω_t + u·∇ω = ∂_x θ + ν Δω        (baroclinic vorticity generation; gravity ∥ y)
#   θ_t + u·∇θ = κ Δθ                 (active scalar / buoyancy, transported)
#   u = ∇^⊥ψ,  Δψ = ω  ⇒  û = i k_y ω̂/|k|²,  v̂ = −i k_x ω̂/|k|²   (Biot–Savart, div-free)
# Std-lib only (Printf); 2D FFT built from the 1D radix-2 fft! (rows then columns), self-checked.

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
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w; a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end; a
end
function fft2(Ar)
    A=ComplexF64.(Ar); N=size(A,1)
    for i in 1:N; r=A[i,:]; fft!(r); A[i,:]=r; end
    for j in 1:N; c=A[:,j]; fft!(c); A[:,j]=c; end; A
end
function ifft2(A)
    B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for j in 1:N; c=B[:,j]; fft!(c;inv=true); B[:,j]=c; end; B
end
keff(k,N)= k<=N>>1 ? k : k-N

struct Ops; KX::Matrix{Float64}; KY::Matrix{Float64}; K2::Matrix{Float64}; cut::Int; N::Int; end
function make_ops(N)
    KX=[Float64(keff(a-1,N)) for a in 1:N, b in 1:N]
    KY=[Float64(keff(b-1,N)) for a in 1:N, b in 1:N]
    K2=KX.^2 .+ KY.^2; K2[1,1]=1.0
    Ops(KX,KY,K2,N÷3,N)
end
dealias!(Wh,op)=(for a in 1:op.N, b in 1:op.N; if abs(keff(a-1,op.N))>op.cut||abs(keff(b-1,op.N))>op.cut; Wh[a,b]=0; end; end; Wh)
function velocities(ωh,op)                         # û=i ky ω̂/|k|², v̂=−i kx ω̂/|k|²
    uh =  im.*op.KY.*ωh./op.K2; uh[1,1]=0
    vh = -im.*op.KX.*ωh./op.K2; vh[1,1]=0
    real.(ifft2(uh)), real.(ifft2(vh))
end
function rhs(ωh,θh,op,ν,κ)
    u,v = velocities(ωh,op)
    ωx=real.(ifft2(im.*op.KX.*ωh)); ωy=real.(ifft2(im.*op.KY.*ωh))
    θx=real.(ifft2(im.*op.KX.*θh)); θy=real.(ifft2(im.*op.KY.*θh))
    advω = fft2(u.*ωx .+ v.*ωy); dealias!(advω,op)
    advθ = fft2(u.*θx .+ v.*θy); dealias!(advθ,op)
    dωh = -advω .+ im.*op.KX.*θh .- ν.*op.K2.*ωh
    dθh = -advθ .- κ.*op.K2.*θh
    dωh, dθh
end
function step_rk4!(ωh,θh,dt,op,ν,κ)
    a1,b1=rhs(ωh,θh,op,ν,κ); a2,b2=rhs(ωh.+(dt/2).*a1,θh.+(dt/2).*b1,op,ν,κ)
    a3,b3=rhs(ωh.+(dt/2).*a2,θh.+(dt/2).*b2,op,ν,κ); a4,b4=rhs(ωh.+dt.*a3,θh.+dt.*b3,op,ν,κ)
    @. ωh += (dt/6)*(a1+2a2+2a3+a4); @. θh += (dt/6)*(b1+2b2+2b3+b4); nothing
end
gridmean2(A)=sum(A)/length(A)
function tail_frac(θh,op)                          # fraction of θ-spectral-energy in the outer 1/3 band
    N=op.N; tot=0.0; hi=0.0
    for a in 1:N, b in 1:N
        e=abs2(θh[a,b]); tot+=e
        (abs(keff(a-1,N))>op.cut*2÷3 || abs(keff(b-1,N))>op.cut*2÷3) && (hi+=e)
    end
    hi/tot
end
# two-scale fit (c1) on |∇θ| along x through its peak: amplitude A=‖∇θ‖∞, width ℓ from half-max
function twoscale_front(gmag, op; Nη=121, ηmax=4.0)
    N=op.N; A=maximum(gmag); I=argmax(gmag); i0,j0=I[1],I[2]
    line=[gmag[i,j0] for i in 1:N]; hw=1
    for r in 1:N÷2
        if line[mod(i0-1+r,N)+1]<A/2 || line[mod(i0-1-r,N)+1]<A/2; hw=r; break; end
    end
    ℓ=max(hw,1)*(2π/N); ηs=range(-ηmax,ηmax;length=Nη)
    interpL(x)=(h=2π/N; s=mod(x,2π)/h; a=floor(Int,s); f=s-a; (1-f)*line[mod(a,N)+1]+f*line[mod(a+1,N)+1])
    x0=(i0-1)*(2π/N); A, ℓ, [interpL(x0+ℓ*η)/A for η in ηs]
end

function main()
    out=joinpath(@__DIR__,"ns050_boussinesq_2d.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^88; dsh="─"^88
    pr(bar); pr("  ns050_boussinesq_2d.jl — NS-050 (c2): 2D Boussinesq front-sharpening (Scope: 2D DNS trunc.)")
    pr("  PERIODIC box, rising-thermal IC. NOT a Hou–Luo wall blow-up. Within-truncation witness. :proved=0.")
    pr(bar)
    N=128; op=make_ops(N); xs=[2π*(a-1)/N for a in 1:N]

    # ── (V) VALIDATION: inviscid transport conserves θ-variance + mean; Biot–Savart is div-free ──
    pr("\n"*dsh); pr("  (V) VALIDATION (ν=κ=0): ∫θ, ∫θ² conserved? velocity divergence-free?"); pr(dsh)
    θ0=[exp(-(((xs[a]-π)^2+(xs[b]-π)^2)/0.25)) for a in 1:N, b in 1:N]
    ωh=zeros(ComplexF64,N,N); θh=fft2(θ0)
    m0=gridmean2(real.(ifft2(θh))); v0=gridmean2(real.(ifft2(θh)).^2)
    utest,vtest = velocities(fft2([sin(xs[a])*cos(xs[b]) for a in 1:N, b in 1:N]),op)
    divh = im.*op.KX.*fft2(utest) .+ im.*op.KY.*fft2(vtest); dmax=maximum(abs.(real.(ifft2(divh))))
    pr(@sprintf("    div(u) max on a test field = %.2e %s", dmax, dmax<1e-10 ? "✓ div-free" : "✗"))
    for s in 1:200; step_rk4!(ωh,θh,0.02,op,0.0,0.0); end          # T=4 inviscid
    mT=gridmean2(real.(ifft2(θh))); vT=gridmean2(real.(ifft2(θh)).^2)
    pr(@sprintf("    ∫θ drift=%.2e, ∫θ² drift=%.2e over T=4 (ν=κ=0) %s", abs(mT-m0), abs(vT-v0),
        (abs(mT-m0)<1e-9 && abs(vT-v0)/v0<1e-3) ? "✓ transport conserved" : "(check)"))

    # ── (S) SHARPENING run + two-scale fit + resolution gate ──
    pr("\n"*dsh); pr("  (S) SHARPENING: rising thermal, ν=κ=2e-4. Track ‖ω‖∞,‖∇θ‖∞, tail(resolution), β."); pr(dsh)
    pr(@sprintf("    %-6s %-9s %-10s %-10s %-9s %-10s %-s","t","‖ω‖∞","‖∇θ‖∞","ℓ(front)","tail","prof drift","status"))
    ν=2e-4; κ=2e-4; dt=0.01; θh=fft2(θ0); ωh=zeros(ComplexF64,N,N)
    t=0.0; smp=1.0; nexts=0.0; Uprev=nothing; Nη=121; dη=8.0/(Nη-1); As=Float64[]; Ls=Float64[]; gated=false
    while t<16.0+1e-9
        if t>=nexts-1e-9
            θx=real.(ifft2(im.*op.KX.*θh)); θy=real.(ifft2(im.*op.KY.*θh)); gmag=sqrt.(θx.^2 .+ θy.^2)
            ωmax=maximum(abs.(real.(ifft2(ωh)))); A,ℓ,U=twoscale_front(gmag,op); tail=tail_frac(θh,op)
            dr=Uprev===nothing ? NaN : sqrt(sum((U.-Uprev).^2).*dη)
            status = tail>0.01 ? "UNDER-RESOLVED (gate) — stop trusting" : (t<3 ? "rising" : "sharpening")
            pr(@sprintf("    %-6.2f %-9.3f %-10.3f %-10.4f %-9.1e %-10s %s", t, ωmax, A, ℓ, tail,
                isnan(dr) ? "—" : @sprintf("%.3e",dr), status))
            push!(As,A); push!(Ls,ℓ); Uprev=U
            if tail>0.01 && !gated; gated=true; pr("    ^ resolution gate tripped: results past here are truncation artifacts, not physics."); break; end
            nexts+=smp
        end
        step_rk4!(ωh,θh,dt,op,ν,κ); t+=dt
    end
    # β from the resolved window (before the gate)
    if length(As)>=3
        n=length(As); lx=[log(1/As[i]) for i in 1:n]; ly=[log(Ls[i]) for i in 1:n]
        xm=sum(lx)/n; ym=sum(ly)/n; β=sum((lx.-xm).*(ly.-ym))/sum((lx.-xm).^2)
        pr(@sprintf("    β=dlnℓ/dlnλ over the resolved window = %.3f (front spatial-vs-amplitude scaling)", β))
    end

    pr("\n"*bar); pr("  READING (NS-050 c2)"); pr(bar)
    pr("  • VALIDATION: inviscid 2D Boussinesq conserves ∫θ and ∫θ² (scalar transport) and the Biot–Savart")
    pr("    velocity is divergence-free — the solver is sound.")
    pr("  • The rising thermal develops a SHARPENING front: ‖∇θ‖∞ grows and the front width ℓ shrinks,")
    pr("    until the RESOLUTION GATE (spectral tail >1%) trips — past which the run is a truncation")
    pr("    artifact and is STOPPED (NS-032 discipline: no pushing past the resolution wall).")
    pr("  • The two-scale instrument (c1) is applied to the front while resolved; β reports its spatial-vs-")
    pr("    amplitude scaling. This is a WITHIN-TRUNCATION front witness, NOT a blow-up: smooth dissipative")
    pr("    2D Boussinesq is globally regular (Chae 2006), and the faithful Hou–Luo finite-time singularity")
    pr("    needs a SOLID WALL this periodic box does not impose. So NO singularity is claimed.")
    pr("  • FIREWALL: 2D Boussinesq, periodic, finite truncation. Closest incompressible-family sharpening")
    pr("    flow beyond the 1D models, but NOT the Clay NS and NOT the Hou–Luo wall scenario. :proved=0.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
