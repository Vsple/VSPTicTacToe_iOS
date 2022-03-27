//
//  GameModel.swift
//  VSPTicTacToe
//
//  Created by Vivek Patel on 27/03/22.
//

import Foundation


struct Playerground {
    var index: Int
    var playerType: Player = .none
}

enum Player {
    case cross
    case circle
    case none
    
    var tappedText: String {
        switch self {
        case .cross:
            return "X"
        case .circle:
            return "O"
        case .none:
            return ""
        }
    }
    
    var playerTurnText: String {
        switch self {
        case .cross:
            return "Player X"
        case .circle:
            return "Player O"
        case .none:
            return ""
        }
    }
    
    var messageOnResult: String {
        switch self {
        case .cross:
            return "Player X Win"
        case .circle:
            return "Player O Win"
        case .none:
            return "It's Tie"
        }
    }
    
}
