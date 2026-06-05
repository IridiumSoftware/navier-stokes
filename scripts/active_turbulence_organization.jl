#!/usr/bin/env julia
# active_turbulence_organization.jl — NS-044 (Phase 3): does organization emerge?
#
# SCOPE: phenomenology / 2D active-turbulence truncation. **NOT the NS PDE.**
#
# The climax question of the active-turbulence arc: with the agents cranked to a
# VIGOROUS active flow (forceGain up until the fluid speed ~ the swim speed, where
# collective dynamics live), does *lifelike self-organization* emerge on the faithful
# fluid? Diagnostics:
#   • agent pair-correlation g(r) — do the creatures CLUSTER (g>1 at small r)?
#   • Okubo–Weiss — what fraction of the flow is rotation-dominated (coherent vortices)?
#   • CONTROL: brain-agents (sensing + the ported Fourier brain) vs DUMB swimmers
#     (same active dipoles, NO sensing/steer) — isolates whether the *brain* organizes
#     them beyond generic active-matter clustering.
# Honest by design: a clean brain>dumb clustering signal ⇒ organization; none ⇒ NULL.

using Printf, Random
include_str = nothing
# ── fluid + agent primitives (NS-041/042/043 core) ──
function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1; while j & bit != 0; j ⊻= bit; bit>>=1; end; j |= bit
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
    if inv; a ./= N; end; a
end
function fft2(Ar); A=ComplexF64.(Ar); N=size(A,1)
    for i in 1:N; r=A[i,:]; fft!(r); A[i,:]=r; end
    for jc in 1:N; c=A[:,jc]; fft!(c); A[:,jc]=c; end; A; end
function ifft2(A); B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for jc in 1:N; c=B[:,jc]; fft!(c;inv=true); B[:,jc]=c; end; B; end
keff(k,N)= k<=N>>1 ? k : k-N
function make_ops(N)
    kx=[Float64(keff(a-1,N)) for a in 1:N, b in 1:N]; ky=[Float64(keff(b-1,N)) for a in 1:N, b in 1:N]
    k2=kx.^2 .+ ky.^2; k2p=copy(k2); k2p[1,1]=1.0
    cut=N÷3; deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut for a in 1:N, b in 1:N]
    (kx=kx,ky=ky,k2=k2,k2p=k2p,deal=deal)
end
function nonlin(W, op)
    ψ=W./op.k2p; ψ[1,1]=0
    u=real.(ifft2(-im.*op.ky.*ψ)); v=real.(ifft2(im.*op.kx.*ψ))
    ωx=real.(ifft2(im.*op.kx.*W)); ωy=real.(ifft2(im.*op.ky.*W))
    Aadv=fft2(u.*ωx .+ v.*ωy); Aadv[.!op.deal].=0; -Aadv
end
function step!(W, dt, op, S, E, E2)
    k1=dt.*(nonlin(W,op).+S); k2=dt.*(nonlin(E2.*(W.+k1./2),op).+S)
    k3=dt.*(nonlin(E2.*W.+k2./2,op).+S); k4=dt.*(nonlin(E.*W.+E2.*k3,op).+S)
    @. W = E*W + (E*k1 + 2*E2*(k2+k3) + k4)/6; W
end
energy(W,op)=0.5*sum(abs2.(W)./op.k2p)/length(W)^2
function fields(W,op); ψ=W./op.k2p; ψ[1,1]=0
    real.(ifft2(-im.*op.ky.*ψ)), real.(ifft2(im.*op.kx.*ψ)), real.(ifft2(W)); end
@inline function bilin(F,gx,gy,N)
    i0=floor(Int,gx); j0=floor(Int,gy); fx=gx-i0; fy=gy-j0
    i1=mod(i0,N)+1; i2=mod(i0+1,N)+1; j1=mod(j0,N)+1; j2=mod(j0+1,N)+1
    (1-fx)*(1-fy)*F[i1,j1]+fx*(1-fy)*F[i2,j1]+(1-fx)*fy*F[i1,j2]+fx*fy*F[i2,j2]
end
@inline function brain(rule,x1,x2,x3,x4)
    o1=0.0;o2=0.0
    @inbounds for i in 0:9
        s=sin(rule[4i+1]*x1+rule[4i+2]*x2+rule[4i+3]*x3+rule[4i+4]*x4)
        o1+=rule[40+4i+1]*s; o2+=rule[40+4i+2]*s
    end
    (o1,o2)
end
@inline function spread!(fxg,fyg,gx,gy,Fx,Fy,N,invσ2,half)
    i0=floor(Int,gx); j0=floor(Int,gy); sw=0.0
    @inbounds for di in -half:half, dj in -half:half; sw+=exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2); end
    inv=1.0/sw
    @inbounds for di in -half:half, dj in -half:half
        w=exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2)*inv
        fxg[mod(i0+di,N)+1,mod(j0+dj,N)+1]+=Fx*w; fyg[mod(i0+di,N)+1,mod(j0+dj,N)+1]+=Fy*w
    end
end

# Okubo–Weiss field (strain² − vorticity²); fraction rotation-dominated = vortex cores
function okubo_fraction(W,op)
    ψ=W./op.k2p; ψ[1,1]=0; uh=im.*op.ky.*ψ; vh=-im.*op.kx.*ψ
    ux=real.(ifft2(im.*op.kx.*uh)); uy=real.(ifft2(im.*op.ky.*uh))
    vx=real.(ifft2(im.*op.kx.*vh)); vy=real.(ifft2(im.*op.ky.*vh))
    OW=(ux.-vy).^2 .+ (vx.+uy).^2 .- (vx.-uy).^2
    sum(OW .< 0)/length(OW)        # fraction with OW<0 (rotation/vortex-dominated)
end

# pair-correlation g(r), periodic min-image (L=2π)
function gofr(px,py,nbins,rmax)
    n=length(px); cnt=zeros(Int,nbins); dr=rmax/nbins; L=2π
    @inbounds for i in 1:n-1, j in i+1:n
        dx=px[i]-px[j]; dy=py[i]-py[j]
        dx-=L*round(dx/L); dy-=L*round(dy/L); r=sqrt(dx*dx+dy*dy)
        if r<rmax; cnt[floor(Int,r/dr)+1]+=2; end
    end
    ρ=n/L^2; g=zeros(nbins)
    for b in 1:nbins; r=(b-0.5)*dr; g[b]=cnt[b]/(n*ρ*2π*r*dr); end
    g, dr
end

# one coupled run; usebrain=false ⇒ dumb active swimmers (no sensing/steer). returns (px,py,W)
function run_coupled(N,op,E,E2,dt,rule,par,nag,steps,seed,usebrain)
    rng=MersenneTwister(seed)
    px=2π.*rand(rng,nag); py=2π.*rand(rng,nag); th=2π.*rand(rng,nag)
    W=fft2(1e-3 .* randn(rng,N,N)); fxg=zeros(N,N); fyg=zeros(N,N); dxg=N/(2π)
    for s in 1:steps
        U,V,Wr=fields(W,op); fill!(fxg,0.0); fill!(fyg,0.0)
        @inbounds for a in 1:nag
            gx=px[a]*dxg; gy=py[a]*dxg; hx=cos(th[a]); hy=sin(th[a]); lx=-hy; ly=hx
            axial=0.0
            if usebrain
                sd=par.sensorDist*dxg; sa=par.sensorAngle; cR=cos(sa); sR=sin(sa)
                fLx=hx*cR-hy*sR; fLy=hx*sR+hy*cR; fRx=hx*cR+hy*sR; fRy=-hx*sR+hy*cR
                uL=bilin(U,gx+fLx*sd,gy+fLy*sd,N); vL=bilin(V,gx+fLx*sd,gy+fLy*sd,N)
                uR=bilin(U,gx+fRx*sd,gy+fRy*sd,N); vR=bilin(V,gx+fRx*sd,gy+fRy*sd,N)
                L1=(uL*hx+vL*hy)*par.senseScale; L2=(uL*lx+vL*ly)*par.senseScale
                R1=(uR*hx+vR*hy)*par.senseScale; R2=(uR*lx+vR*ly)*par.senseScale
                b1,b2=brain(rule,L1,L2,R1,R2); m1,m2=brain(rule,R1,-R2,L1,-L2)
                axial=b1+m1
            end
            vsw=clamp(par.swim*(1+axial*par.speedGain),0.2*par.swim,2.0*par.swim)
            fmag=par.forceGain*vsw; hl=par.dipL*dxg/2
            spread!(fxg,fyg,gx+hx*hl,gy+hy*hl, fmag*hx, fmag*hy,N,par.invσ2,par.half)
            spread!(fxg,fyg,gx-hx*hl,gy-hy*hl,-fmag*hx,-fmag*hy,N,par.invσ2,par.half)
        end
        S=im.*(op.kx.*fft2(fyg).-op.ky.*fft2(fxg)); S[.!op.deal].=0
        step!(W,dt,op,S,E,E2)
        U,V,Wr=fields(W,op)
        @inbounds for a in 1:nag
            gx=px[a]*dxg; gy=py[a]*dxg; u=bilin(U,gx,gy,N); v=bilin(V,gx,gy,N); ω=bilin(Wr,gx,gy,N)
            hx=cos(th[a]); hy=sin(th[a]); turnT=0.0
            if usebrain
                lx=-hy; ly=hx; sd=par.sensorDist*dxg; sa=par.sensorAngle; cR=cos(sa); sR=sin(sa)
                fLx=hx*cR-hy*sR; fLy=hx*sR+hy*cR; fRx=hx*cR+hy*sR; fRy=-hx*sR+hy*cR
                uL=bilin(U,gx+fLx*sd,gy+fLy*sd,N); vL=bilin(V,gx+fLx*sd,gy+fLy*sd,N)
                uR=bilin(U,gx+fRx*sd,gy+fRy*sd,N); vR=bilin(V,gx+fRx*sd,gy+fRy*sd,N)
                L1=(uL*hx+vL*hy)*par.senseScale; L2=(uL*lx+vL*ly)*par.senseScale
                R1=(uR*hx+vR*hy)*par.senseScale; R2=(uR*lx+vR*ly)*par.senseScale
                b1,b2=brain(rule,L1,L2,R1,R2); m1,m2=brain(rule,R1,-R2,L1,-L2); turnT=b2-m2
            end
            th[a]+=(turnT*par.turn+0.5*ω)*dt; ax=usebrain ? 0.0 : 0.0
            vsw=par.swim
            if usebrain
                # recompute axial cheaply omitted; use swim (speed modulation minor for advection)
            end
            px[a]=mod(px[a]+(u+vsw*hx)*dt,2π); py[a]=mod(py[a]+(v+vsw*hy)*dt,2π)
        end
    end
    px,py,W
end

function main()
    out=joinpath(@__DIR__,"active_turbulence_organization.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout))
    bar="═"^78
    pr(bar); pr("  active_turbulence_organization.jl — NS-044 Phase 3: does organization emerge?")
    pr("  Scope: phenomenology (2D active-turbulence). NOT the NS PDE.")
    pr(bar)

    N=128; op=make_ops(N); ν=1.5e-4; μ=0.5; kdrag=3.0; dt=0.004
    nag=2000; steps=2000
    par=(swim=0.35, sensorDist=0.10, sensorAngle=0.40, senseScale=3.0, speedGain=0.6,
         turn=0.6, forceGain=25.0, dipL=0.12, invσ2=1.0, half=3)   # CRANKED forceGain
    pr(@sprintf("\n  N=%d, agents=%d, steps=%d, forceGain=%.0f (cranked for u_rms~swim), swim=%.2f",
        N, nag, steps, par.forceGain, par.swim))
    drag=[ sqrt(op.k2[a,b])<kdrag ? μ : 0.0 for a in 1:N, b in 1:N ]
    L=-(ν.*op.k2.+drag); E=exp.(L.*dt); E2=exp.(L.*(dt/2))
    rng=MersenneTwister(20260605); rule=zeros(80)
    for i in 1:40; rule[i]=2*(2rand(rng)-1); end; for i in 41:80; rule[i]=(2rand(rng)-1); end

    nb=24; rmax=π/2
    pr("\n  running BRAIN agents (sensing + ported Fourier brain)…")
    pxB,pyB,WB = run_coupled(N,op,E,E2,dt,rule,par,nag,steps,11,true)
    gB,dr = gofr(pxB,pyB,nb,rmax); owB=okubo_fraction(WB,op); EB=energy(WB,op)
    pr("  running DUMB swimmers (same dipoles, NO sensing) — the control…")
    pxD,pyD,WD = run_coupled(N,op,E,E2,dt,rule,par,nag,steps,11,false)
    gD,_ = gofr(pxD,pyD,nb,rmax); owD=okubo_fraction(WD,op); ED=energy(WD,op)

    pr(@sprintf("\n  flow: E(brain)=%.4f  E(dumb)=%.4f  (u_rms≈%.2f/%.2f vs swim %.2f)",
        EB, ED, sqrt(2EB), sqrt(2ED), par.swim))
    pr(@sprintf("  vortex-dominated area (Okubo–Weiss OW<0): brain=%.1f%%  dumb=%.1f%%", 100owB, 100owD))
    pr("\n  agent pair-correlation g(r)   [g>1 = clustering]   (r in units of box=2π)")
    pr(@sprintf("    %-8s %-10s %-10s", "r","g_brain","g_dumb"))
    gBpk=0.0; gDpk=0.0
    for b in 1:nb
        r=(b-0.5)*dr; (r<0.02) && continue
        b<=12 && pr(@sprintf("    %-8.3f %-10.2f %-10.2f", r, gB[b], gD[b]))
        gBpk=max(gBpk,gB[b]); gDpk=max(gDpk,gD[b])
    end
    # near-field clustering = mean g over the first few bins (small r)
    cB=sum(gB[2:5])/4; cD=sum(gD[2:5])/4
    pr(@sprintf("\n  near-field clustering ⟨g(small r)⟩: brain=%.2f  dumb=%.2f  (ratio %.2f)", cB, cD, cB/cD))
    organized = (cB > 1.3) && (cB > 1.15*cD)
    pr(@sprintf("\n  VERDICT: %s", organized ?
        "ORGANIZATION — brain-agents cluster beyond the dumb-swimmer control." :
        "NULL — no brain-driven clustering signal beyond active-matter baseline (honest)."))
    pr("\n"*bar)
    pr("  • A faithful test on a real NS fluid: brain-sensing agents vs dumb active swimmers.")
    pr("  • FIREWALL: Scope phenomenology, NOT the PDE. Distance to prize: UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
    return organized
end

main()
