//
//  FeedbackVC.swift
//  FirebaseDemo
//
//  Created by student on 21/02/2022.
//

import UIKit
import Firebase
import Cosmos

class FeedbackVC: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var feedbackError: UILabel!
    @IBOutlet weak var feedbackTV: UITextView!
    @IBOutlet weak var starRatings: CosmosView!
    
    private var handler: AuthStateDidChangeListenerHandle?
    private var pickerContent = ["Food Quality", "Order Accuracy", "Delivery Speed", "Application Experience", "Others"] //Data presented in picker view
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedbackTV.layer.borderWidth = 1
        self.feedbackTV.layer.borderColor = UIColor.black.cgColor //Create border to feedback text view
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.setValue(UIColor.orange, forKey: "textColor") //Set text colors for picker view selections
        feedbackTV.textColor = UIColor.lightGray
        feedbackTV.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //Only allow logged in users to provide feedback
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if (user == nil) {
            let alertDialog = UIAlertController(title: "Error", message: "Please login before providing feedback.", preferredStyle: .alert)
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
    
    //Define the number of columns of the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Define the number of rows of the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerContent.count
    }
    
    //Pass data contained in the pickerContent by row to the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerContent[row]
    }
    
    func textViewDidBeginEditing(_ feedbackTV: UITextView) {
        if feedbackTV.textColor == UIColor.lightGray {
            feedbackTV.text = nil
            feedbackTV.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if feedbackTV.text.isEmpty == true {
            feedbackError.isHidden = false
            feedbackError.text = "Text field should not be left empty."
        } else {
            feedbackError.isHidden = true
        }
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        //Get the user selected category of feedback
        var ratings: Double = 0.0
        let selectedCategory = self.pickerContent[categoryPicker.selectedRow(inComponent: 0)] //Get the selected feedback category from picker view
        if (feedbackTV.text.isEmpty != true) {
            self.starRatings.didTouchCosmos = {rating in
                ratings = rating //Get the star ratings
            }
            let user = Auth.auth().currentUser
            guard let userID = user?.uid else { return }
            Firestore.firestore().collection(FEEDBACK).addDocument(data: [FEEDBACK_CATEGORY : selectedCategory, RATING : ratings, COMMENT : self.feedbackTV.text!, USER_ID : userID, USER_NAME : user?.displayName! as Any]) //Add feedback data to Firebase
            let alertDialog = UIAlertController(title: "Feedback Submitted", message: "Thank you so much for providing feedback. We appreciate it and will try our best to improve.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        } else if (feedbackTV.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            let alertDialog = UIAlertController(title: "Input Required", message: "Text field should not be left empty.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
