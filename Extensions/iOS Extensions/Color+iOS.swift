//
//  Color+iOS.swift
//  Ike
//
//  Created by Randy Hill on 2/7/21.
//

import SwiftUI

extension Color {
    public static var opaqueSeparator: Color { return Color(UIColor.opaqueSeparator) }
    public static var systemFill: Color { return Color(UIColor.systemFill) }
    public static var systemBackground: Color { return Color(UIColor.systemBackground) }
    public static var secondarySystemBackground: Color { return Color(UIColor.secondarySystemBackground) }
    public static var placeholderText: Color { return Color(UIColor.placeholderText) }
}

struct CodableColor : Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var color: Color {
        return Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    init(_ color: Color) {
        let uiColor = UIColor(color)
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
