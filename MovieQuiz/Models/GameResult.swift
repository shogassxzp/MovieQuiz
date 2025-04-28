//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Игнат Рогачевич on 28.04.25.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThen(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
