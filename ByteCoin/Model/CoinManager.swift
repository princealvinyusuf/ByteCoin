//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Prince Alvin Yusuf on 22/02/2021.
//  Copyright © 2021 Prince Alvin Yusuf. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinData: CoinModel)
    func didFailWithError(_ coinManager: CoinManager,error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9A7F4DD0-E203-4E22-AABB-CD0A2E36F0F9"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            // Create a URLSession
            let session = URLSession(configuration: .default)

            // Give the Session a Task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let coinCurrency = self.parseJSON(currencyData: safeData){
                        self.delegate?.didUpdateCoin(self, coinData: coinCurrency)
                    }
                    
                }
            }
            // Start a Task
            task.resume()
        }
        
    }
    
    func parseJSON(currencyData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: currencyData)
            let lastPrice = decodedData.rate
            print(lastPrice)
            let coinModel = CoinModel(rate: lastPrice)
            return coinModel
            
        } catch {
            print(error)
            delegate?.didFailWithError(self, error: error)
            return nil
        }
        
    }
    
}
