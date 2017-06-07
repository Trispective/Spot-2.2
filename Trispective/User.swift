//
//  User.swift
//  Trispective
//
//  Created by USER on 2017/4/23.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import Foundation
class User{
    private var id:String=""
    private var name:String=""
    private var email:String=""
    private var type:String=""
    private var coverImageurl:String=""
    private var profileImageurl:String=""
    
    init() {
        
    }
    init(uid:String,values:[String:AnyObject]) {
        
        self.id = uid
        self.type = values["type"] as! String
        self.name = values["name"] as! String
        self.email = values["email"] as! String
        self.coverImageurl = values["coverImageurl"] as! String
        self.profileImageurl = values["profileImageurl"] as! String
        
    }
    
    func setCoverUrl(u:String){
        coverImageurl=u
    }
    
    func setName(n:String){
        name=n
    }
    
    func getId()->String{ return id}
    func getName()->String{ return name}
    func getType()->String{ return type}
    func getEmail()->String{ return email}
    func getProfileImageurl() -> String {return profileImageurl}
    func getCoverImageurl() -> String {return coverImageurl}
}
