//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Игнат Рогачевич on 6.04.25.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    private let questions: [QuizQuestion] = QuizQuestion.mockQuestions
    
    func requestNextQuestion() {
        guard let question = questions.randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        delegate?.didReceiveNextQuestion(question: question)
    }
}
