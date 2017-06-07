//
//  Customer.swift
//  Trispective
//
//  Created by USER on 2017/4/23.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import Foundation

class Customer: User {
    private var description=""
    private var phoneNumber:String=""
    private var dob:String=""
    private var favouriteDishDic = [String:String]()
    
    private var dateKey=[String]()
    private var dateSortDishes=[String:[Dish]]()
    
    private var mealTypeKey=[String]()
    private var mealTypeSortDishes=[String:[Dish]]()
    
    private var categoryKey=[String]()
    private var categorySortDishes=[String:[Dish]]()
    private var location=""
    
    
    override init() {
        super.init()
    }
    
    override init(uid:String,values customerValues:[String:AnyObject]) {
        super.init(uid: uid, values: customerValues)
        self.description=customerValues["description"] as! String
        self.phoneNumber = customerValues["phoneNumber"] as! String
        self.dob = customerValues["dob"] as! String
        favouriteDishDic = customerValues["favourites"] as! [String : String]
        
        ModelManager.getInstance().favouriteDishes.removeAll()
        for (key,_) in favouriteDishDic{
            if !key.contains("none"){
               ModelManager.getInstance().favouriteDishes.append(key)
            }   
        }
        
        ModelManager.getInstance().removeFavouriteInPrefer()
        sortFavouriteByDate()
    }
    
    func getLoc()->String{
        return location
    }
    
    func setLoc(l:String){
        location=l
    }
    
    func getDes()->String{
        return description
    }
    
    func setDes(d:String){
        description=d
    }
    
    func addFavouriteInDic(identity:String,date:String){
        favouriteDishDic[identity]=date
    }
    
    func deleteFavouriteInDic(identity:String){
        favouriteDishDic[identity]=nil
    }
    
    func sortFavouriteByCategory(){
        categorySortDishes.removeAll()
        categoryKey.removeAll()
        
        for (key,_) in favouriteDishDic{
            if !key.contains("none"){
                
                let d=ModelManager.getInstance().getDishById(id: key)
                if let _=categorySortDishes[d.getCategory()]{
                    categorySortDishes[d.getCategory()]?.append(d)
                }else{
                    categorySortDishes[d.getCategory()]=[Dish]()
                    categoryKey.append(d.getCategory())
                    categorySortDishes[d.getCategory()]?.append(d)
                }
            }
        }
        
        sortCategoryKey()
        
    }

    
    func sortFavouriteByMealType(){
        mealTypeSortDishes.removeAll()
        mealTypeKey.removeAll()
        
        for (key,_) in favouriteDishDic{
            if !key.contains("none"){
                
                let d=ModelManager.getInstance().getDishById(id: key)
                if let _=mealTypeSortDishes[d.getType()]{
                    mealTypeSortDishes[d.getType()]?.append(d)
                }else{
                    mealTypeSortDishes[d.getType()]=[Dish]()
                    mealTypeKey.append(d.getType())
                    mealTypeSortDishes[d.getType()]?.append(d)
                }
            }
        }
    }
    
    func sortFavouriteByDate(){
        dateSortDishes.removeAll()
        dateKey.removeAll()

        for (key,_) in favouriteDishDic{
            if !key.contains("none"){
                let formatter=DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let v=formatter.string(from: getDate(id: key))
                
                let d=ModelManager.getInstance().getDishById(id: key)
                if let _=dateSortDishes[v]{
                    dateSortDishes[v]?.append(d)
                }else{
                    dateSortDishes[v]=[Dish]()
                    dateKey.append(v)
                    dateSortDishes[v]?.append(d)
                }
            }
        }
        
        sortDateKey()
    }
    
    func getCategoryKey()->[String]{
        return categoryKey
    }
    
    func getfavouritesByCategory()->[String:[Dish]]{
        return categorySortDishes
    }
    
    func getMealTypeKey()->[String]{
        return mealTypeKey
    }
    
    func getfavouritesByMealType()->[String:[Dish]]{
        return mealTypeSortDishes
    }
    
    func getDateKey()->[String]{
        return dateKey
    }
    
    func getfavouritesByDate()->[String:[Dish]]{
        return dateSortDishes
    }
    
    func sortCategoryKey(){
        var temp=[String]()
        for i in 0 ..< categoryKey.count{
            if categoryKey[i].isEmpty{
                temp.insert(categoryKey[i], at: 0)
            }else{
                temp.append(categoryKey[i])
            }
        }
        
        categoryKey=temp
    }
    
    func sortDateKey(){
        var temp=[String]()
        if dateKey.count>0{
            temp.append(dateKey[0])
            for i in 1 ..< dateKey.count{
                for j in 0 ..< temp.count{
                    let formatter=DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if formatter.date(from: dateKey[i])?.compare(formatter.date(from: temp[j])!) == .orderedDescending{
                        temp.insert(dateKey[i], at: j)
                        break
                    }
                    
                    if j==temp.count-1{
                        temp.insert(dateKey[i], at: j+1)
                    }
                }
            }
        }
        
        dateKey=temp
    }
    
    func getDate(id:String)->Date{
        var date=favouriteDishDic[id]! as NSString
        date=date.substring(to: 10) as NSString
        let formatter=DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date as String)!
    }
}
