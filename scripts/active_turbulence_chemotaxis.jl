#!/usr/bin/env julia
# active_turbulence_chemotaxis.jl — AT-5 (SIM_SPEC.md): the decisive chemotaxis test.
#
# SCOPE: phenomenology / 2D active-turbulence truncation. **NOT the NS PDE,
# NOT the obstruction map.**
#
# AT-4 found NO clustering from velocity-sensing agents on a faithful fluid (g(r)≈1),
# and argued the fluoddity "creatures" needed CHEMOTAXIS (density-aggregation) — the
# `cohesion` ingredient AT-4 deliberately omitted. This isolates it: agents deposit a
# density field D, sense its gradient at their body-frame sensors, and STEER UP IT
# (toward each other) — the aggregation feedback — on the SAME faithful incompressible
# fluid, with the SAME net-zero dipole forcing. Control = dumb swimmers (cohesion=0).
#   • CHEMO clusters beyond dumb ⇒ lifelike organization CAN live on real NS, via
#     aggregation (not active turbulence) — the missing ingredient was chemotaxis.
#   • No clustering even with strong cohesion ⇒ the turbulent incompressible substrate
#     defeats aggregation; the fluoddity creatures genuinely needed the unphysical fluid.

using Printf, Random
# ── fluid + agent primitives (AT-1..4 core) ──
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
@inline function spread!(fxg,fyg,gx,gy,Fx,Fy,N,invσ2,half)
    i0=floor(Int,gx); j0=floor(Int,gy); sw=0.0
    @inbounds for di in -half:half, dj in -half:half; sw+=exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2); end
    inv=1.0/sw
    @inbounds for di in -half:half, dj in -half:half
        w=exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2)*inv
        fxg[mod(i0+di,N)+1,mod(j0+dj,N)+1]+=Fx*w; fyg[mod(i0+di,N)+1,mod(j0+dj,N)+1]+=Fy*w
    end
end
@inline function deposit!(D,gx,gy,N,invσ2,half)   # scalar density deposit (Σ weight = 1)
    i0=floor(Int,gx); j0=floor(Int,gy); sw=0.0
    @inbounds for di in -half:half, dj in -half:half; sw+=exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2); end
    inv=1.0/sw
    @inbounds for di in -half:half, dj in -half:half
        D[mod(i0+di,N)+1,mod(j0+dj,N)+1]+=exp(-(((i0+di)-gx)^2+((j0+dj)-gy)^2)*invσ2)*inv
    end
end
function gofr(px,py,nbins,rmax)
    n=length(px); cnt=zeros(Int,nbins); dr=rmax/nbins; L=2π
    @inbounds for i in 1:n-1, j in i+1:n
        dx=px[i]-px[j]; dy=py[i]-py[j]; dx-=L*round(dx/L); dy-=L*round(dy/L); r=sqrt(dx*dx+dy*dy)
        if r<rmax; cnt[floor(Int,r/dr)+1]+=2; end
    end
    ρ=n/L^2; g=zeros(nbins); for b in 1:nbins; r=(b-0.5)*dr; g[b]=cnt[b]/(n*ρ*2π*r*dr); end; g,dr
end

# coupled run; cohesion>0 ⇒ agents steer up the density gradient (chemotaxis)
function run_coupled(N,op,E,E2,dt,par,nag,steps,seed,cohesion)
    rng=MersenneTwister(seed)
    px=2π.*rand(rng,nag); py=2π.*rand(rng,nag); th=2π.*rand(rng,nag)
    W=fft2(1e-3 .* randn(rng,N,N)); fxg=zeros(N,N); fyg=zeros(N,N); D=zeros(N,N); dxg=N/(2π)
    for s in 1:steps
        U,V,Wr=fields(W,op); fill!(fxg,0.0); fill!(fyg,0.0)
        @inbounds for a in 1:nag                              # dumb dipole forcing (same for both)
            gx=px[a]*dxg; gy=py[a]*dxg; hx=cos(th[a]); hy=sin(th[a])
            fmag=par.forceGain*par.swim; hl=par.dipL*dxg/2
            spread!(fxg,fyg,gx+hx*hl,gy+hy*hl, fmag*hx, fmag*hy,N,par.invσ2,par.half)
            spread!(fxg,fyg,gx-hx*hl,gy-hy*hl,-fmag*hx,-fmag*hy,N,par.invσ2,par.half)
        end
        S=im.*(op.kx.*fft2(fyg).-op.ky.*fft2(fxg)); S[.!op.deal].=0
        step!(W,dt,op,S,E,E2)
        U,V,Wr=fields(W,op)
        if cohesion>0
            fill!(D,0.0); @inbounds for a in 1:nag; deposit!(D,px[a]*dxg,py[a]*dxg,N,par.invσ2,par.half); end
        end
        @inbounds for a in 1:nag
            gx=px[a]*dxg; gy=py[a]*dxg; u=bilin(U,gx,gy,N); v=bilin(V,gx,gy,N); ω=bilin(Wr,gx,gy,N)
            hx=cos(th[a]); hy=sin(th[a]); chemT=0.0
            if cohesion>0                                     # sense density gradient at ±sensorAngle
                sd=par.sensorDist*dxg; sa=par.sensorAngle; cR=cos(sa); sR=sin(sa)
                fLx=hx*cR-hy*sR; fLy=hx*sR+hy*cR; fRx=hx*cR+hy*sR; fRy=-hx*sR+hy*cR
                DL=bilin(D,gx+fLx*sd,gy+fLy*sd,N); DR=bilin(D,gx+fRx*sd,gy+fRy*sd,N)
                chemT=(DL-DR)*cohesion                        # steer toward higher density
            end
            th[a]+=(chemT+0.5*ω)*dt
            px[a]=mod(px[a]+(u+par.swim*hx)*dt,2π); py[a]=mod(py[a]+(v+par.swim*hy)*dt,2π)
        end
    end
    px,py,W
end

function main()
    out=joinpath(@__DIR__,"active_turbulence_chemotaxis.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout))
    bar="═"^78
    pr(bar); pr("  active_turbulence_chemotaxis.jl — AT-5: the decisive chemotaxis test")
    pr("  Scope: phenomenology (2D active-turbulence). NOT the NS PDE, NOT the obstruction map.")
    pr(bar)

    N=128; op=make_ops(N); ν=1.5e-4; μ=0.5; kdrag=3.0; dt=0.004; nag=2000; steps=2000
    par=(swim=0.35, sensorDist=0.12, sensorAngle=0.40, dipL=0.12, invσ2=1.0, half=3, forceGain=25.0)
    coh=40.0
    pr(@sprintf("\n  N=%d, agents=%d, steps=%d, forceGain=%.0f, cohesion(chemo)=%.0f", N,nag,steps,par.forceGain,coh))
    drag=[ sqrt(op.k2[a,b])<kdrag ? μ : 0.0 for a in 1:N, b in 1:N ]
    L=-(ν.*op.k2.+drag); E=exp.(L.*dt); E2=exp.(L.*(dt/2))

    nb=24; rmax=π/2
    pr("\n  running DUMB swimmers (cohesion=0) — the control…")
    pxD,pyD,WD = run_coupled(N,op,E,E2,dt,par,nag,steps,11,0.0)
    gD,dr = gofr(pxD,pyD,nb,rmax); ED=energy(WD,op)
    pr("  running CHEMOTAXIS swimmers (steer up the density gradient)…")
    pxC,pyC,WC = run_coupled(N,op,E,E2,dt,par,nag,steps,11,coh)
    gC,_ = gofr(pxC,pyC,nb,rmax); EC=energy(WC,op)

    pr(@sprintf("\n  flow: E(dumb)=%.4f  E(chemo)=%.4f", ED, EC))
    pr("\n  agent pair-correlation g(r)   [g>1 = clustering]   (r in units of box=2π)")
    pr(@sprintf("    %-8s %-10s %-10s", "r","g_dumb","g_chemo"))
    for b in 1:12
        r=(b-0.5)*dr; r<0.02 && continue
        pr(@sprintf("    %-8.3f %-10.2f %-10.2f", r, gD[b], gC[b]))
    end
    cD=sum(gD[2:5])/4; cC=sum(gC[2:5])/4; pkC=maximum(gC[2:8])
    pr(@sprintf("\n  near-field clustering ⟨g(small r)⟩: dumb=%.2f  chemo=%.2f  (ratio %.2f; chemo peak %.2f)",
        cD, cC, cC/cD, pkC))
    clustered = (cC > 1.3) && (cC > 1.2*cD)
    pr(@sprintf("\n  VERDICT: %s", clustered ?
        "CHEMOTAXIS CLUSTERS — lifelike aggregation DOES survive on the faithful incompressible fluid." :
        "NULL even with chemotaxis — the turbulent incompressible substrate defeats aggregation."))
    pr("\n"*bar)
    pr("  • Tests whether density-aggregation (the fluoddity 'cohesion' ingredient) reproduces")
    pr("    clustering on a FAITHFUL incompressible fluid — vs AT-4's velocity-only NULL.")
    pr("  • FIREWALL: Scope phenomenology, NOT the PDE, NOT the obstruction map. Prize: UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
    return clustered
end

main()
