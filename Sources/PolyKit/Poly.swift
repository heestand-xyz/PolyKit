import SwiftUI

public struct Poly: View {
    
    let count: Int
    
    public init(count: Int) {
        self.count = max(count, 3)
    }
    
    public var body: some View {
        GeometryReader { geo in
            Path { path in
                let radius: CGFloat = min(geo.size.width, geo.size.height) / 2
                func point(angle: CGFloat) -> CGPoint {
                    let x: CGFloat = geo.size.width / 2 + sin(angle * .pi * 2) * radius
                    let y: CGFloat = geo.size.height / 2 + cos(angle * .pi * 2) * radius
                    return CGPoint(x: x, y: y)
                }
                path.move(to: point(angle: 0.0))
                for i in 0..<count {
                    let angle: CGFloat = CGFloat(i + 1) / CGFloat(count)
                    path.addLine(to: point(angle: angle))
                }
            }
        }
    }
    
}

struct Poly_Previews: PreviewProvider {
    static var previews: some View {
        Poly(count: 6)
    }
}
