//
//  FoodClassification.swift
//  FirebaseDemo
//
//  Created by student on 21/02/2022.
//

import Foundation

struct FoodClassification {
    private(set) public var foodType: String
    private(set) public var foodImage: String
    
    init(foodType: String, foodImage: String) {
        self.foodType = foodType
        self.foodImage = foodImage
    }
}
