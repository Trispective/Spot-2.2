//
//  MenuViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/27.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,Step1{
    
    func step1() {
        performSegue(withIdentifier: "showStep1", sender: nil)
    }
    
    func showDish(d: Dish) {
        self.d=d
        performSegue(withIdentifier: "showDish", sender: nil)
    }
    var d=Dish()
    var restaurant=Restaurant()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showDish" :
                if let vc=segue.destination as? DishDetailViewController{
                    vc.dish=self.d
                }
            default:
                break
            }
            
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBAction func selectDish(_ sender: UIBarButtonItem) {
        if (selectButton.title?.contains("Select"))!{
            selectButton.title="Cancel"
            self.tabBarController?.tabBar.isHidden=true
            bottomViewHeight.constant=0.075*view.frame.height
            
            ModelManager.getInstance().restaurant.changeStateToSelect()
            
        }else{
            selectButton.title="Select"
            self.tabBarController?.tabBar.isHidden=false
            bottomViewHeight.constant=0
            
            ModelManager.getInstance().restaurant.changeStateToHide()
        }
        
        tableView.reloadData()
    }
    
    @IBAction func deleteDish(_ sender: UIButton) {
        let restaurant=ModelManager.getInstance().restaurant
        for (url,state) in restaurant.getDishState(){
            if state.contains("isSelected"){
                let cate=restaurant.getDishCategoryByUrl(u: url)
                ModelManager.getInstance().deleteDish(dishId: restaurant.getDishIdByUrl(u: url), category: cate)
                restaurant.deleteDishByUrl(u: url, c: cate)
                ModelManager.getInstance().deleteDishFromLocal(url: url)
            }
        }
        
        tableView.reloadData()
    }
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.alpha=1
 
        if !ModelManager.getInstance().restaurant.getId().isEmpty{
            self.tabBarController?.tabBar.isHidden=false
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        tableView.dataSource=self
        tableView.delegate=self
        
        if ModelManager.getInstance().restaurant.getId().isEmpty{
            selectButton.isEnabled=false
            selectButton.title=""
            self.tabBarController?.tabBar.isHidden=true
        }else{
            selectButton.isEnabled=true
            selectButton.title="Select"
            self.tabBarController?.tabBar.isHidden=false
        }

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var holdTitleView: UIView!
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleButton: UIButton!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var category=[String]()
        if ModelManager.getInstance().restaurant.getId().isEmpty{
            category=restaurant.getMenuCategory()
        }else{
            category=ModelManager.getInstance().restaurant.getMenuCategory()
        }
        
        var sumHeight:CGFloat=0
        for i in 0 ..< cellHeight.count{
            sumHeight+=cellHeight[i]
            
            //print(sumHeight)
            //print(scrollView.contentOffset.y)
            
            if scrollView.contentOffset.y < -64+sumHeight{
                if scrollView.contentOffset.y > -64+sumHeight-30{
                    titleConstraint.constant = -(scrollView.contentOffset.y-(-64+sumHeight-30))
                }else{
                    if scrollView.contentOffset.y <= -64{
                        holdTitleView.isHidden=true
                    }else{
                        holdTitleView.isHidden=false
                        titleConstraint.constant = 0
                    }
                }
                
                if i<category.count{
                    titleButton.titleLabel?.text=category[i]
                    titleButton.setTitle(category[i], for: .normal)
                }
                break
                
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            if ModelManager.getInstance().restaurant.getId().isEmpty{
                return restaurant.getMenuCategory().count
            }else{
               return ModelManager.getInstance().restaurant.getMenuCategory().count
            }
        }
        else{
            return 0
        }
        
    }
    
    var cellHeight=[CGFloat]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
            var category=[String]()
            var r=Restaurant()
            if ModelManager.getInstance().restaurant.getId().isEmpty{
                category=self.restaurant.getMenuCategory()
                r=self.restaurant
            }else{
                category=ModelManager.getInstance().restaurant.getMenuCategory()
                r=ModelManager.getInstance().restaurant
            }

            
            
            cell.restaurant=r
            cell.categoryButton.setTitle(category[indexPath.row], for: .normal)
            cell.count=r.getMenuDish(category: category[indexPath.row]).count
            cell.dishes=r.getMenuDish(category: category[indexPath.row])
            cell.delegate=self
            cell.updateCollectionView()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddTableViewCell
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==0{
            var category=[String]()
            var r=Restaurant()
            if ModelManager.getInstance().restaurant.getId().isEmpty{
                category=self.restaurant.getMenuCategory()
                r=self.restaurant
            }else{
                category=ModelManager.getInstance().restaurant.getMenuCategory()
                r=ModelManager.getInstance().restaurant
            }
            
            let percent=CGFloat((r.getMenuDish(category: category[indexPath.row]).count+1)/2)
            let height=view.frame.height*0.562/2*0.92*percent
            cellHeight.append(height+view.frame.width*0.0265+70)
            return height+view.frame.width*0.0265+70
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section==1{
            
        }
        
    }


}
