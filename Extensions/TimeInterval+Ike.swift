//
//  TimeInterval+Ike.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import Foundation

extension TimeInterval {
	var description: String {
		let days = (self/(60*60*24))
		let hours = days.fraction*24
		let minutes = hours.fraction*60
		let seconds = minutes.fraction*60
		
		var description = [String]()
		if days >= 1 {
			description += ["\(Int(days)) days"]
		}
		if hours >= 1 {
			description += ["\(Int(hours)) hours"]
		}
		if minutes >= 1 {
			description += ["\(Int(minutes)) minutes"]
		}
		if seconds >= 1 {
			description += ["\(Int(seconds)) seconds"]
		}
		return description.joined(separator: ", ")
	}
}
