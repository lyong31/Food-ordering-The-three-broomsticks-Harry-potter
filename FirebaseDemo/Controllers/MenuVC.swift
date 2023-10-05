//
//  MenuVC.swift
//  FirebaseDemo
//
//  Created by student on 20/02/2022.
//

import UIKit

class MenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var MenuVC: UICollectionView!
    private var selectedIndexPath: IndexPath?
    private(set) public var food = [FoodList]()
    private var selectedFood: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuVC.delegate = self
        MenuVC.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func initFood(classification: FoodClassification) {
        food = DataSource.instance.getFood(forFoodType: classification.foodType)
        navigationItem.title = classification.foodType
    }
    
    //Return number of table view row sections
    //Grandmama is providing 4 categories of food, hence row numbers will be 4
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Let system decides whether to reuse table view cells
        if let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuVC", for: indexPath) as? MenuViewCell {
            let menu = food[indexPath.row]
            menuCell.updateViews(food: menu) //Call updateViews function to display texts
            return menuCell
        } else {
        return MenuViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "FoodItemVC") as? FoodItemVC //Initiate the next controller
        destinationVC?.sendViaSegueObject = food[indexPath.item] //Pass selected food's details to the next view controller
        destinationVC?.getFoodImageName = food[indexPath.item].foodImage
        self.navigationController?.pushViewController(destinationVC!, animated: true) //Navigate to the next view controller
    }
}
