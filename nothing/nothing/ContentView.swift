import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QuestionViewModel()
    @State private var showingTextInput = false
    @State private var currentCard: CardView?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkNavy.ignoresSafeArea()
                
                if viewModel.isQuizComplete {
                    ScoreView(
                        scores: viewModel.getAverageScores(),
                        showTextInput: $showingTextInput,
                        onRestart: {
                            viewModel.restartQuiz()
                        }
                    )
                } else {
                    VStack {
                        Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.currentQuestions.count)")
                            .font(.system(.title3, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                        
                        CardView(question: viewModel.currentQuestion) { swiped in
                            answerQuestion(swiped)
                        }
                        .id(viewModel.currentQuestionIndex)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                currentCard?.swipe(false)
                                answerQuestion(false)
                            }) {
                                Text("No")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.darkNavy)
                                    .padding()
                                    .frame(width: 100)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PressableButtonStyle())
                            
                            Button(action: {
                                currentCard?.swipe(true)
                                answerQuestion(true)
                            }) {
                                Text("Yes")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.darkNavy)
                                    .padding()
                                    .frame(width: 100)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showingTextInput) {
                TextInputView(viewModel: viewModel)
            }
        }
    }
    
    private func answerQuestion(_ answer: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.respondToQuestion(with: answer)
        }
    }
}

import SwiftUI

struct ScoreView: View {
    let scores: CategoryScores
    @Binding var showTextInput: Bool
    var onRestart: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("Your Scores")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundColor(.white)
                
                AnimatedFourSectorGraphView(scores: scores)
                    .frame(height: min(geometry.size.width, geometry.size.height) * 0.4)
                    .padding()
                
                VStack(spacing: 10) {
                    ScoreBar(title: "Adventurous", score: scores.adventurous, color: .accentPurple)
                    ScoreBar(title: "Sense", score: scores.sense, color: .accentPurple)
                    ScoreBar(title: "Ruff", score: scores.ruff, color: .accentPurple)
                    ScoreBar(title: "Vanilla", score: scores.vanilla, color: .accentPurple)
                }
                .frame(width: geometry.size.width * 0.8)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button("Restart Quiz") {
                        onRestart()
                    }
                    .buttonStyle(CustomButtonStyle())
                    .frame(width: geometry.size.width * 0.4)
                    
                    Button("Express Feelings") {
                        showTextInput = true
                    }
                    .buttonStyle(CustomButtonStyle())
                    .frame(width: geometry.size.width * 0.4)
                }
                .padding(.bottom)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.darkNavy)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}


struct ScoreBar: View {
    let title: String
    let score: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.white)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .foregroundColor(.lightNavy)
                    
                    Rectangle()
                        .frame(width: CGFloat(score) * geometry.size.width, height: 20)
                        .foregroundColor(color)
                }
            }
            .frame(height: 20)
            .cornerRadius(10)
            Text(String(format: "%.2f", score))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}



struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
