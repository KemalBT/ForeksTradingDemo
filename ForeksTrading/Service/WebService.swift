//
//  WebService.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation

class Webservice {
    //Get All Stocks
    func getStocks(url: URL, completion: @escaping (Result<StockResponse?,ErrorModel>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(ErrorModel(message: error.localizedDescription)))
            } else if let data = data {
                let stockResponse = try? JSONDecoder().decode(StockResponse.self, from: data)
                if let stockResponse = stockResponse {
                    completion(.success(stockResponse))
                }
            }
        }.resume()
    }
    
    //Get All Stocks Detail
    func getStockDetails(fields: [String], stcs: [String], completion: @escaping (Result<StockDetailResponse?,ErrorModel>) -> Void) {
        let baseURL = URLs.serviceDetailURL
        let queryParams: [String: String] = ["fields": fields.joined(separator: ","), "stcs": stcs.joined(separator: "~")]
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let stockDetailsTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(ErrorModel(message: error.localizedDescription)))
            } else if let data = data {
                let stockDetailResponse = try? JSONDecoder().decode(StockDetailResponse.self, from: data)
                if let stockDetailResponse = stockDetailResponse {
                    completion(.success(stockDetailResponse))
                }
            }
        }
        stockDetailsTask.resume()
    }
}
