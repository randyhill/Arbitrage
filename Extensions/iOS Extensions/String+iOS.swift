//
//  String+iOS.swift
//  Ike
//
//  Created by Randy Hill on 2/7/21.
//

import Foundation

extension String {
    var pathFileName: String? {
        let url = URL(string: self)
        return url?.pathComponents.last
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    var integerValue: Int {
        return (self as NSString).integerValue
    }

    var range: Range<String.Index> {
        return self.startIndex..<self.endIndex
    }
    
    var nsRange: NSRange {
        return NSRange(self.range, in: self)
    }
     
    func append(pathComponent: String) -> String {
         let pathHasLeadingForwardSlash: Bool = pathComponent.hasPrefix("/")
         if self.hasSuffix("/") {
             if pathHasLeadingForwardSlash {
                 let trimmedSelf: String = self.substring(end: self.count - 1)
                 return [trimmedSelf, pathComponent].joined()
             }
             return [self, pathComponent].joined()
         }
         if pathHasLeadingForwardSlash {
             return [self, pathComponent].joined()
         }
         let parts: [String] = [self, pathComponent]
         return parts.joined(separator: "/")
     }

    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
     
    func split(character: String = " ") -> [String] {
        Log.assert(character.count > 0, "the character you supplied is invalid")
        return (self as NSString).components(separatedBy: character)
    }

    func substring(start: Int = 0, end: Int) -> String {
        Log.assert(start <= end, "Start and end are invalid")
        Log.assert(self.count >= end, "String length should be >= your end index")
        Log.assert(start >= 0, "Start shouldn't be negative")
        return (self as NSString).substring(with: NSRange(location: start, length: end - start))
     }

     func substring(start: Int = 0, length: Int) -> String {
        Log.assert(length >= 0, "Length should be positive")
        Log.assert(self.count >= length, "String length should be >= your length")
        Log.assert(start >= 0, "Start shouldn't be negative")
        Log.assert(length + start <= self.count, "Length + start is longer than the string, index out of bounds")
        return (self as NSString).substring(with: NSRange(location: start, length: length))
     }
}
