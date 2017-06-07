//
//  Step3ViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/6.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class Step3ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dishImage: UIImageView!
    @IBAction func gotoPending(_ sender: UIButton) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func publish(_ sender: UIButton) {
        let price=priceField.text!
        if price.isEmpty || menuString.isEmpty{
            self.createAlert(title: "Warning", message: "Please complete all the information before publishing.")
        }else{
            ModelManager.getInstance().publishDish.setPrice(price: price)
            let dish=ModelManager.getInstance().publishDish
            
            if ModelManager.getInstance().getDishByUrl(url: dish.getUrl()).getId().isEmpty{
                //publish
                ModelManager.getInstance().updateDishInfomation(dishinfo: dish, placeItem: menuString)
                //remove in local database
                ModelManager.getInstance().restaurant.removePendingDish(id: dish.getId())
                
                //add in local
                ModelManager.getInstance().restaurant.addMenuDish(menuString: menuString, dishId: dish.getId(), dishUrl: dish.getUrl())
                ModelManager.getInstance().dishes.append(dish)

            }else{
                //update
                let old=ModelManager.getInstance().restaurant.getDishCategoryByUrl(u: dish.getUrl())
                ModelManager.getInstance().editDish(dishinfo: dish, newCategory: menuString, oldCategory: old)
                
                //add in local
                if !old.contains(menuString){
                    ModelManager.getInstance().restaurant.deleteDishByUrl(u: dish.getUrl(), c: old)
                }
                ModelManager.getInstance().restaurant.addMenuDish(menuString: menuString, dishId: dish.getId(), dishUrl: dish.getUrl())                
                for i in 0 ..< ModelManager.getInstance().dishes.count{
                    if ModelManager.getInstance().dishes[i].getId().contains(dish.getId()){
                        ModelManager.getInstance().dishes[i]=dish
                        break
                    }
                }
            }
            
            _=self.navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBOutlet weak var priceField: UITextField!
    var menuState=[String]()
    var menuString=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView=UIView()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        
        let tap: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapView.addGestureRecognizer(tap)
        
        
        let dish=ModelManager.getInstance().publishDish
        menuState.removeAll()
        let restaurant=ModelManager.getInstance().restaurant
        let c=restaurant.getDishCategoryByUrl(u: dish.getUrl())
        for i in 0 ..< restaurant.getMenuCategory().count{
            if c.contains(restaurant.getMenuCategory()[i]) && restaurant.getMenuCategory()[i].contains(c){
                menuState.append("selected")
                menuString=c
            }else{
                menuState.append("unselect")
            }
            
        }

        let url=dish.getUrl()
        dishImage.loadImageUsingCacheWithUrlString(url)
        
        if !dish.getPrice().isEmpty{
            priceField.text=dish.getPrice()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section==0{
            return ModelManager.getInstance().restaurant.getMenuCategory().count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "step3MenuCell", for: indexPath) as! Step3TableViewCell
            
            if menuState.count>0 {
                if menuState[indexPath.row].contains("unselect"){
                    cell.selectImage.image=UIImage(named: "Select Icon (Grey)")
                }else{
                    cell.selectImage.image=UIImage(named: "Select Icon (Teal)")
                }
            }
            
            cell.title.text=ModelManager.getInstance().restaurant.getMenuCategory()[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section==0{
            if menuState[indexPath.row].contains("unselect"){
                menuState.removeAll()
                for _ in 0 ..< ModelManager.getInstance().restaurant.getMenuCategory().count{
                    menuState.append("unselect")
                }
                menuState[indexPath.row]="selected"
                menuString=ModelManager.getInstance().restaurant.getMenuCategory()[indexPath.row]
            }else{
                menuState[indexPath.row]="unselect"
                menuString=""
            }
            
        }else{
            let alertController = UIAlertController(title: "Category Title",message: "", preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "Menu Title"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                action in
                
                let title=alertController.textFields!.first!.text!
                if ModelManager.getInstance().restaurant.checkifCategoryExist(title: title){
                    ModelManager.getInstance().restaurant.addMenuCategory(title: title)
                    self.menuState.append("unselect")
                    tableView.reloadData()
                }else{
                    self.createAlert(title: "Warning", message: "This category has already been created!")
                }
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        tableView.reloadData()

    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }

}
