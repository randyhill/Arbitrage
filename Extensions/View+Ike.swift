//
//  View+Ike.swift
//  Ike
//
//  Created by Randy Hill on 1/10/21.
//

import SwiftUI

// Preference Key for redutring sizes
struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func log(_ value: Any) -> Self {
        Log.console(value as! String)
        return self
    }
    
    func debug(_ closure: () -> Void) -> Self {
        #if DEBUG
        closure()
        #endif
        return self
    }

    // Return the size of a view in a preference key
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
            Color.clear
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
