//
//  Restaurant.swift
//  Trispective
//
//  Created by USER on 2017/4/23.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import Foundation

class Restaurant:User {
    private var restaurantType=""
    private var location:String=""
    private var active:String="" 
    private var phoneNumber:String=""
    private var postCode:String=""
    private var aboutUs:String=""
    private var suburb:String=""
    private var availableTime:String=""
    private var abn:String=""
    private var latitude:String=""
    private var longitude:String=""
    
    private var pendingDish = [Dish]()
    
    private var menuCategory=[String]()
    private var dishState=[String:String]()
    private var menu = [String:[String:String]]()
    
    func getRestaurantType()->String{ return restaurantType}
    func getAboutUs()->String{ return aboutUs}
    func getAvailableTime()->String{return availableTime}
    func getPhoneNumber()->String{return phoneNumber}
    func getLocation()->String{return location}
    
    func setAboutUs(aboutUs:String){
        self.aboutUs=aboutUs
    }
    
    override init() {
        super.init()
    }
    
    override init(uid:String,values restaurantvalues:[String:AnyObject]){
        super.init(uid: uid, values: restaurantvalues)
        self.location = restaurantvalues["location"] as! String
        self.active = restaurantvalues["active"] as! String
        self.phoneNumber = restaurantvalues["phoneNumber"] as! String
        self.postCode = restaurantvalues["postCode"] as! String
        self.aboutUs = restaurantvalues["aboutUs"] as! String
        self.suburb = restaurantvalues["suburb"] as! String
        self.availableTime = restaurantvalues["availableTime"] as! String
        restaurantType=restaurantvalues["restaurantType"] as! String
        self.abn = restaurantvalues["abn"] as! String
        self.latitude=restaurantvalues["latitude"] as! String
        self.longitude=restaurantvalues["longitude"] as! String
        
        self.menu=restaurantvalues["menu"] as! [String:[String:String]]
        for (key,value) in menu{
            if !key.contains("none"){
                menuCategory.append(key)
                let dic=value
                
                menu[key]=dic
                for (_,v) in dic{
                    dishState[v]="hide"
                }
            }

        }
        
        let pending = restaurantvalues["pending"] as! [String : String]
        for (key,value) in pending{
            if !key.contains("none"){
                addPending(id: key, restaurantId: uid, url: value)
            }
        }
        
        sort()
    }
    
    func getLatitude()->Double{
        return (latitude as NSString).doubleValue
    }
    
    func getLongitude()->Double{
        return (longitude as NSString).doubleValue
    }
    
    func deleteDishByUrl(u:String,c:String){
        menu[c]!.removeValue(forKey: getDishIdByUrl(u: u))
        dishState.removeValue(forKey: u)
        if menu[c]!.count==0{
            for i in 0 ..< menuCategory.count{
                if menuCategory[i].contains(c){
                    menuCategory.remove(at: i)
                    break
                }
            }
        }
    }
    
    func getDishIdByUrl(u:String)->String{
        for(_,value) in menu{
            for (k,v) in value{
                if v.contains(u){
                    return k
                }
            }
        }
        
        return ""
    }
    
    func getDishCategoryByUrl(u:String)->String{
        for(key,value) in menu{
            for (_,v) in value{
                if v.contains(u){
                    return key
                }
            }
        }
        
        return ""
    }
    
    func getDishState()->[String:String]{
        return dishState
    }
    
    func changeStateToSelect(){
        for (key,_) in dishState{
            dishState[key]="select"
        }
    }
    
    func changeState(k:String,value:String){
        for (key,_) in dishState{
            if key.contains(k){
                dishState[key]=value
                break
            }
        }
    }
    
    func changeStateToHide(){
        for (key,_) in dishState{
            dishState[key]="hide"
        }
    }
    
    func checkifCategoryExist(title:String)->Bool{
        for c in menuCategory{
            if c.contains(title){
                return false
            }
        }
        return true
    }
    
    func getDishUrlUnderCategory(dishes:[String:String])->[String]{
        var temp=[String]()
        for (_,value) in dishes{
            temp.append(value)
        }
        
        return temp
    }
    
    func getMenuDish(category:String)->[String:String]{
        for (key,value) in menu{
            if key.contains(category){
                return value
            }
        }
        let temp=[String:String]()
        return temp
    }
    
    func addMenuCategory(title:String){
        menuCategory.append(title)
    }
    
    func addMenuDish(menuString:String,dishId:String,dishUrl:String){
        dishState[dishUrl]="hide"
        
        if menu[menuString] != nil{
            menu[menuString]![dishId]=dishUrl
        }else{
            var temp=[String:String]()
            temp[dishId]=dishUrl
            menu[menuString]=temp
        }
        
    }
    
    func removePendingDish(id:String){
        for i in 0 ..< pendingDish.count{
            if pendingDish[i].getId().contains(id){
                pendingDish.remove(at: i)
                break
            }
        }
    }
    
    func addPending(id:String,restaurantId:String,url:String){
        let dish = Dish(i: id,ri: restaurantId,u: url)
        pendingDish.insert(dish, at: 0)
    }
    
    func sort(){
        var temp=[Dish]()
        if pendingDish.count>0{
            temp.append(pendingDish[0])
            for i in 1 ..< pendingDish.count{
                for j in 0 ..< temp.count{
                    if pendingDish[i].getDate().compare(temp[j].getDate()) == .orderedDescending{
                        temp.insert(pendingDish[i], at: j)
                        break
                    }
                    
                    if j==temp.count-1{
                        temp.insert(pendingDish[i], at: j+1)
                    }
                }
            }
        }
        
        pendingDish=temp
    }
    
    func getMenu() -> [String:[String:String]] {return self.menu}
    func getPending() ->[Dish]{return self.pendingDish}
    func getMenuCategory()->[String]{return menuCategory}
    func getActive()->String{return active}
}
