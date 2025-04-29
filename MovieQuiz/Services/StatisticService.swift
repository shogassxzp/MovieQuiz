//
//  StaticService.swift
//  MovieQuiz
//
//  Created by Игнат Рогачевич on 28.04.25.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys: String {
        case gamesCount
        case totalCorrectAnswers
        case totalQuestions
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
    
    private let storage: UserDefaults = .standard
    
    private var totalQuestions: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if totalQuestions == 0 {
            return 0.0
        }
        return (Double(correctAnswers) / Double(totalQuestions)) * 100
    }
    
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            return storage.set(newValue,forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        gamesCount += 1
        
        correctAnswers += count
        
        totalQuestions += amount
        
        let bestGame = self.bestGame
        if currentGame.isBetterThen(bestGame) {
            self.bestGame = currentGame
        }
    }
}
