//
//  UITextView+Ike.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import UIKit

extension UITextView {
	// Add toolbar to keyboard so we can dismiss it.
	func addDoneButton() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: frame.size.width, height: 40.0)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        self.inputAccessoryView = toolbar
	}
	
    @objc func doneButtonAction() {
        self.endEditing(true)
    }
}

