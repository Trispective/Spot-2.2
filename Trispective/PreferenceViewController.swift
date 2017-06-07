//
//  PreferenceViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/30.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController,UISearchBarDelegate {

    @IBAction func clearAll(_ sender: UIButton) {
        ModelManager.getInstance().distanceButton=false
        ModelManager.getInstance().locationButton=false
        
        ModelManager.getInstance().mealTypeState.removeAll()
        ModelManager.getInstance().cuisine.removeAll()
        ModelManager.getInstance().category.removeAll()
        ModelManager.getInstance().diet.removeAll()
        
        NotificationCenter.default.post(name: ModelManager.getInstance().notifyPreferenceTableViewRefresh, object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        //self.automaticallyAdjustsScrollViewInsets=false

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        var valid=true
        ModelManager.getInstance().preferDishes=ModelManager.getInstance().dishes
        if ModelManager.getInstance().distanceButton{
            if !ModelManager.getInstance().getDishesByDistance(){
                valid=false
            }
        }
        
        if ModelManager.getInstance().locationButton{
            if !ModelManager.getInstance().getDishesByLocation(){
                valid=false
            }
        }
        
        if !ModelManager.getInstance().optionIsEmpty(option: "mealType"){
            if !ModelManager.getInstance().getDishesByMealType(){
                valid=false
            }
        }
        
        if !ModelManager.getInstance().optionIsEmpty(option: "cuisine"){
            if !ModelManager.getInstance().getDishesByCuisine(){
                valid=false
            }
        }
        
        if !ModelManager.getInstance().optionIsEmpty(option: "category"){
            if !ModelManager.getInstance().getDishesByCategory(){
                valid=false
            }
        }
        
        if !ModelManager.getInstance().optionIsEmpty(option: "diet"){
            if !ModelManager.getInstance().getDishesByDiet(){
                valid=false
            }
        }
        
        if valid{
            createAlert(title: "Success", message: "You have changed your preferences!")
        }else{
            createAlert(title: "Failed", message: "No dish has been found!")
        }
    }


}
