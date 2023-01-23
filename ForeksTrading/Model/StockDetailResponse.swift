//
//  StockDetailResponse.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation

struct StockDetailResponse: Codable {
    let l: [[String: String]]
    let z: String
}
