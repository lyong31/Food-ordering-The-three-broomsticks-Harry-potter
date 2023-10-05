//
//  SignUpVC.swift
//  FirebaseDemo
//
//  Created by student on 20/02/2022.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var contactTF: UITextField!
    
    @IBOutlet weak var postalCodeTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    
    
    @IBOutlet weak var addressTF: UITextField!
    
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        contactTF.delegate = self
        addressTF.delegate = self
        postalCodeTF.delegate = self
        stateTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //Check whether user leaves text fields blank in real time basis
    func textFieldDidEndEditing(_ textField: UITextField) {}

    @IBAction func signUpBtn(_ sender: Any) {
        if(emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contactTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || addressTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || postalCodeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ) {
    //Display a dialog box to alert user that the inputs should not be left empty
    let alertDialog = UIAlertController(title: "Input Required", message: "Text field(s) should not be left empty.", preferredStyle: .alert)
    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
    self.present(alertDialog, animated: true)
} else {
    guard let email = emailTF.text,
          let password = passwordTF.text,
          let username = usernameTF.text,
          let contact = contactTF.text,
          let Address = addressTF.text,
          let postalCode = postalCodeTF.text,
          let state = stateTF.text else {return} //Get user input by setting them as constants
    
    //Create a new user record in Firebase Authentication
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
        if let error = error {
            let alertDialog = UIAlertController(title: "Error", message: "Cannot create user account: \(error.localizedDescription).", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        }
        //Create extra information apart from email and password
        let updateProfile = user?.user.createProfileChangeRequest()
        updateProfile?.displayName = username
        updateProfile?.commitChanges(completion: { (error) in
            if let error = error {
                let alertDialog = UIAlertController(title: "Error", message: "Cannot update: \(error.localizedDescription).", preferredStyle: .alert)
                alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                self.present(alertDialog, animated: true)
            }
        })
        
        guard let userID = user?.user.uid else {return} //Get user ID

        //Add user record data to Firestore
        Firestore.firestore().collection(USER).document(userID).setData([USER_NAME: username,
            USER_CONTACT_NO: contact,
            USER_DELIVERY_ADDR: Address,
            USER_POSTAL_CODE: postalCode,
            USER_STATE: state], completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    let alertDialog = UIAlertController(title: "Sign Up Successful", message: "Welcome to The Three Broomsticks.", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                    self.present(alertDialog, animated: true)
            }
        })
    }
}
}

}
