import Foundation
import GoogleGenerativeAI

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let scores: CategoryScores
}

struct CategoryScores {
    var adventurous: Double
    var sense: Double
    var ruff: Double
    var vanilla: Double
    
    static func +(lhs: CategoryScores, rhs: CategoryScores) -> CategoryScores {
        return CategoryScores(
            adventurous: lhs.adventurous + rhs.adventurous,
            sense: lhs.sense + rhs.sense,
            ruff: lhs.ruff + rhs.ruff,
            vanilla: lhs.vanilla + rhs.vanilla
        )
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

class QuestionViewModel: ObservableObject {
    
    
    private let allQuestions: [Question] = [
        Question(text: " Give a sensual massage to your partner? 🤝", scores: CategoryScores(adventurous: 0.2, sense: 0.5, ruff: 0.0, vanilla: 0.8)),
         
        Question(text: " Talk dirty to your partner during sex? 🗣️", scores: CategoryScores(adventurous: 0.2, sense: 0.5, ruff: 0.2, vanilla: 0.5)),
         
        Question(text: " Receive oral sex? 👅", scores: CategoryScores(adventurous: 0.4, sense: 0.5, ruff: 0.2, vanilla: 0.8)),
         
        Question(text: " Have your partner cross dress? 👗", scores: CategoryScores(adventurous: 0.8, sense: 0.2, ruff: 0.2, vanilla: 0.2)),
         
         
         
        Question(text: "Hold hands in public? 🤝", scores: CategoryScores(adventurous: 0.2, sense: 0.8, ruff: 0.2, vanilla: 0.8)),
         
                  Question(text: "Movie night cuddles? 🎬🤗", scores: CategoryScores(adventurous: 0.2, sense: 0.7, ruff: 0.2, vanilla: 0.5)),
         
                  Question(text: "Surprise dates? 🎉", scores: CategoryScores(adventurous: 0.8, sense: 0.6, ruff: 0.3, vanilla: 0.7)),
         
                  Question(text: "Good morning/night texts? 📱💕", scores: CategoryScores(adventurous: 0.2, sense: 0.9, ruff: 0.0, vanilla: 0.8)),
         
                  Question(text: "Cook meals together? 👨‍🍳👩‍🍳", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.0, vanilla: 0.7)),
         
                Question(text: "Weekly game night? 🎲", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.5, vanilla: 0.8)),
         
                Question(text: "Texting or calling when apart? 💬", scores: CategoryScores(adventurous: 0.0, sense: 0.8, ruff: 0.0, vanilla: 0.8)),
         
         
        Question(text: " Peg your partner? 🙇‍♂️", scores: CategoryScores(adventurous: 0.9, sense: 0.3, ruff: 0.9, vanilla: 0.0)),
         
        Question(text: " Have your partner give you analingus?🍩", scores: CategoryScores(adventurous: 0.6, sense: 0.3, ruff: 0.8, vanilla: 0.0)),
         
         
                Question(text: "Hug/kiss greetings? 👋😘", scores: CategoryScores(adventurous: 0.2, sense: 0.8, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: "Meet friends and family? 👥👪", scores: CategoryScores(adventurous: 0.2, sense: 0.6, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: "Book club for two? 📚💑", scores: CategoryScores(adventurous: 0.2, sense: 0.6, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: " Fantasy RPG role-play🦹🏼", scores: CategoryScores(adventurous: 0.9, sense: 0.0, ruff: 0.2, vanilla: 0.2)),
         
         
                Question(text: "Give/receive massages? 💆‍♀️💆‍♂️", scores: CategoryScores(adventurous: 0.3, sense: 0.9, ruff: 0.0, vanilla: 0.9)),
         
         
                Question(text: "Slow dance together? 💃🕺", scores: CategoryScores(adventurous: 0.6, sense: 0.6, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: "Bubble baths for two? 🛁", scores: CategoryScores(adventurous: 0.3, sense: 0.9, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: "Feed each other treats? 🍓👄", scores: CategoryScores(adventurous: 0.4, sense: 0.9, ruff: 0.0, vanilla: 0.7)),
         
                Question(text: "Candles and mood lighting? 🕯️✨", scores: CategoryScores(adventurous: 0.5, sense: 0.9, ruff: 0.0, vanilla: 0.8)),
         
                Question(text: "Romantic weekend getaway? 🏖️", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.5, vanilla: 0.8)),
         
                Question(text: "Take dance lessons? 🩰", scores: CategoryScores(adventurous: 0.8, sense: 0.6, ruff: 0.0, vanilla: 0.9)),
         
         
                Question(text: "Try partner's favorite activities? 🎳🏸", scores: CategoryScores(adventurous: 0.9, sense: 0.8, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: "Set fitness goals together? 🏋️‍♀️🏋️‍♂️", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.0, vanilla: 0.7)),
         
                Question(text: " Game of Thrones role-play🫅🏼🤴🏽", scores: CategoryScores(adventurous: 0.9, sense: 0.3, ruff: 0.3, vanilla: 0.0)),
         
                Question(text: " Pretend your partner is a complete stranger?🪂", scores: CategoryScores(adventurous: 0.9, sense: 0.2, ruff: 0.3, vanilla: 0.0)),
         
             
         
                Question(text: " Have your partner cum on your chest and stomach?🚗💨", scores: CategoryScores(adventurous: 0.2, sense: 0.4, ruff: 0.2, vanilla: 0.2)),
         
                Question(text: " Have your partner swallow your cum?🫦", scores: CategoryScores(adventurous: 0.2, sense: 0.2, ruff: 0.2, vanilla: 0.2)),
         
         
         
                Question(text: "Attend a relationship workshop? 💑📊", scores: CategoryScores(adventurous: 0.6, sense: 0.6, ruff: 0.2, vanilla: 0.8)),
         
                Question(text: "Give constructive feedback? 🗣️👂", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.5, vanilla: 0.1)),
         
         
                Question(text: "Blindfolded EXPERIENCES? 🙈", scores: CategoryScores(adventurous: 0.9, sense: 0.0, ruff: 0.9, vanilla: 0.0)),
         
                Question(text: "Sexual retreat together? 🤫🧘", scores: CategoryScores(adventurous: 0.9, sense: 0.3, ruff: 0.5, vanilla: 0.0)),
         
                Question(text: "Practice intense eye gazing? 👁️👁️", scores: CategoryScores(adventurous: 0.9, sense: 0.5, ruff: 0.3, vanilla: 0.1)),
         
                Question(text: "Share passwords? 🔐", scores: CategoryScores(adventurous: 0.2, sense: 0.3, ruff: 0.0, vanilla: 0.2)),
         
                Question(text: " Have anal sex?🍩", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.5, vanilla: 0.1)),
         
                Question(text: " Be anally fingered by your partner?🤘🏼", scores: CategoryScores(adventurous: 0.9, sense: 0.0, ruff: 0.7, vanilla: 0.0)),
         
                Question(text: "Open about all feelings? 😊😢😠", scores: CategoryScores(adventurous: 0.0, sense: 0.8, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: "Regular deep conversations? 🤔💭", scores: CategoryScores(adventurous: 0.0, sense: 0.6, ruff: 0.0, vanilla: 0.9)),
         
                Question(text: " Do it doggy-style?🦮", scores: CategoryScores(adventurous: 0.5, sense: 0.5, ruff: 0.5, vanilla: 0.5)),
         
                Question(text: " Have your partner on top more?💆🏽‍♀️💆🏼", scores: CategoryScores(adventurous: 0.9, sense: 0.6, ruff: 0.5, vanilla: 0.1)),
         
                Question(text: " Have your hair pulled during sex?💇🏽‍♀️", scores: CategoryScores(adventurous: 0.9, sense: 0.9, ruff: 0.9, vanilla: 0.9))
    ]
    
    @Published var currentQuestions: [Question] = []
        @Published var currentQuestionIndex = 0
        @Published var userScores = CategoryScores(adventurous: 0, sense: 0, ruff: 0, vanilla: 0)
        @Published var isQuizComplete = false
        @Published var answeredQuestions = 0
        
      
    private let model: GenerativeModel
       
       init() {
           let apiKey = "AIzaSyDt1emxwXfoHAUpFwy8Hr5ED7rph0K4m1w" // Replace with your actual Gemini API key
           self.model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
           selectRandomQuestions()
       }
       
       var currentQuestion: Question {
           currentQuestions[currentQuestionIndex]
       }
       
       func selectRandomQuestions() {
           currentQuestions = Array(allQuestions.shuffled().prefix(10))
           currentQuestionIndex = 0
           userScores = CategoryScores(adventurous: 0, sense: 0, ruff: 0, vanilla: 0)
           isQuizComplete = false
           answeredQuestions = 0
       }
       
       func nextQuestion() {
           if currentQuestionIndex < currentQuestions.count - 1 {
               currentQuestionIndex += 1
           } else {
               isQuizComplete = true
           }
       }
       
       func respondToQuestion(with answer: Bool) {
           if answer {
               userScores = CategoryScores(
                   adventurous: userScores.adventurous + currentQuestion.scores.adventurous,
                   sense: userScores.sense + currentQuestion.scores.sense,
                   ruff: userScores.ruff + currentQuestion.scores.ruff,
                   vanilla: userScores.vanilla + currentQuestion.scores.vanilla
               )
               answeredQuestions += 1
           }
           nextQuestion()
       }
       
       func getAverageScores() -> CategoryScores {
           guard answeredQuestions > 0 else { return CategoryScores(adventurous: 0, sense: 0, ruff: 0, vanilla: 0) }
           return CategoryScores(
               adventurous: userScores.adventurous / Double(answeredQuestions),
               sense: userScores.sense / Double(answeredQuestions),
               ruff: userScores.ruff / Double(answeredQuestions),
               vanilla: userScores.vanilla / Double(answeredQuestions)
           )
       }
       
       func restartQuiz() {
           selectRandomQuestions()
       }
       
       func analyzeText(_ text: String) async throws -> CategoryScores {
           let prompt = """
           Analyze the following text and provide scores for four categories: Adventurous, Sense, Ruff, and Vanilla.

           Vanilla means: Sweet, simple, comfortable, familiar, everyday, Basic, traditional, conventional, standard, classic, Ordinary, comfortable aspects of a relationship focusing on simple pleasures and everyday interactions.

           Adventurous means: Exciting, daring, bold, novel, thrilling, Spontaneous, risk-taking, exploratory, dynamic, playful, Experiences that push comfort zones, introduce new elements to the relationship, and create shared excitement.

           Ruff means: Deep, challenging, raw, powerful, transformative, Profound, soul-baring, vulnerable, honest, growth-oriented, Activities involving deep emotional connection, vulnerability, and personal growth that strengthen the relationship bond.

           Sense means: Intimate, romantic, tender, gentle, affectionate, Loving, passionate, warm, touchy-feely, cozy, Activities focused on engaging the senses and fostering emotional and physical closeness without explicit sexuality.

           Each score should be a number between 0 and 1, where 0 is the lowest and 1 is the highest.
           
           
           Text to analyze: "\(text)"
           
           Provide the response in the following format:
           Adventurous: [score]
           Sense: [score]
           Ruff: [score]
           Vanilla: [score]
           """
           
           
           let response = try await model.generateContent(prompt)
           guard let responseText = response.text else {
               throw NSError(domain: "GeminiError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get response from Gemini"])
           }
           

           
           let scores = parseScores(from: responseText)
           self.userScores = scores
           self.isQuizComplete = true
           
           return scores
       }
       
       private func parseScores(from text: String) -> CategoryScores {
           var scores = CategoryScores(adventurous: 0, sense: 0, ruff: 0, vanilla: 0)
           let lines = text.split(separator: "\n")
           for line in lines {
               let parts = line.split(separator: ":")
               if parts.count == 2 {
                   let category = parts[0].trimmingCharacters(in: .whitespaces).lowercased()
                   if let score = Double(parts[1].trimmingCharacters(in: .whitespaces)) {
                       switch category {
                       case "adventurous": scores.adventurous = score
                       case "sense": scores.sense = score
                       case "ruff": scores.ruff = score
                       case "vanilla": scores.vanilla = score
                       default: break
                       }
                   }
               }
           }
           return scores
       }
    }
