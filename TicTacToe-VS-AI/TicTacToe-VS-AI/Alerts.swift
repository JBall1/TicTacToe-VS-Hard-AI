//
//  Alerts.swift
//  TicTacToe-VS-AI
//
//  Created by Joshua Ball on 4/30/21.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win!"), message: Text("Human wins"), buttonTitle: Text("Ok"))
    static let computerWin = AlertItem(title: Text("You Lost"), message: Text("SUPER AI VICTORIOUS"), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("DRAW"), message: Text("What a battle of wits we have here..."), buttonTitle: Text("Try Again"))
}
