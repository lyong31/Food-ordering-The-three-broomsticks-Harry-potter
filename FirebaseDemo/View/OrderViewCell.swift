//
//  OrderViewCell.swift
//  FirebaseDemo
//
//  Created by student on 22/02/2022.
//

import UIKit

class OrderViewCell: UITableViewCell {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodQuantityLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    private var dateFormatter = DateFormatter()
    private var foodOrder: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(foodOrder: Order) {
        self.foodOrder = foodOrder
        self.foodNameLabel.text = foodOrder.foodName
        self.foodPriceLabel.text = "Price: RM\(String(foodOrder.foodPrice))"
        self.foodQuantityLabel.text = "Quantity: \(String(foodOrder.foodQuantity))"
        dateFormatter.dateFormat = "MMM d, hh:mm"
        let formattedDate = dateFormatter.string(from: foodOrder.orderDate)
        self.orderDateLabel.text = "Order Date: \(formattedDate)"
    }
}
