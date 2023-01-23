//
//  Dictionary+Extension.swift
//  ForeksTrading
//
//  Created by x on 16.01.2023.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    mutating func append(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}
