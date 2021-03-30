//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinData(_ coinManager: CoinManager, coin: CoinData
    )
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "CAC1EC80-B24F-4FEF-8267-7C46791869C4"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data,response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateCoinData(self, coin: coin)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinData? {
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            return decodedData
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
