//
//  iexAPI.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import Foundation

let token = "pk_81421d8d811944d1bf24501943dedd19"

class iexAPI {
    static func quote(symbol: String, completion:@escaping (IEXQuote?) -> ()) {
        let apiPath = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)"
        guard let url = URL(string: apiPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let quote = try JSONDecoder().decode(IEXQuote.self, from: data)
                    DispatchQueue.main.async {
                        completion(quote)
                    }
                } else {
                    let errorString = error?.localizedDescription ?? "unknown"
                    Log.error("Failed to fetch url: \(url), error: \(errorString), response: \(String(describing: response))")
                    completion(nil)
                }
            } catch {
                Log.error("Failed to fetch: \(symbol), error: \(error)")
                completion(nil)
            }
        }
        .resume()
    }
    
    static func delayedQuote(symbol: String, completion:@escaping (IEXQuoteDelayed?) -> ()) {
        let apiPath = "https://cloud.iexapis.com/stable/stock/\(symbol)/delayed-quote?token=\(token)"
        guard let url = URL(string: apiPath) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let delayed = try JSONDecoder().decode(IEXQuoteDelayed.self, from: data)
                    DispatchQueue.main.async {
                        completion(delayed)
                    }
                } else {
                    let errorString = error?.localizedDescription ?? "unknown"
                    Log.error("Failed to fetch url: \(url), error: \(errorString), response: \(String(describing: response))")
                    completion(nil)
                }
            } catch {
                Log.error("Failed to fetch: \(symbol), error: \(error)")
                completion(nil)
            }
        }
        .resume()
    }
    
    static func chainedQuote(symbol: String, completion:@escaping (Quote?) -> ()) {
        quote(symbol: symbol) { iexQuote in
            delayedQuote(symbol: symbol) { delayedQuote in
                if let iexQuote = iexQuote {
                    if let delayed = delayedQuote {
                        completion(Quote(iexQuote, delayed: delayed))
                    } else {
                        completion(Quote(iexQuote))
                    }
                } else {
                     completion(nil)
                }
            }
        }
    }
}
