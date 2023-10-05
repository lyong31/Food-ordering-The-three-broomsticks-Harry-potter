    import UIKit
    import Firebase

    class LoginVC: UIViewController, UITextFieldDelegate {
        
        
        @IBOutlet weak var emailTF: UITextField!
        @IBOutlet weak var emailError: UILabel!
        @IBOutlet weak var passwordTF: UITextField!
        @IBOutlet weak var passwordError: UILabel!
        
        override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTF {
            if(passwordTF.text?.isEmpty == false) {
                let password = passwordTF.text as NSString?
                if (password!.length < 6) {
                    passwordError.isHidden = false
                    passwordError.text = "Password length should not be shorter than 6 charcters."
                } else {
                    passwordError.isHidden = true
                }
            } else {
                passwordError.isHidden = false
                passwordError.text = "Text field should not be left empty."
            }
        }
            
        if textField == emailTF {
            if (emailTF.text?.isEmpty == true) {
                emailError.isHidden = false
                emailError.text = "Text field should not be left empty."
            } else {
                emailError.isHidden = true
            }
        }
    }
    
    @IBAction func loginBtn(_ sender: BorderButton) {
        //Validate if user input is empty
        if (emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            //Display a dialog box to alert user if text fields left empty
            let alertDialog = UIAlertController(title: "Input Required", message: "Username or password should not be left empty. Please re-enter your credentials.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        } else {
            //validate user input
            guard let email = emailTF.text,
                  let password = passwordTF.text else {return}
            
            //Firebase authentication to check user login credentials
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                //If error exists, dialog box is displayed to notify user
                if let error = error {
                    let alertDialog = UIAlertController(title: "Error", message: "Cannot sign in: \(error).", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                    self.present(alertDialog, animated: true)
                } else {
                    let alertDialog = UIAlertController(title: "Login Successful", message: "Welcome to The Three Broomsticks. Delicious foods for witch and wizards.", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                    self.present(alertDialog, animated: true)
                }
            }
        }
    }
}

