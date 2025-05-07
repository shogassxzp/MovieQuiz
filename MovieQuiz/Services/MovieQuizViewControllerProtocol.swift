import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(step: QuizStep)
    func showResults(result: QuizResults)
    func updatePosterBorder(isCorrect: Bool)
    func clearPosterBorder()
    func enableButtons()
    func disableButtons()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
}
