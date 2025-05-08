import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?

    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol = StatisticService()

    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    func getCorrectAnswers() -> Int {
        return correctAnswers
    }

    func resetCorrectAnswers() {
        correctAnswers = 0
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }

    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    func convert(model: QuizQuestion) -> QuizStep {
        return QuizStep(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: any Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(step: viewModel)
        }
    }

    func showNextQuestionOrResults() {
        if isLastQuestion() {
            let text = getCorrectAnswers() == questionsAmount ?
                "Поздравляем, вы ответили на 10 из 10!" :
                "Вы ответили на \(getCorrectAnswers())/\(questionsAmount), попробуйте ещё раз!"

            let viewModel = QuizResults(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            statisticService.store(correct: getCorrectAnswers(), total: questionsAmount)
            viewController?.clearPosterBorder()
            viewController?.showResults(result: viewModel)
        } else {
            viewController?.clearPosterBorder()
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func makeResultsMessage() -> String {
        let formattedDate = statisticService.bestGame.date.dateTimeString
        return """
        Ваш результат: \(getCorrectAnswers())/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(formattedDate))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
    }

    func handleAnswer(answer: Bool) {
        print("handleAnswer called with answer: \(answer)")
        guard let currentQuestion = currentQuestion else { return }

        let isCorrect = answer == currentQuestion.correctAnswer
        if isCorrect {
            correctAnswers += 1
        }

        viewController?.disableButtons()
        viewController?.updatePosterBorder(isCorrect: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewController?.enableButtons()
            self.showNextQuestionOrResults()
        }
    }
}
