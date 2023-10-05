//
//  ProfileVC.swift
//  FirebaseDemo
//
//  Created by student on 20/02/2022.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var contactNoTF: UITextField!
    @IBOutlet weak var addressTV: UITextView!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var editBtn: BorderButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deliveryAddrLabel.clipsToBounds = true
        addressTV.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    //Enable text fields for user to update account profile
    @IBAction func editBarBtn(_ sender: UIBarButtonItem) {
        contactNoTF.backgroundColor = UIColor.white
        addressTV.backgroundColor = UIColor.white
        postalCodeTF.backgroundColor = UIColor.white
        stateTF.backgroundColor = UIColor.white
        contactNoTF.isUserInteractionEnabled = true
        addressTV.isUserInteractionEnabled = true
        postalCodeTF.isUserInteractionEnabled = true
        stateTF.isUserInteractionEnabled = true
        editBtn.isHidden = false
    }
    
    @IBAction func editBtn(_ sender: Any) {
        if (contactNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || addressTV.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || postalCodeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            let alertDialog = UIAlertController(title: "Input Required", message: "Text field(s) should not be left empty.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        } else {
            let contactNo = contactNoTF.text
            let deliveryAddress = addressTV.text
            let postalCode = postalCodeTF.text
            let state = stateTF.text
            let userID = Auth.auth().currentUser?.uid
            Firestore.firestore().collection(USER).document(userID!).updateData([USER_STATE : state ?? "", USER_CONTACT_NO : contactNo ?? "", USER_DELIVERY_ADDR : deliveryAddress ?? "", USER_POSTAL_CODE : postalCode ?? ""]) //Update data in Firestore
            contactNoTF.backgroundColor = UIColor.systemGray5
            addressTV.backgroundColor = UIColor.systemGray5
            postalCodeTF.backgroundColor = UIColor.systemGray5
            stateTF.backgroundColor = UIColor.systemGray5
            contactNoTF.isUserInteractionEnabled = false
            addressTV.isUserInteractionEnabled = false
            postalCodeTF.isUserInteractionEnabled = false
            stateTF.isUserInteractionEnabled = false //Set all the ext fields to disable
            editBtn.isHidden = true //Hide edit button
            let alertDialog = UIAlertController(title: "Profile Updated Successfully", message: "Hooray! Your profile is up to date!", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        }
    }
    
    //Only allow logged in users to access to account profile
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if (user != nil) {
            Firestore.firestore().collection(USER).document(user!.uid).getDocument { (snapshot, error) in
                let data = snapshot?.data()
                let username = data?[USER_NAME] as? String ?? "Muggle"
                let email = user?.email ?? ""
                let contactNo = data?[USER_CONTACT_NO] as? String ?? ""
                let deliveryAddress = data?[USER_DELIVERY_ADDR] as? String ?? ""
                let postalCode = data?[USER_POSTAL_CODE] as? String ?? ""
                let state = data?[USER_STATE] as? String ?? ""
                self.usernameLabel.text = "Nice to see you, \(username)!"
                self.emailTF.text = email
                self.contactNoTF.text = contactNo
                self.addressTV.text = deliveryAddress
                self.postalCodeTF.text = postalCode
                self.stateTF.text = state
            }
        } else {
            let alertDialog = UIAlertController(title: "Error", message: "Please login before viewing account profile.", preferredStyle: .alert)
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
