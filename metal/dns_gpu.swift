// metal/dns_gpu.swift — Stage 2: the rotational-form NS rhs + RK4, entirely in MPSGraph.
// Fields are kept as (real,imag) real-tensor PAIRS (struct CX); every wavenumber op is then
// explicit real arithmetic (no reliance on complex-dtype op semantics); complex appears only
// at FFT boundaries (pack via complexTensor, unpack via realPart/imaginaryPart).
//
// VALIDATION GATE: inviscid ABC/Beltrami flow (u=(sin z+cos y, sin x+cos z, sin y+cos x);
// ω=∇×u=u). Since u×ω=u×u=0, the Lamb vector is 0 ⇒ rhs=0 ⇒ the flow is EXACTLY stationary.
// If curl/cross/Leray are correct: field unchanged, E & H conserved, H/(2E)=1 (Beltrami).
//
// Build: swiftc -O dns_gpu.swift -o dns_gpu -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
import Foundation
import Metal
import MetalPerformanceShadersGraph

let N = 64
let dev = MTLCreateSystemDefaultDevice()!
let g = MPSGraph()
func dimsN() -> [NSNumber] { [NSNumber(value:N), NSNumber(value:N), NSNumber(value:N)] }

// ---- complex-as-pair + ops ----
struct CX { let re: MPSGraphTensor; let im: MPSGraphTensor }
func mul(_ a: MPSGraphTensor, _ b: MPSGraphTensor) -> MPSGraphTensor { g.multiplication(a, b, name: nil) }
func add(_ a: MPSGraphTensor, _ b: MPSGraphTensor) -> MPSGraphTensor { g.addition(a, b, name: nil) }
func sub(_ a: MPSGraphTensor, _ b: MPSGraphTensor) -> MPSGraphTensor { g.subtraction(a, b, name: nil) }
func neg(_ a: MPSGraphTensor) -> MPSGraphTensor { g.negative(with: a, name: nil) }
func addC(_ a: CX, _ b: CX) -> CX { CX(re: add(a.re,b.re), im: add(a.im,b.im)) }
func subC(_ a: CX, _ b: CX) -> CX { CX(re: sub(a.re,b.re), im: sub(a.im,b.im)) }
func scaleR(_ c: CX, _ r: MPSGraphTensor) -> CX { CX(re: mul(c.re,r), im: mul(c.im,r)) }      // real field × complex
func mulIK(_ c: CX, _ k: MPSGraphTensor) -> CX { CX(re: neg(mul(c.im,k)), im: mul(c.re,k)) }   // (i·k)·complex
func scaleS(_ c: CX, _ s: Float) -> CX {                                                       // scalar × complex
    let sc = g.constant(Double(s), dataType: .float32)
    return CX(re: mul(c.re, sc), im: mul(c.im, sc))
}
func fft(_ c: CX, inverse: Bool) -> CX {
    let z = g.complexTensor(realTensor: c.re, imaginaryTensor: c.im, name: nil)
    let d = MPSGraphFFTDescriptor(); d.inverse = inverse; d.scalingMode = inverse ? .size : .none
    let y = g.fastFourierTransform(z, axes: [0,1,2], descriptor: d, name: nil)
    return CX(re: g.realPartOfTensor(tensor: y, name: nil), im: g.imaginaryPartOfTensor(tensor: y, name: nil))
}

// ---- constant wavenumber tensors (Julia keff: k=i if i≤N/2 else i-N) ----
func keff(_ i: Int) -> Float { Float(i <= N/2 ? i : i - N) }
func cgrid(_ f: (Int,Int,Int)->Float) -> MPSGraphTensor {
    var a = [Float](repeating: 0, count: N*N*N)
    for i in 0..<N { for j in 0..<N { for k in 0..<N { a[(i*N+j)*N+k] = f(i,j,k) } } }
    let data = a.withUnsafeBufferPointer { Data(buffer: $0) }
    return g.constant(data, shape: dimsN(), dataType: .float32)
}
let cut = N/3
let KX = cgrid { i,_,_ in keff(i) }
let KY = cgrid { _,j,_ in keff(j) }
let KZ = cgrid { _,_,k in keff(k) }
let K2 = cgrid { i,j,k in keff(i)*keff(i)+keff(j)*keff(j)+keff(k)*keff(k) }
let INV = cgrid { i,j,k in let s = keff(i)*keff(i)+keff(j)*keff(j)+keff(k)*keff(k); return s==0 ? 0 : 1/s }
let DEAL = cgrid { i,j,k in (abs(keff(i))<=Float(cut) && abs(keff(j))<=Float(cut) && abs(keff(k))<=Float(cut)) ? 1 : 0 }
let ZERO = cgrid { _,_,_ in 0 }

// ---- rhs (inviscid here; viscous term = scaleR(uh, ν·K2) subtracted if ν>0) ----
let nu: Float = 0.0
func rhs(_ uh: CX, _ vh: CX, _ wh: CX) -> (CX,CX,CX) {
    // ω̂ = i k×û :  (k×û)_x=ky*w−kz*v, _y=kz*u−kx*w, _z=kx*v−ky*u
    let wxh = subC(mulIK(wh, KY), mulIK(vh, KZ))
    let wyh = subC(mulIK(uh, KZ), mulIK(wh, KX))
    let wzh = subC(mulIK(vh, KX), mulIK(uh, KY))
    // to real space (take real part)
    let u = fft(uh, inverse:true).re, v = fft(vh, inverse:true).re, w = fft(wh, inverse:true).re
    let ox = fft(wxh, inverse:true).re, oy = fft(wyh, inverse:true).re, oz = fft(wzh, inverse:true).re
    // Lamb vector u×ω
    let cx = sub(mul(v,oz), mul(w,oy)), cy = sub(mul(w,ox), mul(u,oz)), cz = sub(mul(u,oy), mul(v,ox))
    // forward FFT + 2/3 dealias
    var Cx = fft(CX(re:cx, im:ZERO), inverse:false); Cx = scaleR(Cx, DEAL)
    var Cy = fft(CX(re:cy, im:ZERO), inverse:false); Cy = scaleR(Cy, DEAL)
    var Cz = fft(CX(re:cz, im:ZERO), inverse:false); Cz = scaleR(Cz, DEAL)
    // Leray projection: P = C − k (k·C)/k²
    let kdotC = addC(addC(scaleR(Cx,KX), scaleR(Cy,KY)), scaleR(Cz,KZ))
    let t = scaleR(kdotC, INV)
    var rx = subC(Cx, scaleR(t, KX)), ry = subC(Cy, scaleR(t, KY)), rz = subC(Cz, scaleR(t, KZ))
    if nu > 0 {                                          // − ν k² û
        rx = subC(rx, scaleR(uh, mul(K2, g.constant(Double(nu), dataType:.float32))))
        ry = subC(ry, scaleR(vh, mul(K2, g.constant(Double(nu), dataType:.float32))))
        rz = subC(rz, scaleR(wh, mul(K2, g.constant(Double(nu), dataType:.float32))))
    }
    return (rx, ry, rz)
}

// ---- RK4 step (all in-graph) ----
func axpy(_ U: (CX,CX,CX), _ a: Float, _ k: (CX,CX,CX)) -> (CX,CX,CX) {
    (addC(U.0, scaleS(k.0,a)), addC(U.1, scaleS(k.1,a)), addC(U.2, scaleS(k.2,a)))
}
func rk4(_ U: (CX,CX,CX), _ dt: Float) -> (CX,CX,CX) {
    let k1 = rhs(U.0,U.1,U.2)
    let k2 = rhs(axpy(U, dt/2, k1).0, axpy(U, dt/2, k1).1, axpy(U, dt/2, k1).2)
    let k3 = rhs(axpy(U, dt/2, k2).0, axpy(U, dt/2, k2).1, axpy(U, dt/2, k2).2)
    let k4 = rhs(axpy(U, dt,   k3).0, axpy(U, dt,   k3).1, axpy(U, dt,   k3).2)
    // U + dt/6 (k1 + 2k2 + 2k3 + k4)
    func comp(_ i: Int) -> CX {
        let s = addC(addC(k1i(k1,i), scaleS(k1i(k2,i),2)), addC(scaleS(k1i(k3,i),2), k1i(k4,i)))
        return addC(Ui(U,i), scaleS(s, dt/6))
    }
    return (comp(0), comp(1), comp(2))
}
func k1i(_ t:(CX,CX,CX),_ i:Int)->CX { i==0 ? t.0 : i==1 ? t.1 : t.2 }
func Ui(_ t:(CX,CX,CX),_ i:Int)->CX { i==0 ? t.0 : i==1 ? t.1 : t.2 }

// ---- diagnostics graph: E=½⟨|u|²⟩, H=⟨u·ω⟩ ----
func diag(_ uh: CX, _ vh: CX, _ wh: CX) -> (MPSGraphTensor, MPSGraphTensor) {
    let wxh = subC(mulIK(wh, KY), mulIK(vh, KZ))
    let wyh = subC(mulIK(uh, KZ), mulIK(wh, KX))
    let wzh = subC(mulIK(vh, KX), mulIK(uh, KY))
    let u = fft(uh, inverse:true).re, v = fft(vh, inverse:true).re, w = fft(wh, inverse:true).re
    let ox = fft(wxh, inverse:true).re, oy = fft(wyh, inverse:true).re, oz = fft(wzh, inverse:true).re
    let e2 = add(add(mul(u,u), mul(v,v)), mul(w,w))
    let E = mul(g.mean(of: e2, axes: [0,1,2], name: nil), g.constant(0.5, dataType:.float32))
    let h = add(add(mul(u,ox), mul(v,oy)), mul(w,oz))
    let H = g.mean(of: h, axes: [0,1,2], name: nil)
    return (E, H)
}

// ============================ run ============================
func buf(_ a: [Float]) -> MTLBuffer { a.withUnsafeBufferPointer { dev.makeBuffer(bytes: $0.baseAddress!, length: $0.count*4, options: .storageModeShared)! } }
func td(_ b: MTLBuffer) -> MPSGraphTensorData { MPSGraphTensorData(b, shape: dimsN(), dataType: .float32) }
func readF(_ d: MPSGraphTensorData) -> [Float] { var a=[Float](repeating:0,count:N*N*N); d.mpsndarray().readBytes(&a, strideBytes:nil); return a }
func readScalar(_ d: MPSGraphTensorData) -> Float { var a=[Float](repeating:0,count:1); d.mpsndarray().readBytes(&a, strideBytes:nil); return a[0] }

// ABC/Beltrami IC (real space): u=sin z+cos y, v=sin x+cos z, w=sin y+cos x
let twoPi = Float.pi*2
var u0=[Float](repeating:0,count:N*N*N), v0=u0, w0=u0
for i in 0..<N { for j in 0..<N { for k in 0..<N {
    let x=twoPi*Float(i)/Float(N), y=twoPi*Float(j)/Float(N), z=twoPi*Float(k)/Float(N)
    let idx=(i*N+j)*N+k
    u0[idx]=sin(z)+cos(y); v0[idx]=sin(x)+cos(z); w0[idx]=sin(y)+cos(x)
}}}

// IC → spectral: placeholders for real u,v,w; fft each → (re,im). One run to get initial uh,vh,wh.
let pu=g.placeholder(shape:dimsN(),dataType:.float32,name:"pu")
let pv=g.placeholder(shape:dimsN(),dataType:.float32,name:"pv")
let pw=g.placeholder(shape:dimsN(),dataType:.float32,name:"pw")
let UH0=fft(CX(re:pu,im:ZERO),inverse:false), VH0=fft(CX(re:pv,im:ZERO),inverse:false), WH0=fft(CX(re:pw,im:ZERO),inverse:false)
let icres = g.run(feeds:[pu:td(buf(u0)),pv:td(buf(v0)),pw:td(buf(w0))],
                  targetTensors:[UH0.re,UH0.im,VH0.re,VH0.im,WH0.re,WH0.im], targetOperations:nil)
var cur = [readF(icres[UH0.re]!),readF(icres[UH0.im]!),readF(icres[VH0.re]!),readF(icres[VH0.im]!),readF(icres[WH0.re]!),readF(icres[WH0.im]!)]

// step + diag graphs share placeholders ur,ui,vr,vi,wr,wi
let ur=g.placeholder(shape:dimsN(),dataType:.float32,name:"ur"), ui=g.placeholder(shape:dimsN(),dataType:.float32,name:"ui")
let vr=g.placeholder(shape:dimsN(),dataType:.float32,name:"vr"), vi=g.placeholder(shape:dimsN(),dataType:.float32,name:"vi")
let wr=g.placeholder(shape:dimsN(),dataType:.float32,name:"wr"), wi=g.placeholder(shape:dimsN(),dataType:.float32,name:"wi")
let U=(CX(re:ur,im:ui),CX(re:vr,im:vi),CX(re:wr,im:wi))
let dt:Float=0.01
let Un = rk4(U, dt)
let (Etensor,Htensor) = diag(U.0,U.1,U.2)
func feeds() -> [MPSGraphTensor:MPSGraphTensorData] {
    [ur:td(buf(cur[0])),ui:td(buf(cur[1])),vr:td(buf(cur[2])),vi:td(buf(cur[3])),wr:td(buf(cur[4])),wi:td(buf(cur[5]))]
}
func diagNow()->(Float,Float){ let r=g.run(feeds:feeds(),targetTensors:[Etensor,Htensor],targetOperations:nil); return (readScalar(r[Etensor]!),readScalar(r[Htensor]!)) }

print("GPU: \(dev.name)  N=\(N)  ABC/Beltrami inviscid — must be STATIONARY")
let (E0,H0)=diagNow(); print(String(format:"t=0.00  E=%.6f  H=%.6f  H/2E=%.4f (Beltrami⇒1)", E0,H0,H0/(2*E0)))
var maxdrift:Float=0
for _ in 1...10 {
    let r=g.run(feeds:feeds(),targetTensors:[Un.0.re,Un.0.im,Un.1.re,Un.1.im,Un.2.re,Un.2.im],targetOperations:nil)
    let nxt=[readF(r[Un.0.re]!),readF(r[Un.0.im]!),readF(r[Un.1.re]!),readF(r[Un.1.im]!),readF(r[Un.2.re]!),readF(r[Un.2.im]!)]
    for c in 0..<6 { for q in 0..<(N*N*N) { maxdrift=max(maxdrift, abs(nxt[c][q]-cur[c][q])) } }
    cur=nxt
}
let (E1,H1)=diagNow()
print(String(format:"t=%.2f  E=%.6f  H=%.6f  E/E0=%.6f  H/H0=%.6f", dt*10,E1,H1,E1/E0,H1/H0))
print(String(format:"max |Δû| over 10 steps = %.2e  %@", maxdrift, (maxdrift<1e-3 ? "STATIONARY ✓ (rhs≈0 ⇒ curl+cross+Leray correct)" : "DRIFT ✗")))
