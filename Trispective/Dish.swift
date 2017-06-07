//
//  File.swift
//  Trispective
//
//  Created by USER on 2017/4/23.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import Foundation

class Dish{
    private var id:String=""
    private var title:String=""
    private var restaurant:String=""
    private var description:String=""
    private var cuisine:String=""
    private var category:String=""
    private var type:String=""
    private var price:String=""
    private var diet:String=""
    private var url:String = ""
    private var active=""
    
    
    init(id:String,title:String,restaurant:String,
         description:String,cuisine:String,category:String,
         type:String,price:String,diet:String,url:String){
        
        self.id = id
        self.title = title
        self.restaurant = restaurant
        self.description = description
        self.category = category
        self.cuisine = cuisine
        self.type = type
        self.price = price
        self.diet = diet
        self.url = url
        
        
    }
    
    init(i:String,ri:String,u:String){
        id=i
        restaurant=ri
        url=u
    }
    
    init(){
        
    }
    
    func getId() -> String { return id }
    func getUrl() -> String { return url }
    func getRestaurant() -> String { return restaurant }
    func getCuisine() -> String { return cuisine }
    func getCategory() -> String { return category }
    func getType() -> String { return type }
    func getPrice() -> String { return price }
    func getDiet() -> String { return diet }
    func getTitle() -> String { return title }
    func getDescription() -> String{ return description }
    
    func setTitle(title:String){
        self.title=title
    }
    
    func setDes(des:String){
        self.description=des
    }
    
    func setType(type:String){
        self.type=type
    }
    
    func setCuisine(cuisine:String){
        self.cuisine=cuisine
    }
    
    func setCategory(category:String){
        self.category=category
    }
    
    func setDiet(diet:String){
        self.diet=diet
    }
    
    func setPrice(price:String){
        self.price=price
    }
    
    func getDate()-> Date{
        var date=id as NSString
        let index=date.range(of: "date").location
        date=date.substring(from: index+4) as NSString
        let dateString=date as String
        let formatter=DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString)!
    }
    
}
