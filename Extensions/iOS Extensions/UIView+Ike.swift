//
//  UIView.swift
//  Ike
//
//  Created by Randy Hill on 1/19/21.
//

import UIKit

extension UIView {
    
    func enclosingScrollView() -> UIScrollView? {
        var next: UIView? = self
        repeat {
            next = next?.superview
            if let scrollview = next as? UIScrollView {
                return scrollview
            }
        } while next != nil
        return nil
    }
    
    func scanSubviews(_ parent: UIView? = nil, depth: Int) {
        let parent = parent ?? self
        for view in parent.subviews {
            switch view {
            case let slider as UISlider:
                print("Depth: \(depth), Slider: \(slider.description)")
            case let button as UIButton:
                print("Depth: \(depth), Button: \(button.description)")
            default:
                print("Depth: \(depth), View: \(String(describing: view))")
            }
            self.scanSubviews(view, depth: depth + 1)
        }
    }
    
    func findTargetInSubviews(_ parent: UIView? = nil, targetClassName: String) -> UIView? {
        let parent = parent ?? self
        for view in parent.subviews {
            let thisType = type(of: view)
            let type = String(describing: thisType)
            switch type {
            case targetClassName:
                return view
             default:
                if let match = findTargetInSubviews(view, targetClassName: targetClassName) {
                    return match
                }
            }
        }
        return nil
   }
    
    func findMatchesInSubviews(_ parent: UIView? = nil, targetClassName: String,  matches: inout [UIView]) {
        let parent = parent ?? self
         for view in parent.subviews {
            let thisType = type(of: view)
            let type = String(describing: thisType)
            switch type {
            case targetClassName:
                matches += [view]
             default:
                findMatchesInSubviews(view, targetClassName: targetClassName, matches: &matches)
            }
        }
    }
}

