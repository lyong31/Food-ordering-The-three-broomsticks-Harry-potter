//
//  FoodList.swift
//  FirebaseDemo
//
//  Created by student on 21/02/2022.
//

import Foundation

struct FoodList {
    private(set) public var foodName: String
    private(set) public var foodPrice: String
    private(set) public var priceSign: String
    private(set) public var foodImage: String
    private(set) public var foodDesc: String
    
    init(foodName: String, foodPrice: String, priceSign: String, foodImage: String, foodDesc: String) {
        self.foodName = foodName
        self.foodPrice = foodPrice
        self.priceSign = priceSign
        self.foodImage = foodImage
        self.foodDesc = foodDesc
    }
}
