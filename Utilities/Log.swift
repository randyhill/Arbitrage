//
//  Log.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import Foundation
import SwiftUI

class Log {
    static private func log(_ message: String) {
        print(message)
    }
    
	static func assert(_ isTrue: Bool, _ message: String) {
		if !isTrue {
			log("ASSERT FAILURE: \(message) ")
		}
	}
    
    static func error(_ message: String) {
        log("Error: \(message)")
    }
    
    static func exitApp(_ message: String) {
        log("Fatal error: \(message)")
        fatalError()
    }
    
    static func info(_ message: String) {
        log("\(message)")
    }
    
    static func console(_ value: Any) {
        log("\(value)\n")
    }
    
    static func isError(_ message: String) -> Bool {
        log(message)
        return true
    }
}

struct ViewError: View {
    var message: String
    var body: some View {
        EmptyView()
    }
    
    init(message: String) {
        self.message = message
        Log.error(message)
   }
}


