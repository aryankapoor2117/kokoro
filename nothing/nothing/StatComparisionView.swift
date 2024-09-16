import SwiftUI

struct StatComparisonView: View {
    let beforeScores: CategoryScores
    let afterScores: CategoryScores
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkNavy.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Stats Comparison")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        ComparisonBar(title: "Adventurous", before: beforeScores.adventurous, after: afterScores.adventurous)
                        ComparisonBar(title: "Sense", before: beforeScores.sense, after: afterScores.sense)
                        ComparisonBar(title: "Ruff", before: beforeScores.ruff, after: afterScores.ruff)
                        ComparisonBar(title: "Vanilla", before: beforeScores.vanilla, after: afterScores.vanilla)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ComparisonBar: View {
    let title: String
    let before: Double
    let after: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Text("Before")
                    .font(.caption)
                    .foregroundColor(.white)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: CGFloat(before) * geometry.size.width)
                    }
                }
                .frame(height: 20)
                .cornerRadius(5)
                
                Text(String(format: "%.2f", before))
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            HStack {
                Text("After")
                    .font(.caption)
                    .foregroundColor(.white)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: CGFloat(after) * geometry.size.width)
                    }
                }
                .frame(height: 20)
                .cornerRadius(5)
                
                Text(String(format: "%.2f", after))
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}
