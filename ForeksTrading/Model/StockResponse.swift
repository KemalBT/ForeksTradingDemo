//
//  StockResponse.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation

struct StockResponse: Codable {
    let mypageDefaults: [MypageDefault]?
    let mypage: [Mypage]?
}

struct MypageDefault: Codable {
    let cod: String?
    let gro: String?
    let tke: String?
    let def: String?
}

struct Mypage: Codable {
    let name: String?
    let key: String?
}

//Expected JSON Response for Ticker
//{
//    "cod": "XU100",
//    "gro": "001",
//    "tke": "XU100.I.BIST",
//    "def": "BIST 100"
//}

//Expected JSON Response for Ticker Order Section
//"mypage": [
//        {
//            "name": "Son",
//            "key": "las"
//        },
