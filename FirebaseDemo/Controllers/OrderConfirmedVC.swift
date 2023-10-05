//
//  OrderConfirmedVC.swift
//  
//
//  Created by student on 24/02/2022.
//

import UIKit

class OrderConfirmedVC: UIViewController {

    @IBOutlet weak var orderConfirmedLabel: UILabel!
//
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true //Hides back button on navigation bar
        // Do any additional setup after loading the view.
    }
    
    //Navigate user back to main screen when done button is triggered
    @IBAction func doneBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
        if let navigator = self.navigationController {
            navigator.pushViewController(mainVC, animated: true)
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
