//
//  Color+Ike.swift
//  Ike
//
//  Created by Randy Hill on 2/7/21.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // Static vars are implicty lazy
    public static var navy: Color = { return Color(hex: "#001f3f")}()
    public static var coolBlue: Color = { return Color(hex: "#0074D9")}()
    public static var aqua: Color = { return Color(hex: "#7FDBFF")}()
    public static var teal: Color = { return Color(hex: "#39CCCC")}()
    public static var olive: Color = { return Color(hex: "#3D9970")}()
    public static var coolGreen: Color = { return Color(hex: "#2ECC40")}()
    public static var lime: Color = { return Color(hex: "#01FF70")}()
    public static var coolYellow: Color = { return Color(hex: "#FFDC00")}()
    public static var coolOrange: Color = { return Color(hex: "#FF851B")}()
    public static var coolRed: Color = { return Color(hex: "#FF4136")}()
    public static var maroon: Color = { return Color(hex: "#85144b")}()
    public static var fuchsia: Color = { return Color(hex: "#F012BE")}()
    public static var coolPurple: Color = { return Color(hex: "#B10DC9")}()
    public static var coolBlack: Color = { return Color(hex: "#111111")}()
    public static var coolGray: Color = { return Color(hex: "#AAAAAA")}()
    public static var silver: Color = { return Color(hex: "#DDDDDD")}()
}
