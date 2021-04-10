//
//  Date.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import Foundation

extension Date {
	static let todayTitle = "Today"
    static let yesterdayTitle = "Yesterday"
    static let tomorrowTitle = "Tomorrow"

	// Return simple Year, Month, Day string, or Today/Yesterday depending upon date.
	var dayTitle: String {
		let today = Date().toYearMonthDay()
		let sectionDateString = self.toYearMonthDay()
		if today == sectionDateString {
			return Date.todayTitle
		 }
        let yesterday = Date().add(days: -1).toYearMonthDay()
        if yesterday == sectionDateString {
           return Date.yesterdayTitle
        }
        let tomorrow = Date().add(days: 1).toYearMonthDay()
        if tomorrow == sectionDateString {
           return Date.tomorrowTitle
        }
        return self.toShortMonthDayYearNumeric()
	}

	// Return simple Year, Month, Day string, or Today's/Yesterday's depending upon date.
	var dayTitlePossessive: String {
		let today = Date().toYearMonthDay()
		let sectionDateString = self.toYearMonthDay()
		if today == sectionDateString {
			 return Date.todayTitle + "'s"
		 }
		 let yesterday = Date().add(days: -1).toYearMonthDay()
		 if yesterday == sectionDateString {
			 return Date.yesterdayTitle + "'s"
		 }
		 return self.toShortMonthDayYearNumeric()
	}
    
    var year: Int {
        let yearString = self.toYear()
        return Int(yearString) ?? 0
    }
	
	// Convert string to easiest for human to understand time/date.
	//
	// Today: Time only
	// Yesterday: Yesterday + Time
	// Less than a week old: Day of Week + Time
	// Over a week old: Date + Time
    func toUniqueTimeDayOrDate(locale: Locale = Locale(identifier: "en_US")) -> String {
		let minutesLeftInWeek = 7*24*60 - minutesToMidnight
		var dateTitle = dayTitle
		switch dateTitle {
		case Date.todayTitle:
			dateTitle = " at "
		case Date.yesterdayTitle:
			dateTitle = Date.yesterdayTitle + " at "
		default:
			if self < Date().add(minutes: -minutesLeftInWeek) {
				// show date if more than 6 days old (don't want to display
				dateTitle = self.toMonthDayYearNumeric(locale: locale) + " at "
			} else {
				// show day of week
				dateTitle = self.toDayOfWeek(locale: locale) + " at "
			}
		}
        return dateTitle + toTimeAMPM(locale: locale)
    }
    
    // Human readable dates
    // Yesterday, today, tomorrow, or day of week if in next week.
    // Otherwise month, day year
    func toFullUniqueDate(locale: Locale = Locale(identifier: "en_US")) -> String {
        let theDayTitle = dayTitle
        switch theDayTitle {
        case Date.todayTitle, Date.yesterdayTitle, Date.tomorrowTitle :
            return theDayTitle
        default:
            let minutesLeftInWeek = 7*24*60 + minutesToMidnight
            let minutesToPreviousWeek = 7*24*60 - minutesToMidnight
            let dayOfWeek = self.toDayOfWeek(locale: locale)
            let now = Date()
            let oneWeekAgo = now.add(minutes: -minutesToPreviousWeek)
            let oneWeekFromNow = now.add(minutes: +minutesLeftInWeek)

            if self > oneWeekAgo && self < oneWeekFromNow {
                return dayOfWeek
            }
            if now.year == self.year {
                return dayOfWeek + ", " + self.toFullMonthDay(locale: locale)
            }
            return dayOfWeek + ", " + self.toFullMonthDayYear(locale: locale)
        }
     }
    
	func toMonthDayYearNumeric(locale: Locale = Locale(identifier: "en_US")) -> String {
		return self.to(dateFormat: "MM/dd/yy", locale: locale)
	}
	
	func toShortMonthDayYearNumeric(locale: Locale = Locale(identifier: "en_US")) -> String {
		return self.to(dateFormat: "M/d/yy", locale: locale)
	 }
	
	func toDayOfWeek(locale: Locale = Locale(identifier: "en_US")) -> String {
		return self.to(dateFormat: "EEEE", locale: locale).capitalized(with: locale)
	}

	func toTimeAMPM(locale: Locale = Locale(identifier: "en_US")) -> String {
		return self.to(dateFormat: "h:mm a", locale: locale)
	}
    
    func toYearMonthDay(locale: Locale = Locale(identifier: "en_US")) -> String {
        return self.to(dateFormat: "yyyy-MM-d", locale: locale)
    }
    
    func toFullMonthDay(locale: Locale = Locale(identifier: "en_US")) -> String {
        return self.to(dateFormat: "MMMM d", locale: locale)
    }
    
    func toFullMonthDayYear(locale: Locale = Locale(identifier: "en_US")) -> String {
        return self.to(dateFormat: "MMMM d, yyyy", locale: locale)
    }

    func toYear(locale: Locale = Locale(identifier: "en_US")) -> String {
        return self.to(dateFormat: "yyyy", locale: locale)
    }

	func add(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> Date {
		let calendar: Calendar = Calendar.current
		let version: Double = floor(NSFoundationVersionNumber)

		if version <= NSFoundationVersionNumber10_9_2 {
			var component: DateComponents = DateComponents()
			component.setValue(seconds, for: Calendar.Component.second)

			var date: Date! = calendar.date(byAdding: component, to: self)!
			component = DateComponents()
			component.setValue(minutes, for: Calendar.Component.minute)
			date = calendar.date(byAdding: component, to: self)

			component = DateComponents()
			component.setValue(hours, for: Calendar.Component.hour)
			date = calendar.date(byAdding: component, to: self)

			component = DateComponents()
			component.setValue(days, for: Calendar.Component.day)
			date = calendar.date(byAdding: component, to: self)

			component = DateComponents()
			component.setValue(weeks, for: Calendar.Component.weekOfMonth)
			date = calendar.date(byAdding: component, to: self)

			component = DateComponents()
			component.setValue(months, for: Calendar.Component.month)
			date = calendar.date(byAdding: component, to: self)

			component = DateComponents()
			component.setValue(years, for: Calendar.Component.year)
			date = calendar.date(byAdding: component, to: self)
			return date
		}

		var date: Date! = calendar.date(byAdding: Calendar.Component.second, value: seconds, to: self)!
		date = calendar.date(byAdding: Calendar.Component.minute, value: minutes, to: date)!
		date = calendar.date(byAdding: Calendar.Component.day, value: days, to: date)!
		date = calendar.date(byAdding: Calendar.Component.hour, value: hours, to: date)!
		date = calendar.date(byAdding: Calendar.Component.weekOfMonth, value: weeks, to: date)!
		date = calendar.date(byAdding: Calendar.Component.month, value: months, to: date)!
		date = calendar.date(byAdding: Calendar.Component.year, value: years, to: date)!
		return date
	}
	
	var minutesToMidnight: Int {
		let calendar = NSCalendar.current
		guard let noonishTomorow = calendar.date(bySetting: Calendar.Component.hour, value: 12, of: Date()) else {
			return 0
		}
		let midnight = calendar.startOfDay(for: noonishTomorow)
		let components = calendar.dateComponents([.hour, .minute], from: Date(), to: midnight)
		var hoursUntilMidnight = components.hour ?? 0
		var minutesLeftInHour = components.minute ?? 0
			if minutesLeftInHour < 0 {
			minutesLeftInHour += 60
			hoursUntilMidnight -= 1
		}
		if hoursUntilMidnight < 0 {
			hoursUntilMidnight += 24
		}
		return hoursUntilMidnight * 60 + minutesLeftInHour
	}
	
	// If date hasn't been created yet, returns max time distance 
	func minutesSince(_ date: Date?) -> TimeInterval {
		guard let date = date else {
			return Double.greatestFiniteMagnitude
		}
		return self.timeIntervalSince(date)/Double(60)
	}
	
	static func fromFormat(_ date: String?, format: String, locale: Locale = Locale(identifier: "en_US")) -> Date? {
		if let date = date {
			let dateFormatter: DateFormatter = DateFormatter()
			dateFormatter.locale = locale
			dateFormatter.dateFormat = format
			return dateFormatter.date(from: date)
		}
		return nil
	}
	
	func to(dateFormat format: String, locale: Locale = Locale(identifier: "en_US")) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.locale = locale
		formatter.dateFormat = format
		let dateString = formatter.string(from: self)
        return dateString
	}
	
	static func fromInternet(date: String?, locale: Locale = Locale(identifier: "en_US")) -> Date? {
		return Date.fromFormat(date, format: "yyyy-MM-dd", locale: locale)
	}

	static func fromInternet(dateTime: String?, locale: Locale = Locale(identifier: "en_US")) -> Date? {
		return Date.fromFormat(dateTime, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: locale)
	}
	
	static func fromInternetYearMonthDay(_ date: String?, locale: Locale = Locale(identifier: "en_US")) -> Date? {
		return Date.fromFormat(date, format: "yyyy-MM-d", locale: locale)
	}
	
	static func fromOurInternetFriendly(_ date: String?, locale: Locale = Locale(identifier: "en_US")) -> Date? {
		return Date.fromFormat(date, format: "yyyy-MM-dd HH:mm:ss zzz", locale: locale)
	}
    
    static func fromInternetEpoch(_ intDate: Int) -> Date {
        let epochTime = TimeInterval(intDate) / 1000
        let date = Date(timeIntervalSince1970: epochTime)   // "Apr 16, 2015, 2:40 AM"
        return date
    }
	
	func InternetFriendly(locale: Locale = Locale(identifier: "en_US")) -> String {
		return self.to(dateFormat: "yyyy-MM-dd HH:mm:ss zzz", locale: locale)
	}

	func toInternetDateTime(locale: Locale = Locale(identifier: "en_US")) -> String {
		return self.to(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: locale)
	}
}
