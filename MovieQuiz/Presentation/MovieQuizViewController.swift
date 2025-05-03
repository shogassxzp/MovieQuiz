import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionNumberLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var alertPresenter: AlertPresenter?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        alertPresenter = AlertPresenter(viewController: self)
        
        posterImageView.layer.cornerRadius = 20
        posterImageView.layer.masksToBounds = true
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func show(quiz step: QuizStep) {
        questionLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
        posterImageView.image = step.image
    }
    
    private func convert(model: QuizQuestion) -> QuizStep {
        return QuizStep(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
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
            
            let viewModel = QuizResults (
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
        handleAnswer(sender: sender, answer: true)
    }
    
    @IBAction private func noButtonClick(_ sender: Any) {
        handleAnswer(sender: sender, answer: false)
    }
    
    private func handleAnswer(sender: Any, answer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
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
    
    func didLoadDataFromServer() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.questionFactory?.requestNextQuestion()
        }
    }
    
    func didFailToLoadData(with error: any Error) {
        DispatchQueue.main.async {[weak self] in
            self?.showNetworkError(message: error.localizedDescription)
        }
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: "",
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
                    
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.showLoadingIndicator()
                    self.questionFactory?.loadData()
                }
       
        alertPresenter?.show(alertModel: model)
    }
    private func show(quiz result: QuizResults) {
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let formattedDate = statisticService.bestGame.date.dateTimeString
        
        let message = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDate))
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
    
}

