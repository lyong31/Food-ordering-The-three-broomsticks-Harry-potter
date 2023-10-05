import Foundation

class DataSource {
    
    static let instance = DataSource()
        
        let foodClass = [
            FoodClassification(foodType: "Foods", foodImage: "Foods"),
            FoodClassification(foodType: "Drinks", foodImage: "Drinks"),
            FoodClassification(foodType: "Snacks ", foodImage: "Snacks")
        ]
        
        public let Foods = [
            FoodList(foodName: "Corned Beef Sandwiches", foodPrice: "10.00", priceSign: "RM", foodImage: "Corned Beef Sandwiches", foodDesc: "Prepared by Mplly Weasley ffor the journey to the Hogwarts Express."),
            FoodList(foodName: "Harry’s Birthday Cake", foodPrice: "7.00", priceSign: "RM", foodImage: "Harry’s Birthday Cake", foodDesc: "Made by Hagrid himself."),
            FoodList(foodName: "Petunia Dursley's Pudding", foodPrice: "10.00", priceSign: "RM", foodImage: "Petunia Dursley's Pudding", foodDesc: "special dessert made by Harry's aunt spicy noodle soup with chicken, prawn, and coconut milk."),
            FoodList(foodName: "Bouillabaisse", foodPrice: "7.50", priceSign: "RM", foodImage: "Bouillabaisse", foodDesc: "A seafood stew which originated in southern france.")
        ]
        
        private let Drinks = [
            FoodList(foodName: "Butterbeer", foodPrice: "3.50", priceSign: "RM", foodImage: "Butterbeer", foodDesc: "Made with soda, sugar, heavy cream, butter and a tinge of rum, this drink offers a blast of flavours."),
            FoodList(foodName: "Pumpkin Juice", foodPrice: "3.00", priceSign: "RM", foodImage: "Pumpkin Juice", foodDesc: "A wizarding beverage made from pumpkins."),
            FoodList(foodName: "Polyjuice Potion", foodPrice: "4.30", priceSign: "RM", foodImage: "Polyjuice Potion", foodDesc: "A potion that allowed the drinker to assume the form of someone else."),
            FoodList(foodName: "Unicorn Blood", foodPrice: "15.00", priceSign: "RM", foodImage: "Unicorn Blood", foodDesc: "The blood of a unicorn will keep you alive (Cocktail)")
        ]
        
        private let Snacks = [
            FoodList(foodName: "canary creams", foodPrice: "4.00", priceSign: "RM", foodImage: "canary creams", foodDesc: "A type of biscuit, they created them in 1994 and charged seven sickles for each."),
            FoodList(foodName: "Bertie Bot's Every Flavour Beans", foodPrice: "3.50", priceSign: "RM", foodImage: "Bertie Bot's Every Flavour Beans", foodDesc: "If you dare, you'll taste Booger, Black Pepper, Dirt, Earthworm, Earwax, Grass and Rotten Egg in this magical mix."),
            FoodList(foodName: "Treacle Tarts", foodPrice: "5.00", priceSign: "RM", foodImage: "Treacle Tarts", foodDesc: "treacle tart, a very simple and delicious homemade tart recipe made with golden syrup."),
            FoodList(foodName: "Shepherd’s Pie", foodPrice: "5.00", priceSign: "RM", foodImage: "Shepherd’s Pie", foodDesc: "A traditional English meat pie that consists of lamb and vegetables and is then covered in mashed potatoes.")
        ]
        
        private let delicacies = [FoodList]()
        
        func getFoodClassification() -> [FoodClassification] {
            return foodClass
        }
        
        func getFood(forFoodType type: String) -> [FoodList] {
            if (type == "Foods") {
                return getFoods()
            }
            else if (type == "Drinks") {
                return getDrinks()
            }
            else if (type == "Snacks") {
                return getSnacks()
            }
            else {
                return getFoods()
            }
        }
        
        func getFoods() -> [FoodList] {
            return Foods
        }
        
        func getDrinks() -> [FoodList] {
            return Drinks
        }
        
        func getSnacks() -> [FoodList] {
            return Snacks
        }
            
        func getDelicacies() -> [FoodList] {
            return delicacies
        }
    }
