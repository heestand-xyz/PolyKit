import SwiftUI

public struct Poly: View {
    
    let count: Int
    
    let constantCornerRadius: CGFloat?
    let relativeCornerRadius: CGFloat?
    
    private var strokeLineWidth: CGFloat?
    
    public init(count: Int, cornerRadius: CGFloat = 0.0) {
        self.count = max(count, 3)
        constantCornerRadius = max(cornerRadius, 0.0)
        relativeCornerRadius = nil
    }
    
    /// `relativeCornerRadius` is between `0.0` and `1.0`, where `0.0` is no corner radius and `1.0` is a circle.
    public init(count: Int, relativeCornerRadius: CGFloat) {
        self.count = max(count, 3)
        constantCornerRadius = nil
        self.relativeCornerRadius = min(max(relativeCornerRadius, 0.0), 1.0)
    }
    
    private init(count: Int, cornerRadius: CGFloat = 0.0, strokeLineWidth: CGFloat) {
        self.count = max(count, 3)
        constantCornerRadius = max(cornerRadius, 0.0)
        relativeCornerRadius = nil
        self.strokeLineWidth = strokeLineWidth
    }
    
    private init(count: Int, relativeCornerRadius: CGFloat, strokeLineWidth: CGFloat) {
        self.count = max(count, 3)
        constantCornerRadius = nil
        self.relativeCornerRadius = min(max(relativeCornerRadius, 0.0), 1.0)
        self.strokeLineWidth = strokeLineWidth
    }
    
    public var body: some View {
        
        GeometryReader { geo in
            
            if cornerRadius(size: geo.size) == 0.0 {
                
                if let lineWidth: CGFloat = strokeLineWidth {
                    Path { draw(on: &$0, size: geo.size) }
                        .stroke(lineWidth: lineWidth)
                } else {
                    Path { draw(on: &$0, size: geo.size) }
                }
                
            } else if dynamicRelativeCornerRadius(size: geo.size) < 1.0 {
                
                if let lineWidth: CGFloat = strokeLineWidth {
                    Path { drawRound(on: &$0, size: geo.size) }
                        .stroke(lineWidth: lineWidth)
                } else {
                    Path { drawRound(on: &$0, size: geo.size) }
                }
                
            } else {
                
                ZStack {
                    Color.clear
                    Group {
                        if let lineWidth: CGFloat = strokeLineWidth {
                            Circle()
                                .stroke(lineWidth: lineWidth)
                        } else {
                            Circle()
                        }
                    }
                    .frame(width: maxRadius(size: geo.size) * 2,
                           height: maxRadius(size: geo.size) * 2)
                }
                
            }
            
        }
        
    }
    
    func draw(on path: inout Path, size: CGSize) {
        
        for i in 0..<count {
            
            if i == 0 {
                let currentPoint: CGPoint = point(angle: angle(index: CGFloat(i)), size: size)
                path.move(to: currentPoint)
            }
            
            let nextPoint: CGPoint = point(angle: angle(index: CGFloat(i) + 1.0), size: size)
            path.addLine(to: nextPoint)
            
        }
        
        path.closeSubpath()
        
    }
    
    func drawRound(on path: inout Path, size: CGSize) {
        
        let aCornerRadius: CGFloat = cornerRadius(size: size)
        
        for i in 0..<count {
            
            let prevPoint: CGPoint = point(angle: angle(index: CGFloat(i) - 1.0), size: size)
            let currentPoint: CGPoint = point(angle: angle(index: CGFloat(i)), size: size)
            let nextPoint: CGPoint = point(angle: angle(index: CGFloat(i) + 1.0), size: size)
            
            let cornerCircle: RounedCornerCircle = rounedCornerCircle(leading: prevPoint,
                                                                      center: currentPoint,
                                                                      trailing: nextPoint,
                                                                      cornerRadius: aCornerRadius)
            
            let startAngle = angle(index: CGFloat(i) - 0.5)
            let startAngleInRadians: Angle = .radians(Double(startAngle) * .pi * 2.0)
            let endAngle = angle(index: CGFloat(i) + 0.5)
            let endAngleInRadians: Angle = .radians(Double(endAngle) * .pi * 2.0)
            
            path.addArc(center: cornerCircle.center,
                        radius: aCornerRadius,
                        startAngle: startAngleInRadians,
                        endAngle: endAngleInRadians,
                        clockwise: false)
            
        }
        
        path.closeSubpath()
        
    }
    
    func cornerRadius(size: CGSize) -> CGFloat {
        if let constant: CGFloat = constantCornerRadius {
            return constant
        }
        if let relative: CGFloat = relativeCornerRadius {
            return relative * maxRadius(size: size)
        }
        return 0.0
    }
    
    public func stroke(lineWidth: CGFloat = 1.0) -> Poly {
        if let constant: CGFloat = constantCornerRadius {
            return Poly(count: count, cornerRadius: constant, strokeLineWidth: lineWidth)
        }
        return Poly(count: count, relativeCornerRadius: relativeCornerRadius ?? 0.0, strokeLineWidth: lineWidth)
    }
    
    func radius(size: CGSize) -> CGFloat {
        min(size.width, size.height) / 2.0
    }
    
    func angle(index: CGFloat) -> CGFloat {
        index / CGFloat(count) - 0.25
    }
    
    func point(angle: CGFloat, size: CGSize) -> CGPoint {
        let x: CGFloat = size.width / 2.0 + cos(angle * .pi * 2.0) * radius(size: size)
        let y: CGFloat = size.height / 2.0 + sin(angle * .pi * 2.0) * radius(size: size)
        return CGPoint(x: x, y: y)
    }
    
    func dynamicRelativeCornerRadius(size: CGSize) -> CGFloat {
        guard let relative: CGFloat = relativeCornerRadius else {
            return unitCornerRadius(size: size) * 2
        }
        return relative
    }
    
    func unitCornerRadius(size: CGSize) -> CGFloat {
        
        let prevPoint: CGPoint = point(angle: angle(index: -1.0), size: size)
        let currentPoint: CGPoint = point(angle: angle(index: 0.0), size: size)
        let nextPoint: CGPoint = point(angle: angle(index: 1.0), size: size)
        
        let pointDistance: CGPoint = CGPoint(x: abs(nextPoint.x - currentPoint.x),
                                             y: abs(nextPoint.y - currentPoint.y))
        let distance: CGFloat = sqrt(pow(pointDistance.x, 2.0) + pow(pointDistance.y, 2.0))
        
        let cornerCircle: RounedCornerCircle = rounedCornerCircle(leading: prevPoint, center: currentPoint, trailing: nextPoint, cornerRadius: cornerRadius(size: size))
        
        let cornerPointDistance: CGPoint = CGPoint(x: abs(cornerCircle.trailing.x - currentPoint.x),
                                                   y: abs(cornerCircle.trailing.y - currentPoint.y))
        let cornerDistance: CGFloat = sqrt(pow(cornerPointDistance.x, 2.0) + pow(cornerPointDistance.y, 2.0))
        
        return cornerDistance / distance
        
    }
    
    func maxRadius(size: CGSize) -> CGFloat {
        
        let currentPoint: CGPoint = point(angle: angle(index: 0.0), size: size)
        let nextPoint: CGPoint = point(angle: angle(index: 1.0), size: size)
        
        let midPoint: CGPoint = CGPoint(x: (currentPoint.x + nextPoint.x) / 2,
                                        y: (currentPoint.y + nextPoint.y) / 2)
        
        let centerPoint: CGPoint = CGPoint(x: size.width / 2,
                                           y: size.height / 2)
        
        let pointDistance: CGPoint = CGPoint(x: abs(midPoint.x - centerPoint.x),
                                             y: abs(midPoint.y - centerPoint.y))
        let distance: CGFloat = sqrt(pow(pointDistance.x, 2.0) + pow(pointDistance.y, 2.0))
        
        return distance
        
    }
    
    func interpolate(from pointA: CGPoint, to pointB: CGPoint, at fraction: CGFloat) -> CGPoint {
        CGPoint(x: pointA.x * (1.0 - fraction) + pointB.x * fraction,
                y: pointA.y * (1.0 - fraction) + pointB.y * fraction)
    }
    
    struct RounedCornerCircle {
        let center: CGPoint
        let leading: CGPoint
        let trailing: CGPoint
    }
    
    func rounedCornerCircle(leading: CGPoint,
                            center: CGPoint,
                            trailing: CGPoint,
                            cornerRadius: CGFloat) -> RounedCornerCircle {
        rounedCornerCircle(center, leading, trailing, cornerRadius)
    }
    
    private func rounedCornerCircle(_ p: CGPoint,
                                    _ p1: CGPoint,
                                    _ p2: CGPoint,
                                    _ r: CGFloat) -> RounedCornerCircle {
        
        var r: CGFloat = r
        
        //Vector 1
        let dx1: CGFloat = p.x - p1.x
        let dy1: CGFloat = p.y - p1.y
        
        //Vector 2
        let dx2: CGFloat = p.x - p2.x
        let dy2: CGFloat = p.y - p2.y
        
        //Angle between vector 1 and vector 2 divided by 2
        let angle: CGFloat = (atan2(dy1, dx1) - atan2(dy2, dx2)) / 2
        
        // The length of segment between angular point and the
        // points of intersection with the circle of a given radius
        let _tan: CGFloat = abs(tan(angle))
        var segment: CGFloat = r / _tan
        
        //Check the segment
        let length1: CGFloat = sqrt(pow(dx1, 2) + pow(dy1, 2))
        let length2: CGFloat = sqrt(pow(dx2, 2) + pow(dy2, 2))
        
        let _length: CGFloat = min(length1, length2)
        
        if segment > _length {
            segment = _length;
            r = _length * _tan;
        }
        
        // Points of intersection are calculated by the proportion between
        // the coordinates of the vector, length of vector and the length of the segment.
        let p1Cross: CGPoint = proportion(p, segment, length1, dx1, dy1)
        let p2Cross: CGPoint = proportion(p, segment, length2, dx2, dy2)
        
        // Calculation of the coordinates of the circle
        // center by the addition of angular vectors.
        let dx: CGFloat = p.x * 2 - p1Cross.x - p2Cross.x
        let dy: CGFloat = p.y * 2 - p1Cross.y - p2Cross.y
        
        let L: CGFloat = sqrt(pow(dx, 2) + pow(dy, 2))
        let d: CGFloat = sqrt(pow(segment, 2) + pow(r, 2))
        
        let circlePoint: CGPoint = proportion(p, d, L, dx, dy)
        
        return RounedCornerCircle(center: circlePoint, leading: p1Cross, trailing: p2Cross)
        
    }
    
    private func proportion(_ point: CGPoint,
                            _ segment: CGFloat,
                            _ length: CGFloat,
                            _ dx: CGFloat,
                            _ dy: CGFloat) -> CGPoint {
        let factor: CGFloat = segment / length
        return CGPoint(x: point.x - dx * factor,
                       y: point.y - dy * factor)
    }
    
}

struct Poly_Previews: PreviewProvider {
    static var previews: some View {
        Poly(count: 6, cornerRadius: 60)
    }
}
