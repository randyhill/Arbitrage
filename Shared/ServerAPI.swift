//
//  EquityAPI.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import Foundation

let token = "pk_81421d8d811944d1bf24501943dedd19"

class ServerAPI {
    static func getEquity(ticker: String, completion:@escaping (Equity) -> ()) {
        let apiPath = "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=\(token)"
       guard let url = URL(string: apiPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                let stock = try JSONDecoder().decode(Equity.self, from: data!)
                completion(stock)
            } catch {
                Log.error("Failed to fetch: \(ticker), error: \(error)")
            }
        }
        .resume()
    }
}
