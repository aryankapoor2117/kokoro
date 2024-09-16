import SwiftUI
import GoogleGenerativeAI

struct TextInputView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @State private var inputText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAnalyzing = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.darkNavy.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextEditor(text: $inputText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(height: 200)
                    
                    Button(action: analyzeText) {
                        if isAnalyzing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .darkNavy))
                        } else {
                            Text("Analyze Feelings")
                        }
                    }
                    .foregroundColor(.darkNavy)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .disabled(isAnalyzing)
                }
                .padding()
            }
            .navigationTitle("Express Your Feelings")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Analysis Complete"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    private func analyzeText() {
        isAnalyzing = true
        Task {
            do {
                let scores = try await viewModel.analyzeText(inputText)
                alertMessage = """
                Analysis Results:
                Adventurous: \(String(format: "%.2f", scores.adventurous))
                Sense: \(String(format: "%.2f", scores.sense))
                Ruff: \(String(format: "%.2f", scores.ruff))
                Vanilla: \(String(format: "%.2f", scores.vanilla))
                """
                showingAlert = true
            } catch {
                alertMessage = "Error: \(error.localizedDescription)"
                showingAlert = true
            }
            isAnalyzing = false
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(viewModel: QuestionViewModel())
    }
}
