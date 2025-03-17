import UIKit
struct QuizQuestion {
let image: String
let text: String
let correctAnswer: Bool
}
struct QuizStepViewModel {
let image: UIImage
let question: String
let questionNumber: String
}
let currentQuestion = questions[currentQuestionIndex]
private var currentQuestionIndex = 0
private var correctAnswers = 0
private let questions: [QuizQuestion] = [
    QuizQuestion(image:"The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image:"The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image:"Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image:"The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image:"Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image:"The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image:"Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image:"The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image:"Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image:"Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)]
private func convert(model: QuizQuestion) -> QuizStepViewModel {
    let questionStep = QuizStepViewModel(
        image: UIImage(named: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // 4
    return questionStep
}

final class MovieQuizViewController: UIViewController {
@IBOutlet private weak var questionLabel: UILabel!
@IBOutlet private weak var questionNuberLabel: UILabel!
@IBOutlet private weak var posterImageView: UIImageView!
    
override func viewDidLoad() {
    super.viewDidLoad()
    show(quiz: convert(model: currentQuestion))
    
    
}
private func show(quiz step: QuizStepViewModel) {
    questionLabel.text = step.question
    questionNuberLabel.text = step.questionNumber
    posterImageView.image = step.image
    }
    
@IBAction private func yesButtonClick(_ sender: Any) {
}
@IBAction private func noButtonClick(_ sender: Any) {
}
    
}


/*
Mock-данные


Картинка: The Godfather
Настоящий рейтинг: 9,2
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА


Картинка: The Dark Knight
Настоящий рейтинг: 9
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА


Картинка: Kill Bill
Настоящий рейтинг: 8,1
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА


Картинка: The Avengers
Настоящий рейтинг: 8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА


Картинка: Deadpool
Настоящий рейтинг: 8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА


Картинка: The Green Knight
Настоящий рейтинг: 6,6
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА


Картинка: Old
Настоящий рейтинг: 5,8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ


Картинка: The Ice Age Adventures of Buck Wild
Настоящий рейтинг: 4,3
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ


Картинка: Tesla
Настоящий рейтинг: 5,1
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ


Картинка: Vivarium
Настоящий рейтинг: 5,8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ
*/
