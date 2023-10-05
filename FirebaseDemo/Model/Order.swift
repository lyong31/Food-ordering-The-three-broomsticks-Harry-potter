//
//  Order.swift
//  FirebaseDemo
//
//  Created by student on 21/02/2022.
//

import Foundation
import Firebase

class Order {
    private(set) var foodName: String!
    private(set) var foodQuantity: Int!
    private(set) var foodPrice: Float!
    private(set) var docID: String!
    private(set) var orderDate: Date!
    
    init(foodName: String, foodQuantity: Int, foodPrice: Float, docID: String, orderDate: Date) {
        self.foodName = foodName
        self.foodPrice = foodPrice
        self.foodQuantity = foodQuantity
        self.docID = docID
        self.orderDate = orderDate
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Order] {
    
        var orders = [Order]()
        var totalPrice: Float = 0.0
        
        guard let querySnapshot = snapshot else { return orders }
        for document in querySnapshot.documents {
            let data = document.data()
            
            let foodName = data[SELECTED_FOOD] as? String ?? "Food"
            let foodQuantity = data[QUANTITY] as? Int ?? 0
            let foodPrice = Float(data[PRICE] as? String ?? "")!
            let docID = document.documentID
            let timestamp = data[TIMESTAMP] as? Timestamp ?? nil
            let date = timestamp?.dateValue() ?? Date()
            
            let foodOrder = Order(foodName: foodName, foodQuantity: foodQuantity, foodPrice: foodPrice, docID: docID, orderDate: date)
            
            orders.append(foodOrder)
            totalPrice = totalPrice + Float(foodPrice)
        }
        return orders
    }
}
