//
//  CartVC.swift
//  FirebaseDemo
//
//  Created by student on 20/02/2022.
//

import UIKit
import Firebase

class CartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var deliveryFeesLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var cardHolderTF: UITextField!
    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var cardHolderError: UILabel!
    @IBOutlet weak var pinError: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    private var docCount: Int = 0
    private var foorOrdered = [Order]()
    private var docID = [String]()
    private var totalPrice: Float?
    
    //Return number of table view rows according to amount of documents returned by Firestore
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.docCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as? OrderViewCell {
            orderCell.updateCell(foodOrder: foorOrdered[indexPath.row])
            return orderCell
        } else {
            return OrderViewCell()
        }
    }
    
    //Utilize trailing swipe action for order deletion
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let confirmation = UIAlertController(title: "Delete Food", message: "Are you sure you want to delete?", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (action) in
                let selectedFood = self.foorOrdered[indexPath.row] //Get index path of the selected food
                //Delete the Firestore document according to the selected food's document ID
                Firestore.firestore().collection(FOOD_ORDER).document(selectedFood.docID).delete { (error) in
                    if let err = error {
                        let alertDialog = UIAlertController(title: "Error", message: "Error fetching documents: \(err.localizedDescription).", preferredStyle: .alert)
                        alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                        self.present(alertDialog, animated: true)
                    } else {
                        let alertDialog = UIAlertController(title: "Deletion Complete", message: "Food deleted successfully.", preferredStyle: .alert)
                        alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action) in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
                            if let navigator = self.navigationController {
                                navigator.pushViewController(mainVC, animated: true)
                            }
                        }))
                        self.present(alertDialog, animated: true)
                    }
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                confirmation.dismiss(animated: true, completion: nil)
            }
            confirmation.addAction(cancelButton)
            confirmation.addAction(yesButton)
            self.present(confirmation, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [swipe])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cardHolderTF.delegate = self
        pinTF.delegate = self
        cartTableView.rowHeight = 125
        loadData()
        generateTotalPrice()
        // Do any additional setup after loading the view.
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pinTF {
            if (pinTF.text?.isEmpty == true) {
                pinError.isHidden = false
                pinTF.text = "Text field should not be left empty."
            } else {
                pinTF.isHidden = true
            }
        }
        
        if textField == cardHolderTF {
            if (cardHolderTF.text?.isEmpty == true) {
                cardHolderError.isHidden = false
                cardHolderError.text = "Text field should not be left empty."
            } else {
                cardHolderError.isHidden = true
            }
        }
        
    }
    
    func loadCardDetails(totalPrice: Float) {
        if (Auth.auth().currentUser != nil && totalPrice != 0.0) {
            pinTF.isHidden = false
            cardHolderTF.isHidden = false
            confirmBtn.isHidden = false
        }
    }
    func generateTotalPrice() {
        var totalPrice: Float = 0.0
        if (Auth.auth().currentUser != nil) {
            let userID = Auth.auth().currentUser?.uid //Get the logged in user's ID from Firebase
            //Return documents where payment status field equals to false and user ID field equals to the current signed in user's ID
            Firestore.firestore().collection(FOOD_ORDER).whereField(PAYMENT_STATUS, isEqualTo: false).whereField(USER_ID, isEqualTo: userID!).getDocuments { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    let alertDialog = UIAlertController(title: "Error", message: "Error fetching document: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                    self.present(alertDialog, animated: true)
                    return
                }
                for document in snapshot.documents { //Loop through all the documents returned one by one
                    let data = document.data()
                    let foodPrice = Float(data[PRICE] as? String ?? "")! //Get food price from document
                    totalPrice = totalPrice + foodPrice //Accumulate the food price
                }
                if (totalPrice != 0.0) {
                    totalPrice = totalPrice + 5.0
                    self.grandTotalLabel?.text = "\(totalPrice)" //Display food price text
                    self.loadCardDetails(totalPrice: totalPrice)
                }
            }
        }
    }
    
    @IBAction func confirmBTN(_ sender: BorderButton) {
        //Check if any text fields left empty, if yes, display dialog box to notify user
        if (Auth.auth().currentUser != nil) {
            if (pinTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cardHolderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" )  {
                let alertDialog = UIAlertController(title: "Input Required", message: "Text field(s) should not be left empty.", preferredStyle: .alert)
                alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                self.present(alertDialog, animated: true)
            } else {
                //Else, set all the payment status from returned documents to true
                for ID in self.docID {
                    Firestore.firestore().collection(FOOD_ORDER).document(ID).updateData([PAYMENT_STATUS : true])
                }
                cartTableView.reloadData()
            }
        } else {
            let alertDialog = UIAlertController(title: "Error", message: "Please login before placing order.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        }
    }
    
    func loadData() {
        let user = Auth.auth().currentUser
        let userID = user?.uid
        if (user != nil) {
            Firestore.firestore().collection(FOOD_ORDER).whereField(USER_ID, isEqualTo: userID!).whereField(PAYMENT_STATUS, isEqualTo: false).getDocuments { (snapshot, error) in
                if (error != nil) {
                    let alertDialog = UIAlertController(title: "Error", message: "Error fetching documents: \(String(describing: error?.localizedDescription)).", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                    self.present(alertDialog, animated: true)
                } else if (error == nil && snapshot != nil) { //If there is no error fetching documents
                    for document in snapshot!.documents {
                        self.docCount = (snapshot?.documents.count)! //Count the total number of documents returned
                        self.foorOrdered = Order.parseData(snapshot: snapshot) //Get the returned order from parseData function
                        self.docID.append(document.documentID)
                        self.deliveryFeesLabel.text = "5.00"
                    }
                }
                self.cartTableView.reloadData() //Request table view to refresh
            }
        }
    }
}
