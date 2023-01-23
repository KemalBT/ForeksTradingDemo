//
//  String+Extension.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func toDouble() -> Double? {
        if let doubleValue = Double(self) {
            return doubleValue
        }
        return nil
    }
    
    func convertTLStringToDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter.number(from: self)?.doubleValue
    }
}

