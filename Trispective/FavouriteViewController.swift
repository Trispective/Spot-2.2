//
//  FavouriteViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/17.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    //var dishState=[String]()
    var dishState=[String:[String]]()
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectAllViewHeight: NSLayoutConstraint!
    var sortString="date"
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > -10{
            valid=true
            self.navigationController?.navigationBar.isHidden=true
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }else if valid{
            self.navigationController?.navigationBar.isHidden=false
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
        
        
        
    }
    
    
    @IBAction func selectAllDish(_ sender: UIButton) {
        var valid=true
        for (key,value) in dishState{
            for i in 0 ..< value.count{
                if !dishState[key]![i].contains("isSelected"){
                    valid=false
                    break
                }
            }
            
            if !valid{
                break
            }
        }
        
        if valid{
            for (key,value) in dishState{
                for i in 0 ..< value.count{
                    dishState[key]![i]="select"
                }
            }
            
            selectAllButton.setImage(UIImage(named: "Rectangle 13"), for: .normal)
        }else{
            for (key,value) in dishState{
                for i in 0 ..< value.count{
                    dishState[key]![i]="isSelected"
                }
            }
            
            selectAllButton.setImage(UIImage(named: "Ticked Box Icon"), for: .normal)
        }
        collectionView.reloadData()
    }
    
    @IBAction func deleteImage(_ sender: UIButton) {
        var i=0
        var favourites=[String:[Dish]]()
        var key=[String]()
        switch sortString {
        case "date":
            favourites=ModelManager.getInstance().customer.getfavouritesByDate()
            key=ModelManager.getInstance().customer.getDateKey()
        case "mealType":
            favourites=ModelManager.getInstance().customer.getfavouritesByMealType()
            key=ModelManager.getInstance().customer.getMealTypeKey()
        case "category":
            favourites=ModelManager.getInstance().customer.getfavouritesByCategory()
            key=ModelManager.getInstance().customer.getCategoryKey()
        default:
            break
        }
        
        while(i<key.count){
            var j=0
            while(j<dishState[key[i]]!.count){
                if dishState[key[i]]![j].contains("isSelected"){
                    dishState[key[i]]!.remove(at: j)
                    let dish=favourites[key[i]]![j]
                    ModelManager.getInstance().deleteFavouriteDish(dishId: dish.getId())
                    ModelManager.getInstance().preferDishes.append(dish)
                    ModelManager.getInstance().customer.deleteFavouriteInDic(identity: dish.getId())
                    favourites[key[i]]!.remove(at: j)
                }else{
                    j += 1
                }
            }
            
            if dishState[key[i]]!.count==0{
                dishState[key[i]]=nil
                key.remove(at: i)
            }else{
                i += 1
            }
        }
        
        switch sortString {
        case "date":
            ModelManager.getInstance().customer.sortFavouriteByDate()
        case "mealType":
            ModelManager.getInstance().customer.sortFavouriteByMealType()
        case "category":
            ModelManager.getInstance().customer.sortFavouriteByCategory()
        default:
            break
        }
        //resetDishState()
        collectionView.reloadData()
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        var favourites=[String:[Dish]]()
        var key=[String]()
        switch sortString {
        case "date":
            favourites=ModelManager.getInstance().customer.getfavouritesByDate()
            key=ModelManager.getInstance().customer.getDateKey()
        case "mealType":
            favourites=ModelManager.getInstance().customer.getfavouritesByMealType()
            key=ModelManager.getInstance().customer.getMealTypeKey()
        case "category":
            favourites=ModelManager.getInstance().customer.getfavouritesByCategory()
            key=ModelManager.getInstance().customer.getCategoryKey()
        default:
            break
        }

        if deleteButton.isHidden{
            deleteButton.isHidden=false
            for i in 0 ..< key.count{
                for j in 0 ..< favourites[key[i]]!.count{
                    dishState[key[i]]![j]="select"
                }
            }
            
            selectAllView.isHidden=false
            selectAllViewHeight.constant=35
            
        }else{
            deleteButton.isHidden=true
            for i in 0 ..< key.count{
                for j in 0 ..< favourites[key[i]]!.count{
                    dishState[key[i]]![j]="hide"
                }
            }
            
            selectAllView.isHidden=true
            selectAllViewHeight.constant=0
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoImage.popoverName.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            sortString="date"
            titleLabel.text="Most Recent"
            ModelManager.getInstance().customer.sortFavouriteByDate()
            resetDishState()
        case 2:
            sortString="mealType"
            titleLabel.text="Meal Type"
            ModelManager.getInstance().customer.sortFavouriteByMealType()
            resetDishState()
        case 3:
            sortString="category"
            titleLabel.text="Category"
            ModelManager.getInstance().customer.sortFavouriteByCategory()
            resetDishState()
        default:
            break
        }
        
        popover.dismiss()
        collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text=DemoImage.popoverName[indexPath.row]
        cell.textLabel?.font=UIFont(name: DemoImage.font, size: 18)
        if DemoImage.popoverName[indexPath.row].contains("Sort By"){
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled=false
        }
        return cell
    }

    let tableView=UITableView()
    var popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
    @IBAction func sort(_ sender: UIButton) {
        let popoverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.4, height: self.view.frame.height*0.25))
        
        tableView.frame=CGRect(x: 0, y: 0, width: popoverView.frame.width, height: popoverView.frame.height)
        tableView.rowHeight=tableView.frame.height/CGFloat(DemoImage.popoverName.count)
        
        popoverView.addSubview(tableView)
        popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        popover.alpha=0.85
        popover.popoverType = .Up
        popover.show(contentView: popoverView, fromView: sender)
    }
    
    func resetDishState(){
        dishState.removeAll()
        var favourites=[String:[Dish]]()
        var key=[String]()
        switch sortString {
        case "date":
            ModelManager.getInstance().customer.sortFavouriteByDate()
            favourites=ModelManager.getInstance().customer.getfavouritesByDate()
            key=ModelManager.getInstance().customer.getDateKey()
        case "mealType":
            ModelManager.getInstance().customer.sortFavouriteByMealType()
            favourites=ModelManager.getInstance().customer.getfavouritesByMealType()
            key=ModelManager.getInstance().customer.getMealTypeKey()
        case "category":
            ModelManager.getInstance().customer.sortFavouriteByCategory()
            favourites=ModelManager.getInstance().customer.getfavouritesByCategory()
            key=ModelManager.getInstance().customer.getCategoryKey()
        default:
            break
        }
        
        for i in 0 ..< key.count{
            for _ in 0 ..< favourites[key[i]]!.count{
                if dishState[key[i]]==nil{
                    dishState[key[i]]=[String]()
                    dishState[key[i]]?.append("hide")
                }else{
                    dishState[key[i]]?.append("hide")
                }
            }
        }
    }
    
    var valid=false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valid=false
        self.navigationController?.navigationBar.alpha=0.4
        self.tabBarController?.tabBar.isHidden=false
        
        selectAllViewHeight.constant=0
        selectAllView.isHidden=true
        
        ModelManager.getInstance().removeFavouriteAfterRestaurantDeleteDish()
        
        deleteButton.isHidden=true
        resetDishState()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        tableView.delegate=self
        tableView.dataSource=self
        //tableView.register(MiddleCell.classForCoder(), forCellReuseIdentifier: "middleCell")
        
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.backgroundColor=view.backgroundColor
        let proportion:CGFloat=0.0265
        collectionView.contentInset=UIEdgeInsets(top: view.frame.width*proportion, left: view.frame.width*proportion, bottom: view.frame.width*proportion, right: view.frame.width*proportion)
        let layout=collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing=view.frame.width*proportion
        layout.minimumInteritemSpacing=view.frame.width*proportion
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView:UICollectionReusableView!
        if kind==UICollectionElementKindSectionHeader{
            headerView=collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reuseHeader", for: indexPath) as! HeaderCollectionReusableView
            var labelText=""
            switch sortString {
            case "date":
                labelText=ModelManager.getInstance().customer.getDateKey()[indexPath.section]
            case "mealType":
                labelText=ModelManager.getInstance().customer.getMealTypeKey()[indexPath.section]
            case "category":
                labelText=ModelManager.getInstance().customer.getCategoryKey()[indexPath.section]
                if labelText.isEmpty{
                    labelText="Default"
                }
            default:
                break
            }
            
            (headerView as! HeaderCollectionReusableView).headerLabel.text=labelText
        }
        
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch sortString {
        case "date":
            return ModelManager.getInstance().customer.getDateKey().count
        case "mealType":
            return ModelManager.getInstance().customer.getMealTypeKey().count
        case "category":
            return ModelManager.getInstance().customer.getCategoryKey().count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sortString {
        case "date":
            let key=ModelManager.getInstance().customer.getDateKey()
            return ModelManager.getInstance().customer.getfavouritesByDate()[key[section]]!.count
        case "mealType":
            let key=ModelManager.getInstance().customer.getMealTypeKey()
            return ModelManager.getInstance().customer.getfavouritesByMealType()[key[section]]!.count
        case "category":
            let key=ModelManager.getInstance().customer.getCategoryKey()
            return ModelManager.getInstance().customer.getfavouritesByCategory()[key[section]]!.count
        default:
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "pendingCollectionCell", for: indexPath) as! PendingCollectionViewCell
        var key=""
        var dishes=[Dish]()
        var dish=Dish()
        
        switch sortString {
        case "date":
            key=ModelManager.getInstance().customer.getDateKey()[indexPath.section]
            dishes=ModelManager.getInstance().customer.getfavouritesByDate()[key]!
            dish=dishes[indexPath.row]
        case "mealType":
            key=ModelManager.getInstance().customer.getMealTypeKey()[indexPath.section]
            dishes=ModelManager.getInstance().customer.getfavouritesByMealType()[key]!
            dish=dishes[indexPath.row]
        case "category":
            key=ModelManager.getInstance().customer.getCategoryKey()[indexPath.section]
            dishes=ModelManager.getInstance().customer.getfavouritesByCategory()[key]!
            dish=dishes[indexPath.row]
        default:
            break
        }
        
        
        cell.image.loadImageUsingCacheWithUrlString(dish.getUrl())
        switch dishState[key]![indexPath.row] {
        case "hide":
            cell.boxImage.isHidden=true
        case "select":
            cell.boxImage.isHidden=false
            cell.boxImage.image=UIImage(named: "Rectangle 13")
        case "isSelected":
            cell.boxImage.isHidden=false
            cell.boxImage.image=UIImage(named: "Ticked Box Icon")
        default:
            break
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showDishDetail" :
                let upComing=segue.destination as! DishDetailViewController
                upComing.dish=dishForSegue
                
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: view.frame.height*0.562/2*0.92)
    }
    
    var dishForSegue=Dish()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var key=""
        var dishes=[Dish]()
        var dish=Dish()
        
        switch sortString {
        case "date":
            key=ModelManager.getInstance().customer.getDateKey()[indexPath.section]
            dishes=ModelManager.getInstance().customer.getfavouritesByDate()[key]!
            dish=dishes[indexPath.row]
        case "mealType":
            key=ModelManager.getInstance().customer.getMealTypeKey()[indexPath.section]
            dishes=ModelManager.getInstance().customer.getfavouritesByMealType()[key]!
            dish=dishes[indexPath.row]
        case "category":
            key=ModelManager.getInstance().customer.getCategoryKey()[indexPath.section]
            dishes=ModelManager.getInstance().customer.getfavouritesByCategory()[key]!
            dish=dishes[indexPath.row]
        default:
            break
        }
        
        if deleteButton.isHidden{
            dishForSegue=dish
            performSegue(withIdentifier: "showDishDetail", sender: nil)
            
        }else{
            if dishState[key]![indexPath.row].contains("isSelected"){
                dishState[key]![indexPath.row]="select"
            }else{
                dishState[key]![indexPath.row]="isSelected"
            }
            
            collectionView.reloadData()
        }
    }


}
