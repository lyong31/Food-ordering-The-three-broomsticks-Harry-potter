//
//  MyOrdersViewCellTableViewCell.swift
//  FirebaseDemo
//
//  Created by student on 22/02/2022.
//

import UIKit

class MyOrdersViewCell: UITableViewCell {
    
    
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodQuantityLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    
    private var myOrders: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(myOrders: Order) {
        self.myOrders = myOrders
        self.foodNameLabel.text = "Food: \(myOrders.foodName ?? "")"
        self.foodQuantityLabel.text = "Quantity: \(String(myOrders.foodQuantity))"
        self.foodPriceLabel.text = "Price: RM\(String(myOrders.foodPrice))"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: myOrders.orderDate)
        self.orderDateLabel.text = "Date Ordered: \(timestamp)"
    }
    
}
