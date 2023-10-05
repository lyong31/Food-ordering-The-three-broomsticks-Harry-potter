//
//  FoodClassificationTableView.swift
//  FirebaseDemo
//
//  Created by student on 21/02/2022.
//

import UIKit

class FoodClassificationViewCell: UITableViewCell {

    @IBOutlet weak var foodLabel: UILabel!
   
    @IBOutlet weak var foodImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func updateView(Classification: FoodClassification) {
        foodImage.image = UIImage(named: Classification.foodImage)
        foodLabel.text = Classification.foodType
    }

}
