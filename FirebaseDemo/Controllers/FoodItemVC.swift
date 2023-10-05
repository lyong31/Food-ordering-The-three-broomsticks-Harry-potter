//
//  FoodItemVC.swift
//  FirebaseDemo
//
//  Created by student on 20/02/2022.
//

import UIKit
import Firebase
import Foundation

class FoodItemVC: UIViewController {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var foodDesc: UITextView!
    @IBOutlet weak var steper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var sendViaSegueObject:FoodList?
    var getFoodImageName = String()
    private var formatter = NumberFormatter()
    private var formattedTotalPrice: String?
    private var quantity: Int = 0
    private var totalPrice: Float = 0.0
    private var cashOnDelivery: Bool = true
    
    
    @IBAction func addBtn(_ sender: BorderButton) {
        //Create animation when user triggers add button
        UIButton.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseIn, animations: {sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)}, completion: {finish in UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 1, y: 1)})})
        //Don't allow user to add order if not login
        if (Auth.auth().currentUser == nil) {
            let alertDialog = UIAlertController(title: "Error", message: "Please login before adding food to cart.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                self.present(loginVC, animated: true, completion: nil)
            }))
            self.present(alertDialog, animated: true)
        } else {
            let user = Auth.auth().currentUser
            //Only allow food order to be added if the quantity selected not equals to 0
            if (self.quantity != 0) {
                guard let userID = user?.uid else { return }
                Firestore.firestore().collection(FOOD_ORDER).document().setData([USER_ID : userID, SELECTED_FOOD : self.foodNameLabel.text!, QUANTITY : self.quantity, PRICE : self.formattedTotalPrice!, PAYMENT_STATUS : false, TIMESTAMP : FieldValue.serverTimestamp()]) //Add food order to Firestore
                let alertDialog = UIAlertController(title: "Added To Cart", message: "\(self.foodNameLabel.text ?? "Food") had been added to cart successfully!", preferredStyle: .alert)
                alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                self.present(alertDialog, animated: true)
            } else {
                let alertDialog = UIAlertController(title: "Error", message: "Please select food quantity before adding it to cart.", preferredStyle: .alert)
                alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                self.present(alertDialog, animated: true)
            }
        }
    }
    
    //Stepper is used to control the increment or decrement of food orders    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        //Display the quantity label text according to stepper increment or decrement
        quantityLabel.text = Int(sender.value).description
        self.quantity = Int(sender.value)
        self.totalPrice = Float(priceLabel.text!)! * Float(self.quantity) //Generate price of food selected according to the quantity
        self.formatter.maximumFractionDigits = 2 //Set float decimals to 2
        self.formatter.minimumFractionDigits = 2
        self.formattedTotalPrice = formatter.string(for: self.totalPrice) //Format total price to string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodNameLabel.text = sendViaSegueObject?.foodName
        self.priceLabel.text = sendViaSegueObject?.foodPrice
        self.foodImage.image = UIImage(named: getFoodImageName)
        self.foodDesc.text = sendViaSegueObject?.foodDesc
        // Do any additional setup after loading the view.
    }

}

