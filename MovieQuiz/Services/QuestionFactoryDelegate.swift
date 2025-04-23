//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Игнат Рогачевич on 19.04.25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion (question: QuizQuestion?)
}
