import SwiftUI

struct CardView: View {
    let question: Question
    @State private var offset = CGSize.zero
    @State private var color: Color = .white
    var onSwipe: (Bool) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(question.text)
                    .font(.system(.title3, design: .rounded))
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.darkNavy)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(color)
            .cornerRadius(10)
            .offset(x: offset.width, y: 0)
            .rotationEffect(.degrees(Double(offset.width / 10)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                        self.color = self.offset.width > 0 ? .green : .red
                    }
                    .onEnded { _ in
                        if self.offset.width > geometry.size.width * 0.3 {
                            onSwipe(true)
                        } else if self.offset.width < -geometry.size.width * 0.3 {
                            onSwipe(false)
                        } else {
                            self.offset = .zero
                            self.color = .white
                        }
                    }
            )
            .animation(.spring(), value: offset)
        }
    }
    
    func swipe(_ right: Bool) {
        withAnimation(.spring()) {
            offset.width = right ? 500 : -500
            color = right ? .green : .red
        }
    }
}
