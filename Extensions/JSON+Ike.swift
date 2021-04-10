//
//  JSON+Ike.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import Foundation

typealias JSON = [String: Any]

enum JSONError: Error {
	case missingKey(String)
	case nullValue(String)
	case emptyValue(String)
	case malformedValue(String)
	case badJSON(String)
}

extension JSONError: LocalizedError {
	public var errorDescription: String? {
		switch self {
			case .missingKey(let key):
				return "JSON missing key: \(key)"
			case .nullValue(let key):
				return "JSON null value for key: \(key)"
			case .emptyValue(let key):
				return "JSON empty value for key: \(key)"
			case .malformedValue(let key):
				return "JSON malformed value for key: \(key)"
			case .badJSON:
				return "JSON dictionary was malformed"
		}
	}
}

extension JSON {
	static func makeJSON(_ representation: Any) throws -> JSON {
		guard let json = representation as? JSON else {
			throw JSONError.badJSON("TextTrack JSON incomplete/malformed")
		}
		return json
	}
	
	func getValueFor<R>(key: String) throws -> R  {
		// Handle standard values
		if let value = self[key] as? R {
			if let stringValue = value as? String {
				if stringValue == "<null>" {
					throw JSONError.nullValue(key)
				}
				if stringValue.count == 0 {
					throw JSONError.emptyValue(key)
				}
			}
			return value
		}
		// Handle custom values
		switch R.self {
			case is Date.Type:
				if let dateTimeString = self[key] as? String {
					guard let date = Date.fromInternet(dateTime: dateTimeString) as? R else {
						throw JSONError.malformedValue(key)
					}
					return date
				}
			case is URL.Type:
				if let path = self[key] as? String {
					guard let url = URL(string: path) as? R else {
						throw JSONError.malformedValue(key)
					}
					return url
				}
			default:
				break
		}
		throw JSONError.missingKey(key)
	}
	
	func getDate(key: String) -> Date?  {
		// Handle standard values
		guard let stringValue = self[key] as? String else {
			return nil
		}
		guard let date = Date.fromInternet(dateTime: stringValue) else {
			return nil
		}
		return date
	}
	
	func validString(_ stringValue: String) -> Bool {
		if stringValue == "<null>" {
			return false
		}
		if stringValue.count == 0 {
			return false
		}
		return true
	}
}




