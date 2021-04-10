//
//  UIColor.swift
//  Ike
//
//  Created by Randy Hill on 11/27/20.
//

import UIKit

extension UIColor {
	private convenience init?(hex: String, alpha: CGFloat = 1.0) {
		guard hex.count == 7 else {
			Log.error("Color hex string: \(hex), is wrong length should be seven chars")
			return nil
		}
		guard hex.hasPrefix("#") else {
			Log.error("Color hex string: \(hex), missing # prefix")
			return nil
		}
		// Make it a 8 byte number even thought we do alpha separately.
		let hexColor = hex.substring(start: 1, end: 7) + "00"
		Log.assert(hexColor.count == 8, "Color hex string: \(hex), is wrong length should be seven chars")
		let scanner = Scanner(string: hexColor)
		var hexNumber: UInt64 = 0

		guard scanner.scanHexInt64(&hexNumber) else  {
			Log.error("Hex color string: \(hex), does not contain all hex values")
			return nil
		}
		let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
		let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
		let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255

		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
	
	// Static vars are implicty lazy
	public static var navy: UIColor = { return UIColor(hex: "#001f3f")! }()
	public static var coolBlue: UIColor = { return UIColor(hex: "#0074D9")! }()
	public static var aqua: UIColor = { return UIColor(hex: "#7FDBFF")! }()
	public static var teal: UIColor = { return UIColor(hex: "#39CCCC")! }()
	public static var olive: UIColor = { return UIColor(hex: "#3D9970")! }()
	public static var coolGreen: UIColor = { return UIColor(hex: "#2ECC40")! }()
	public static var lime: UIColor = { return UIColor(hex: "#01FF70")! }()
	public static var coolYellow: UIColor = { return UIColor(hex: "#FFDC00")! }()
	public static var coolOrange: UIColor = { return UIColor(hex: "#FF851B")! }()
	public static var coolRed: UIColor = { return UIColor(hex: "#FF4136")! }()
	public static var maroon: UIColor = { return UIColor(hex: "#85144b")! }()
	public static var fuchsia: UIColor = { return UIColor(hex: "#F012BE")! }()
	public static var coolPurple: UIColor = { return UIColor(hex: "#B10DC9")! }()
	public static var coolBlack: UIColor = { return UIColor(hex: "#111111")! }()
	public static var coolGray: UIColor = { return UIColor(hex: "#AAAAAA")! }()
	public static var silver: UIColor = { return UIColor(hex: "#DDDDDD")! }()
}
