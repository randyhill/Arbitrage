//
//  Int.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import Foundation

extension Int64 {
	var formatted: String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:self)) ?? "\(self)"
	}
	
	var megabytes: Int64 {
		return self/(1024*1024)
	}
}

extension Int {
	var formatted: String {
        return Int.format(self)
	}
    
    static func format(_ number: Int?) -> String {
        guard let number = number else { return "n/a" }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    static func shortFormat(_ number: Int?) -> String {
        guard let number = number else { return "n/a" }
        let thousand = 1000
        let million = thousand * thousand
        let billion = million * thousand
        let trillion = billion * thousand
        if number >= trillion {
            return Int.format(number/trillion) + "T"
        }
        if number >= billion {
            return Int.format(number/billion) + "B"
        }
        if number >= million {
            return Int.format(number/million) + "M"
        }
        return Int.format(number)
    }
    
    var shortFormatted: String {
        return Int.shortFormat(self)
    }
}

extension Double {
	var formatted: String {
		if self == Double.greatestFiniteMagnitude { return "Max_Double" }
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:self)) ?? "\(self)"
	}
	
	var truncated: Double {
		return Double(Int(self))
	}
	
	var fraction: Double {
		return self - truncated
	}
}

extension Float {
	var formatted: String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:self)) ?? "\(self)"
	}
	
	var truncated: Float {
		return Float(Int(self))
	}
	
	var fraction: Float {
		return self - truncated
	}
}



