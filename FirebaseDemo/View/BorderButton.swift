//
//  BorderButton.swift
//  FirebaseDemo
//
//  Created by student on 22/02/2022.
//

import UIKit

class BorderButton: UIButton {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }
    
}
