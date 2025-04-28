import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionNuberLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    private var alertPresenter: AlertPresenter?
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    } 
        
    override func viewDidLoad() {
        super.viewDidLoad()

        statisticService = StatisticService()
        
        let questionFactory = QuestionFactory()
            questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
    
        alertPresenter = AlertPresenter(viewController: self)
            
            posterImageView.layer.cornerRadius = 20
            posterImageView.layer.masksToBounds = true
        }
        
        private func convert(model: QuizQuestion) -> QuizStep {
            let questionStep = QuizStep(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
            return questionStep
        }
        
    private func show(quiz result: QuizResultsViewModel) {
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let formattedDate = statisticService.bestGame.date.dateTimeString
        
        let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)\n
            Количество сыгранных квизов: \(statisticService.gamesCount)\n
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDate))\n
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let alertModel = AlertModel(
                title: result.title,
                message: message,
                buttonText: result.buttonText,
                completion: { [weak self] in
                    self?.currentQuestionIndex = 0
                    self?.correctAnswers = 0
                    self?.questionFactory?.requestNextQuestion()
                }
            )
            alertPresenter?.show(alertModel: alertModel)
        }
        
        private func show(quiz step: QuizStep) {
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
            
            if currentQuestionIndex == questionsAmount - 1 {
                let text = correctAnswers == questionsAmount ?
                "Поздравляем, вы ответили на 10 из 10!" :
                "Вы ответили на \(correctAnswers)/10, попробуйте ещё раз!"
                
                let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
                show(quiz: viewModel)
                posterImageView.layer.borderColor = UIColor.clear.cgColor
            } else {
                currentQuestionIndex += 1
                posterImageView.layer.borderColor = UIColor.clear.cgColor
                
                questionFactory?.requestNextQuestion()
            }
        }
        
        @IBAction private func yesButtonClick(_ sender: Any) {
            
            (sender as? UIButton)?.isEnabled = false
            
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = true
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                (sender as? UIButton)?.isEnabled = true
            }
        }
        
        @IBAction private func noButtonClick(_ sender: Any) {
            (sender as? UIButton)?.isEnabled = false
            
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = false
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                (sender as? UIButton)?.isEnabled = true
            }
        }
    }

