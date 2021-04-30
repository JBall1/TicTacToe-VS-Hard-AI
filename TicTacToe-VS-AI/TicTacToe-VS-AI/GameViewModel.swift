//
//  GameViewModel.swift
//  TicTacToe-VS-AI
//
//  Created by Joshua Ball on 4/30/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    
    
    func processPlayerMove(for position: Int){
        //creates move based on tap
        if isSquareOccupied(in: moves, forIndex: position){return}
        moves[position] = Move(player: .human, boardIndex: position)
        
        //check for win condition or draw
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        //.5 second delay for computer to make their move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
        
    }
    //Checks each element in array of moves for occupied index that is occupied
    //Retruns true if occupied
    func isSquareOccupied(in moves: [Move?], forIndex index: Int ) -> Bool{
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    //If AI can win, Take winning pos
    //If AI cant win, block winning spot
    //if AI cant block, take middle
    //otherwise take random open space
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win, Take winning pos
        //check for 2/3 items
        let winPatters: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
                                         [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMoves = moves.compactMap{$0}.filter{$0.player == .computer}
        //Gives all board indexs of computer moves
        let computerPositons = Set(computerMoves.map{$0.boardIndex})
        
        for pattern in winPatters {
            //subtracts intersecting positions. We want to find a win pattern set
            //with a size of 1 after subtraction.
            let winPositions = pattern.subtracting(computerPositons)
            
            if winPositions.count == 1 {
                let isAvaliable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaliable{ return winPositions.first! }
            }
        }
        
        //If AI cant win, block winning spot
        let humanMoves = moves.compactMap{$0}.filter{$0.player == .human}
        //Gives all board indexs of computer moves
        let humanPositons = Set(humanMoves.map{$0.boardIndex})
        
        for pattern in winPatters {
            //subtracts intersecting positions. We want to find a win pattern set
            //with a size of 1 after subtraction.
            let winPositions = pattern.subtracting(humanPositons)
            
            if winPositions.count == 1 {
                let isAvaliable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaliable{ return winPositions.first! }
            }
        }
        
        
        //if AI cant block or win, take middle
        let centerSqure = 4
        if !isSquareOccupied(in: moves, forIndex: centerSqure){
            return centerSqure
        }
        
        //otherwise take random open space
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatters: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
                                         [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        //removes all nil elements and isolates players moves
        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        //Gives all board indexs of players moves
        let playerPositons = Set(playerMoves.map{$0.boardIndex})
        
        //check is board indexes are a subset of any of the win conditions
        for pattern in winPatters where pattern.isSubset(of: playerPositons){return true}
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        //Compact map to remove nils
        //if count == 9, draw condition
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
}
