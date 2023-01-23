//
//  ErrorModel.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation
class ErrorModel: Error {
    
    // MARK: - Properties
    var message: String?
    var statusCode: Int?
    var error: Error?
    
    init(message: String) {
        self.message = message
    }
    
    init(statusCode: Int) {
        self.statusCode = statusCode
    }
    
    init(message: String?, statusCode: Int?, error: Error?) {
        self.message = message
        self.statusCode = statusCode
        self.error = error
    }
}
