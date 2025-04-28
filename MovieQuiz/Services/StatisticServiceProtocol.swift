//
//  StaticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Игнат Рогачевич on 28.04.25.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int , total amount: Int)
}
