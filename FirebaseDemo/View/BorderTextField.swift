//
//  BorderTextField.swift
//  FirebaseDemo
//
//  Created by student on 22/02/2022.
//

import UIKit

class BorderTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
    }
    
    
}
