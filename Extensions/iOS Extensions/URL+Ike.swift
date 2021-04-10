//
//  URL+Ike.swift
//  Ike
//
//  Created by Randy Hill on 1/3/21.
//

import Foundation

extension URL {
     static var documentsDirectory: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    static func forDocument(named: String) -> URL {
        return documentsDirectory.appendingPathComponent(named)
    }
}
