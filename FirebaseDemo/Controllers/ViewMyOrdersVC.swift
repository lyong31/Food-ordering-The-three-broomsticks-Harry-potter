//
//  ViewMyOrdersVC.swift
//  FirebaseDemo
//
//  Created by student on 01/03/2022.
//

import UIKit
import Firebase

class ViewMyOrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myOrdersTableView: UITableView!
    private var docCount: Int = 0
    private var myOrders = [Order]()
    
    //Return table view cell rows according to the number of documents returned
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.docCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myOrdersCell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersViewCell", for: indexPath) as? MyOrdersViewCell {
            myOrdersCell.updateCell(myOrders: myOrders[indexPath.row])
            return myOrdersCell
        } else {
            return OrderViewCell()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myOrdersTableView.delegate = self
        myOrdersTableView.dataSource = self
        myOrdersTableView.rowHeight = 160
        loadData()
        // Do any additional setup after loading the view.
    }
    
    //Display returned data from Firestore
    func loadData() {
        let user = Auth.auth().currentUser
        let userID = user?.uid
        if (user != nil) {
            Firestore.firestore().collection(FOOD_ORDER).whereField(USER_ID, isEqualTo: userID!).whereField(PAYMENT_STATUS, isEqualTo: true).getDocuments { (snapshot, error) in
                if (error != nil) {
                    let alertDialog = UIAlertController(title: "Error", message: "Error fetching documents: \(String(describing: error?.localizedDescription)).", preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
                    self.present(alertDialog, animated: true)
                } else if (error == nil && snapshot != nil) {
                    for _ in snapshot!.documents {
                        self.docCount = (snapshot?.documents.count)!
                        self.myOrders = Order.parseData(snapshot: snapshot)
                    }
                }
                self.myOrdersTableView.reloadData()
            }
        } else {
            let alertDialog = UIAlertController(title: "Error", message: "Please login before viewing past orders.", preferredStyle: .alert)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
