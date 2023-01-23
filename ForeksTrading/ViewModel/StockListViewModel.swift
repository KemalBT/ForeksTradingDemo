//
//  StockListViewModel.swift
//  ForeksTrading
//
//  Created by x on 13.01.2023.
//

import Foundation

class StockListViewModel {
    private var timer: Timer?
    var selectOptions: [Mypage]?
    var firstSelection: Mypage?
    var secondSelection: Mypage?
    
    init(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.fetchStockDetails()
        }
    }
    
    var stockList: [StockModel] = []
    
    func numberOfRowsInSection() -> Int {
        return self.stockList.count
    }
    
    func stockAtIndex(_ index: Int) -> StockViewModel {
        let stock = self.stockList[index]
        return StockViewModel(stock)
    }
    
    func getStockInitialData() {
        guard let url = URLs.serviceURL.toURL() else { print("Invalid URL: \(URLs.serviceURL)")
            return
        }
        
        Webservice().getStocks(url: url) { result in
            switch result {
            case Result.success(let response):
                let stockModels = response?.mypageDefaults?.compactMap {
                    StockModel(tke: $0.tke ?? "", cod: $0.cod ?? "", def: $0.def ?? "", gro: $0.gro ?? "", clo: "", detail: ["" : ""])
                }
                if let stockModels = stockModels {
                    self.stockList = stockModels
                }
                
                if let selections = response?.mypage {
                    self.selectOptions = selections
                    self.firstSelection = selections.first
                    self.secondSelection = selections[1]
                }
                
                self.fetchStockDetails()
                break
                
            case Result.failure(let error):
                print(error)
                break
            }
        }
    }
    
    func fetchStockDetails() {
        let fields = self.selectOptions!.compactMap {$0.key}
        let stcs = self.stockList.compactMap {$0.tke}
        
        Webservice().getStockDetails(fields: fields, stcs: stcs) { result in
            switch result {
            case Result.success(let response):
                if let stockDetails = response?.l {
                    for stock in stockDetails {
                        if let index = self.stockList.firstIndex(where: { $0.tke == stock["tke"] }) {
                            for stockValue in stock {
                                
                                if stockValue.key == "las" {
                                    if let previousValue = self.stockList[index].detail[stockValue.key] as? Double, let currentValue = stockValue.value.convertTLStringToDouble() {
                                        
                                        if previousValue == currentValue {
                                            self.stockList[index].detail["lasChanges"] = previousValue
                                        } else if previousValue < currentValue {
                                            self.stockList[index].detail.updateValue(false, forKey: "lasChanges")
                                        } else {
                                            self.stockList[index].detail.updateValue(true, forKey: "lasChanges")
                                        }
                                    }
                                }
                                
                                if (stockValue.key == "tke" ||  stockValue.key == "clo"){
                                    self.stockList[index].detail.updateValue(stockValue.value, forKey: stockValue.key)
                                } else {
                                    self.stockList[index].detail.updateValue(stockValue.value.convertTLStringToDouble() ?? Double(0), forKey: stockValue.key)
                                }
                                
                                if stockValue.key == "clo" {
                                    self.stockList[index].clo = stockValue.value
                                }
                            }
                        }
                    }
                    NotificationCenter.default.post(name: .dataUpdated, object: nil)
                }
                break
                
            case Result.failure(let error):
                print(error)
                break
            }
        }
    }
}

struct StockViewModel {
    let stock: StockModel
    
    init(_ stock: StockModel) {
        self.stock = stock
    }
    
    var code: String {
        return self.stock.cod
    }
    
    var group: String {
        return self.stock.gro
    }
    
    var name: String {
        return self.stock.tke
    }
    
    var definition: String {
        return self.stock.def
    }
    
    var detail: [String:Any] {
        return self.stock.detail
    }
}
