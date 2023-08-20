//
//  CoinManager.swift
//  BtcTracker
//
//  Created by Тимур on 20.08.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    }

struct CoinManager {
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "Вставьте сюдя свой API, для того, чтобы работало приложение"
    let currencyArray = ["USD","RUB", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","SEK","SGD","ZAR"]
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String) {
        let coinURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: coinURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let bitecoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitecoinPrice)
                        
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
