//
//  DishDetailViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/15.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController{
    var dish=Dish()

    func getRestaurant()->Restaurant{
        return ModelManager.getInstance().getRestaurantByRestaurantId(id: dish.getRestaurant())
    }
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var availableTime: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishDetailLabel: UILabel!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBAction func showRestaurant(_ sender: UIButton) {
        performSegue(withIdentifier: "showBusinessProfile", sender: nil)
    }
    @IBAction func showMap(_ sender: UIButton) {
        performSegue(withIdentifier: "showMap", sender: nil)
    }
    
    var image:UIImage?{
        get{
            return dishImageView.image
        }
        set{
            dishImageView.image=newValue
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showBusinessProfile" :
                let upComing=segue.destination as! BusinessProfileViewController
                upComing.restaurant=ModelManager.getInstance().getRestaurantByRestaurantId(id: dish.getRestaurant())
            case "showMap" :
                let upComing=segue.destination as! MapViewController
                upComing.restaurant=ModelManager.getInstance().getRestaurantByRestaurantId(id: dish.getRestaurant())
                
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        dishDetailLabel.adjustsFontSizeToFitWidth=true
        
        let attrs = [NSUnderlineStyleAttributeName :1]as [String :Any]
        let restaurantName=NSAttributedString(string: ModelManager.getInstance().getRestaurantByRestaurantId(id: dish.getRestaurant()).getName(), attributes: attrs)
        restaurantButton.setAttributedTitle(restaurantName, for: .normal)
        
        dishImageView.loadImageUsingCacheWithUrlString(dish.getUrl())
        dishName.text=dish.getTitle()
        dishDetailLabel.text=dish.getDescription()
        distanceLabel.text=String(format: "%.1f",ModelManager.getInstance().getDistance(d: dish)/1000)+"Km"
        let priceDouble=Double(dish.getPrice())
        let priceString=String(format: "%.2f",priceDouble!)
        
        dishPrice.text="Price: $"+priceString
        availableTime.text="Available: "+ModelManager.getInstance().getRestaurantByRestaurantId(id: dish.getRestaurant()).getAvailableTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
        
        self.navigationController?.navigationBar.alpha=0.4
        

    }


}
