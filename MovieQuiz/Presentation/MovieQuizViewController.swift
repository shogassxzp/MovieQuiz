import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var questionNumberLabel: UILabel!
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButton: UIButton!

    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)

        posterImageView.layer.cornerRadius = 20
        posterImageView.layer.masksToBounds = true
        showLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    func updatePosterBorder(isCorrect: Bool) {
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        posterImageView.layer.borderWidth = 6
        posterImageView.layer.cornerRadius = 20
    }

    func clearPosterBorder() {
        posterImageView.layer.borderColor = UIColor.clear.cgColor
    }

    func showQuestion(step: QuizStep) {
        questionLabel.text = step.question
        questionNumberLabel.text = step.questionNumber
        posterImageView.image = step.image
    }

    func showResults(result: QuizResults) {
        let message = presenter.makeResultsMessage()

        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: { [weak self] in
                self?.presenter.restartGame()
            }
        )

        alertPresenter?.show(alertModel: alertModel)
    }

    @IBAction private func yesButtonClick(_ sender: Any) {
        presenter.handleAnswer(answer: true)
    }

    @IBAction private func noButtonClick(_ sender: Any) {
        presenter.handleAnswer(answer: false)
    }

    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }

                self.presenter.restartGame()
                self.showLoadingIndicator()
            }
        alertPresenter?.show(alertModel: model)
    }
}
