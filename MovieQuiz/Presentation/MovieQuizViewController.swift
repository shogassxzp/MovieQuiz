import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool }

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String }

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
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
        posterImageView.layer.cornerRadius = 20
        posterImageView.layer.masksToBounds = true
        
    }
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: "Раунд завершён",
                                      message: "Ваш результат \(correctAnswers)/10",
                                      preferredStyle: .alert) // .alert или .actionSheet
        
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            currentQuestionIndex = 0
            correctAnswers = 0
            
            let firstQuestion = questions[currentQuestionIndex] // 2
            let viewModel = convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    private func show(quiz step: QuizStepViewModel) {
        questionLabel.text = step.question
        questionNuberLabel.text = step.questionNumber
        posterImageView.image = step.image
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            posterImageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            posterImageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        posterImageView.layer.borderWidth = 6
        posterImageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            posterImageView.layer.borderColor = UIColor.clear.cgColor
        } else {
            currentQuestionIndex += 1
            posterImageView.layer.borderColor = UIColor.clear.cgColor
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
            
        }
    }
    
    
    @IBAction private func yesButtonClick(_ sender: Any) {
        
        (sender as? UIButton)?.isEnabled = false
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            (sender as? UIButton)?.isEnabled = true
        }
    }
    @IBAction private func noButtonClick(_ sender: Any) {
        (sender as? UIButton)?.isEnabled = false
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            (sender as? UIButton)?.isEnabled = true
        }
    }
}

