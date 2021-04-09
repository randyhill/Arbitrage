//
//  EquityAPI.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import Foundation

let token = "pk_81421d8d811944d1bf24501943dedd19"
class apiCall {
    func getStockPrice(ticker: String, completion:@escaping (EquityModel) -> ()) {
        let apiPath = "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=\(token)"
       guard let url = URL(string: apiPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let stock = try! JSONDecoder().decode(EquityModel.self, from: data!)
            
            DispatchQueue.main.async {
                completion(stock)
            }
        }
        .resume()
    }
}
