//
//  StockModel.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation

struct StockModel: Hashable {
    let tke: String
    let cod: String
    let def: String
    let gro: String
    var clo: String
    var detail: [String:AnyHashable]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tke)
        hasher.combine(cod)
    }
    
    static func == (lhs: StockModel, rhs: StockModel) -> Bool {
        return lhs.tke == rhs.tke && lhs.clo == rhs.clo
    }
}
