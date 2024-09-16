import SwiftUI

struct AnimatedFourSectorGraphView: View {
    let scores: CategoryScores
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size / 2 - 20
            
            ZStack {
                // Draw concentric circles
                ForEach(1...4, id: \.self) { i in
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .frame(width: CGFloat(i) * radius / 2)
                }
                
                // Draw main circle
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    .frame(width: radius * 2)
                
                // Draw axes
                Path { path in
                    path.move(to: CGPoint(x: center.x, y: center.y - radius))
                    path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
                    path.move(to: CGPoint(x: center.x - radius, y: center.y))
                    path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
                }
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                
                // Draw labels
                VStack {
                    Text("SENS").offset(y: -radius - 20)
                    HStack {
                        Text("V").offset(x: -radius - 20)
                        Spacer()
                        Text("ADV").offset(x: radius + 20)
                    }
                    Text("RUFF").offset(y: radius + 20)
                }
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.white)
                
                // Draw score shape
                FillShape(scores: scores, center: center, radius: radius)
                    .fill(Color.accentPurple.opacity(0.2))
                    .opacity(animationProgress)
                
                FillShape(scores: scores, center: center, radius: radius)
                    .trim(from: 0, to: animationProgress)
                    .stroke(Color.accentPurple, lineWidth: 2)
            }
            .frame(width: size, height: size)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0)) {
                    animationProgress = 1.0
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct FillShape: Shape {
    let scores: CategoryScores
    let center: CGPoint
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = [
            CGPoint(x: center.x, y: center.y - CGFloat(scores.sense) * radius),
            CGPoint(x: center.x + CGFloat(scores.adventurous) * radius, y: center.y),
            CGPoint(x: center.x, y: center.y + CGFloat(scores.ruff) * radius),
            CGPoint(x: center.x - CGFloat(scores.vanilla) * radius, y: center.y)
        ]
        
        path.move(to: points[0])
        for point in points[1...] {
            path.addLine(to: point)
        }
        path.closeSubpath()
        
        return path
    }
}
