//
//  Extension TextField.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import UIKit

extension UITextField {
    func applyForCreateTask(_ placeHolder: String, _ keyboard: UIKeyboardType) {
        self.placeholder = placeHolder
        self.layer.borderWidth = 1
        self.font = UIFont.systemFont(ofSize: 20)
        self.textAlignment = .center
        self.keyboardType = keyboard
    }
}
