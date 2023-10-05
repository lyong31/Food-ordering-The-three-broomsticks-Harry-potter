//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Macintosh on 16/02/2022.
//
import Foundation
import UIKit
import Firebase

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //link UILabel from storyboard
    @IBOutlet weak var greetingsLabel: UILabel!
    //Create handler to detect user state's changes
    private var handler: AuthStateDidChangeListenerHandle?
    
    //Link Food Classfication table view
    @IBOutlet weak var FoodClassificationTableView: UITableView!
    //link side menu view
    @IBOutlet weak var sideMenuView: UIView!
    private var sideMenuIsVisible = false
    
    @IBAction func signOutBtn(_ sender: Any) {
    
    let authentication = Auth.auth()
    let user = Auth.auth().currentUser
    //Try to signout using Firebase, if fails, a dialog box will be displayed to notify user
     if (user != nil) {
        do {
            try authentication.signOut()
            let alertDialog = UIAlertController(title: "Logout Successfully", message: "We weill be waiting for you to come back soon.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        } catch {
            let alertDialog = UIAlertController(title: "Error", message: "Error signing out.", preferredStyle: .alert)
            alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
            self.present(alertDialog, animated: true)
        }
    } else {
        let alertDialog = UIAlertController(title: "Error", message: "User not logged in, unable to perform sign out action.", preferredStyle: .alert)
        alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        self.present(alertDialog, animated: true)
    }
  }
    
   
    @IBAction func sideMenuView(_ sender: Any) {
    //Display the side menu with transition when user clicks menu button
    if !sideMenuIsVisible {
        DispatchQueue.main.async {
            self.sideMenuView.isHidden = false
            UIView.transition(with: self.sideMenuView, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: {_ in})
        }
        self.sideMenuIsVisible = true
    } else { //Close the side menu with transition
        DispatchQueue.main.async {
            self.sideMenuView.isHidden = true
            UIView.transition(with: self.sideMenuView, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: {_ in})
        }
        self.sideMenuIsVisible = false
    }
}
    //Override method to check user login state whenever user is about to enter this view
    override func viewWillAppear(_ animated: Bool) {
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            //If user does not login, present login screen
            if user == nil {
                self.greetingsLabel.text = "Muggles are not alowed here!!!"
            } else {
                guard let userID = user?.uid else { return }
                Firestore.firestore().collection(USER).document(userID)
                    .getDocument { (snapshot, error) in
                    let data = snapshot?.data()
                    let username = data?[USER_NAME] as? String ?? "Anonymous"
                    self.greetingsLabel.text = "Welcome,\(username)!"
                }
            }
        })
    }
    //Provide back function from MenuVC to FoodClassificationVC
    @IBAction func unwindToFoodClassficationVC(_ unwindSegue: UIStoryboardSegue) {
        }
    
    //Determine number of rows displayed in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //Let system decides whether to reuse table view cells
        if let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodClassificationViewCell") as? FoodClassificationViewCell {
            let classification = DataSource.instance.getFoodClassification()[indexPath.row]
            foodCell.updateView(Classification: classification)
            return foodCell
        } else {
        return FoodClassificationViewCell()
        }
    }
    
    //Link to related view controller when user click on a table view cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let classification = DataSource.instance.getFoodClassification()[indexPath.row]
        self.performSegue(withIdentifier: "MenuVC", sender: classification)
    }
    //Prepare to perform segue action to navigate to MenuVC scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let menuVC = segue.destination as? MenuVC {
            let backButton = UIBarButtonItem()
            backButton.title = "Back" //Set the back button's title to "Back"
            navigationItem.backBarButtonItem = backButton
            assert(sender as? FoodClassification != nil)
            menuVC.initFood(classification: sender as! FoodClassification)
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        FoodClassificationTableView.dataSource = self
        FoodClassificationTableView.delegate = self
        sideMenuView.isHidden = true
    }
    

}


    
