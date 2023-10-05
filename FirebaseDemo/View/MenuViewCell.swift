//
//  MenuViewCell.swift
//  FirebaseDemo
//
//  Created by student on 22/02/2022.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSignLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    
    func updateViews(food: FoodList) {
        menuLabel.text = food.foodName
        menuImage.image = UIImage(named: food.foodImage)
        priceLabel.text = food.foodPrice
        priceSignLabel.text = food.priceSign
    }
}
