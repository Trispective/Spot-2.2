//
//  ModelManager.swift
//  Trispective
//
//  Created by USER on 2017/3/29.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

let sharedInstance = ModelManager()

class ModelManager:NSObject{
    var distanceButton=false
    var locationButton=false
    var location=""
    var latitude:CLLocationDegrees=0
    var longitude:CLLocationDegrees=0
    var mealTypeState=[String]()
    var cuisine = [String]()
    var category=[String]()
    var diet=[String]()
    var preferDistance:Double=0
    var dishes=[Dish]()
    var allRestaurants=[Restaurant]()
    var favouriteDishes=[String]()
    var preferDishes=[Dish]()
    var historyLocation=[
        "Melbourne",
        "Docklands",
        "Carlton",
        
    ]
    var historySelect=[
        "unselect",
        "unselect",
        "unselect",
    ]
    var historyIndex:Int=0{
        didSet{
            if historyIndex==3{
                historyIndex=0
            }
        }
    }
    private var avatarImageData:Data=Data()
    private var backgroundImageData=Data()
    private var user = User()
    var customer = Customer()
    var restaurant = Restaurant()
    
    var publishDish=Dish()
    
    class func getInstance() -> ModelManager
    {
//        if(sharedInstance.database == nil)
//        {
//
//        }
        return sharedInstance
    }
    
    func removeFavouriteInPrefer(){
        var temp=[Dish]()
        if favouriteDishes.count != 0{
            for i in 0 ..< preferDishes.count{
                for j in 0 ..< favouriteDishes.count{
                    if preferDishes[i].getId().contains(favouriteDishes[j]){
                        break
                    }
                    
                    if j==favouriteDishes.count-1{
                        temp.append(preferDishes[i])
                    }
                }
            }
            
            preferDishes=temp
        }
    }
    
    func optionIsEmpty(option:String)->Bool{
        var array=[String]()
        switch option {
        case "mealType":
            array=mealTypeState
        case "cuisine":
            array=cuisine
        case "category":
            array=category
        case "diet":
            array=diet
        default:
            break
        }
        for a in array{
            if a.contains("selected"){
                return false
            }
        }
        
        return true
    }
    
    func getDishesByMealType()->Bool{
        var tempDish=[Dish]()
        for i in 0 ..< preferDishes.count{
            for j in 0 ..< mealTypeState.count{
                if preferDishes[i].getType().contains(DemoImage.mealType[j]) && mealTypeState[j].contains("selected"){
                    tempDish.append(preferDishes[i])
                }
            }
        }
        
        if tempDish.count==0{
            return false
        }else{
            preferDishes=tempDish
            return true
        }

    }
    
    func getDishesByCuisine()->Bool{
        var tempDish=[Dish]()
        for i in 0 ..< preferDishes.count{
            for j in 0 ..< cuisine.count{
                if preferDishes[i].getCuisine().contains(DemoImage.cuisine[j]) && cuisine[j].contains("selected"){
                    tempDish.append(preferDishes[i])
                }
            }
        }
        
        if tempDish.count==0{
            return false
        }else{
            preferDishes=tempDish
            return true
        }
        
    }
    
    func getDishesByCategory()->Bool{
        var tempDish=[Dish]()
        for i in 0 ..< preferDishes.count{
            for j in 0 ..< category.count{
                if preferDishes[i].getCategory().contains(DemoImage.searchCategory[j]) && category[j].contains("selected"){
                    tempDish.append(preferDishes[i])
                }
            }
        }
        
        if tempDish.count==0{
            return false
        }else{
            preferDishes=tempDish
            return true
        }
        
    }
    
    func getDishesByDiet()->Bool{
        var tempDish=[Dish]()
        for i in 0 ..< preferDishes.count{
            for j in 0 ..< diet.count{
                if preferDishes[i].getDiet().contains(DemoImage.diet[j]) && diet[j].contains("selected"){
                    tempDish.append(preferDishes[i])
                }
            }
        }
        
        if tempDish.count==0{
            return false
        }else{
            preferDishes=tempDish
            return true
        }
        
    }
    
    func getDishesByLocation()->Bool{
        var key=""
        for i in 0 ..< historySelect.count{
            if historySelect[i].contains("selected"){
                key=historyLocation[i]
                break
            }
        }
        
        if key.isEmpty{
            return false
        }else{
            var tempDish=[Dish]()
            tempDish = preferDishes.filter({ (dish) -> Bool in
                let restaurantLocation=getRestaurantByRestaurantId(id: dish.getRestaurant()).getLocation().replacingOccurrences(of: " ", with: "").lowercased()
                return restaurantLocation.contains(key.lowercased())
            })
            
            if tempDish.count==0{
                return false
            }else{
                preferDishes=tempDish
                return true
            }
        }
    }
    

    
    func getDishesByDistance()->Bool{
        if (latitude==0 && longitude==0) || preferDistance==0{
            preferDishes=dishes
            removeFavouriteInPrefer()
            return false
        }else{
            preferDishes.removeAll()
            for d in dishes{
                if preferDistance >= getDistance(d: d){
                    preferDishes.append(d)
                }
            }
            
            if preferDishes.count==0{
                preferDishes=dishes
                removeFavouriteInPrefer()
                return false
            }else{
                removeFavouriteInPrefer()
                return true
            }
        }
    }
    
    func getDistance(d:Dish)->Double{
        let location1=CLLocation(latitude: latitude, longitude: longitude)
        let la=getRestaurantByRestaurantId(id: d.getRestaurant()).getLatitude() as CLLocationDegrees
        let lo=getRestaurantByRestaurantId(id: d.getRestaurant()).getLongitude() as CLLocationDegrees
        let location2=CLLocation(latitude: la, longitude: lo)
        
        let distance=location1.distance(from: location2) as Double
        return distance
    }
    
    func getRestaurantByRestaurantId(id:String)->Restaurant{
        for res in allRestaurants{
            if id.contains(res.getId()){
                return res
            }
        }
        
        return Restaurant()
    }
    
    let notifyResDownloaded = NSNotification.Name(rawValue:"notifyResDownloaded")
    func fetchRestaurantsData(){
        allRestaurants.removeAll()
        
        let ref = FIRDatabase.database().reference().child("DF").child("Users")
        ref.queryOrdered(byChild: "type").queryEqual(toValue: "restaurant").observeSingleEvent(of: .value, with: { (snapshot) in
            let dic = snapshot.value as! [String:AnyObject]
            //print(snapshot)
            
            for (key,value) in dic {
                let res = Restaurant.init(uid: key, values: value as! [String : AnyObject])
                if res.getActive().contains("1"){
                    self.allRestaurants.append(res)
                }
            }
            
            NotificationCenter.default.post(name: self.notifyResDownloaded, object: nil)
            
        })
    }
    
    let notifyPreferenceTableViewRefresh = NSNotification.Name(rawValue:"notifyPreferenceTableViewRefresh")
    let notifyLocationButtonSelected=NSNotification.Name(rawValue:"notifyLocationButtonSelected")
    let notifyRestaurantChanged = NSNotification.Name(rawValue:"notifyRestaurantChanged")
    let notifyAvatarChanged = NSNotification.Name(rawValue:"notifyAvatarChanged")
    func setAvatarData(data:Data){
        avatarImageData=data
        NotificationCenter.default.post(name: notifyAvatarChanged, object: nil)
    }
    
    func setCoverData(data:Data){
        backgroundImageData=data
        NotificationCenter.default.post(name: notifyAvatarChanged, object: nil)
    }
    
    func getAvatarData()->Data{
        return avatarImageData
    }
    
    func getCoverData()->Data{
        return backgroundImageData
    }
    
    func getCustomer() ->Customer{ return customer }
    
    func getRestaurant() ->Restaurant{ return restaurant }
    
    func setUser(uid:String,values:[String:AnyObject]) {
        self.user = User(uid: uid,values: values)
    }
    
    func setCutomser(uid:String,values:[String:AnyObject]) {
        self.customer = Customer(uid: uid,values: values)
        customer.setLoc(l: location)
    }
    
    func setRestaurant(uid:String,values:[String:AnyObject]) {
        self.restaurant = Restaurant(uid: uid,values: values)
    }
    
    func getUser() ->User{ return user }
    
    func fetchUserdata(){
        if  FIRAuth.auth()?.currentUser?.uid == nil{
            //print("Nothing ")
            return
        }else{
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("DF").child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.user = User(uid: uid!,values: dictionary)
                }
            }, withCancel: nil)
        }
        
    }
    
    /*func fetchCustomers(){
        FIRDatabase.database().reference().observe(.childAdded, with: { (snapshot) in
            
        }, withCancel: nil)
    }*/
    
    func uploadImage(type:String,imageData:Data){
        var a = ""
        var b = ""
        if type.contains("profile"){
            a = "Profile_Image"
            b = "profileImageurl"
        }else if type.contains("cover"){
            a = "Cover_Image"
            b = "coverImageurl"
        }
        let uid = FIRAuth.auth()?.currentUser?.uid
        let imageName = uid
        let storageRef = FIRStorage.storage().reference().child(a).child("\(imageName).jpg")
        let uploadData = imageData
        storageRef.delete { (error) in
            if let error = error{
                print(error)
            }else {
                
            }
        }
        storageRef.put(uploadData, metadata: nil) { (metadata, error) in
            if error != nil{
                print("\(error)")
                return
            }
            if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
                let userReference = ref.child("DF").child("Users").child(uid!).child(b)
                userReference.setValue(profileImageUrl)
                
            }
            
        }
        
    }
    
    let notifyImageChanged = NSNotification.Name(rawValue:"notifyImageChanged")
    func uploadDishImage(imageData:Data){
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        let formatter=DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now=Date()
        let date = "date"+formatter.string(from: now)
        let uid = FIRAuth.auth()?.currentUser?.uid
        let imageName = uid!+deviceID!+date
        //imageName = imageName.replacingOccurrences(of: ".", with: "0")
        
        //(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
        
        let storageRef = FIRStorage.storage().reference().child("Dishs").child("\(imageName).jpg")
        let uploadData = imageData
        //        storageRef.delete { (error) in
        //            if let error = error{
        //                print(error)
        //            }else {
        //
        //            }
        //        }
        storageRef.put(uploadData, metadata: nil) { (metadata, error) in
            if error != nil{
                print("\(error)")
                return
            }
            if let dishImageUrl = metadata?.downloadURL()?.absoluteString{
                //add in local database
                self.restaurant.addPending(id: imageName, restaurantId: uid!, url: dishImageUrl)
                NotificationCenter.default.post(name: self.notifyImageChanged, object: nil)
                
                
                let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
                let dishReference = ref.child("DF").child("Dishs").child(imageName)
                let pendingReference = ref.child("DF").child("Users").child(uid!).child("pending").child(imageName)
                let values = ["id":imageName,"restaurent":"\(uid!)","title":"","description":"","price":"",
                              "type":"","cuisine":"","category":"","diet":"","url":dishImageUrl] as [String : Any]
                dishReference.updateChildValues(values)
                pendingReference.setValue(dishImageUrl)
  
            }
            
        }
        
    }
    
    func removeDishFromPending(dishId:String){
        //remove dish in storage
        let storageRef = FIRStorage.storage().reference().child("Dishs").child("\(dishId).jpg")
        storageRef.delete { (error) in
            if let error = error{
                print(error)
            }else {
                
            }
        }
        // remove dish
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let dishReference = ref.child("DF").child("Dishs").child(dishId)
        dishReference.removeValue()
        // remove dish in pending
        let uid = FIRAuth.auth()?.currentUser?.uid
        let pendingReference = ref.child("DF").child("Users").child(uid!).child("pending").child(dishId)
        pendingReference.removeValue()
        
    }
    
    func download(){
        let profileImageurl = ModelManager.getInstance().getUser().getProfileImageurl()
        
        if profileImageurl.contains("https") {
            let url = URL(string: profileImageurl)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                if error != nil{
                    print("\(error)")
                }
                print(data as Any)
                self.avatarImageData = data!
            }).resume()
            
        }
    }
    
    // update dish info
    func updateDishInfomation(dishinfo:Dish,placeItem:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let restaurantReference = ref.child("DF").child("Users").child(uid!)

        // update menu
        let menuReference = restaurantReference.child("menu").child(placeItem).child(dishinfo.getId())
        menuReference.setValue(dishinfo.getUrl())
        
        // update dish
        let dishReference = ref.child("DF").child("Dishs").child(dishinfo.getId())
        let dishValues = ["id":dishinfo.getId(),"title":dishinfo.getTitle(),"description":dishinfo.getDescription(),
                          "price":dishinfo.getPrice(),"restaurant":dishinfo.getRestaurant(),"type":dishinfo.getType(),
                          "cuisine":dishinfo.getCuisine(),"category":dishinfo.getCategory(),"diet":dishinfo.getDiet(),
                          "url":dishinfo.getUrl()] as [String:Any]
        dishReference.setValue(dishValues)
        
        // delete pending
        let pendingReference = restaurantReference.child("pending").child(dishinfo.getId())
        pendingReference.removeValue()

    }
    
    func randomizePreferDishes(){
        var temp=[Dish]()
        let random=createRandomMan(start: 0, end: preferDishes.count-1)
        while(temp.count<preferDishes.count){
            temp.append(preferDishes[random()])
        }
        
        preferDishes=temp
    }
    
    func createRandomMan(start: Int, end: Int) ->() ->Int! {
        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }
        
        func randomMan() -> Int! {
            if !nums.isEmpty {
                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.remove(at: index)
            }
            else {
                return nil
            }
        }
        
        return randomMan
    }
    
    let notifyDishDownloaded = NSNotification.Name(rawValue:"notifyDishDownloaded")
    func fetchDish() {
        dishes.removeAll()
        preferDishes.removeAll()
        
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/").child("DF").child("Dishs")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String:AnyObject]{
                
                for (key,_) in dic{
                    let dish = dic[key] as! [String:String]
                    let title = dish["title"]!
                    if !title.isEmpty{
                        let downloadDish = Dish(id: dish["id"]!, title: dish["title"]!, restaurant: dish["restaurant"]!, description: dish["description"]!, cuisine: dish["cuisine"]!, category: dish["category"]!, type: dish["type"]!, price: dish["price"]!, diet: dish["diet"]!, url: dish["url"]!)
                        self.dishes.append(downloadDish)
                        self.preferDishes.append(downloadDish)
                    }
                    
                    
                }
                
                self.randomizePreferDishes()
                NotificationCenter.default.post(name: self.notifyDishDownloaded, object: nil)
            }
        })
        
        //fds
        
    }
    
    func  deleteDish(dishId:String,category:String)  {
        let storageRef = FIRStorage.storage().reference().child("Dishs").child("\(dishId).jpg")
        storageRef.delete { (error) in
            if let error = error{
                print(error)
            }else {
                
            }
        }
        
        // remove dish
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let dishReference = ref.child("DF").child("Dishs").child(dishId)
        dishReference.removeValue()
        
        //remove dish from menu
        let uid = FIRAuth.auth()?.currentUser?.uid
        let categoryRef = ref.child("DF").child("Users").child(uid!).child("menu").child(category).child(dishId)
        categoryRef.removeValue()
        
    }
    
    func deleteDishFromLocal(url:String){
        for i in 0 ..< dishes.count{
            if dishes[i].getUrl().contains(url){
                dishes.remove(at: i)
                break
            }
        }
    }
    
    func getDishByUrl(url:String)->Dish{
        for d in dishes{
            if d.getUrl().contains(url){
                return d
            }
        }
        
        return Dish()
    }
    
    func getDishById(id:String)->Dish{
        for d in dishes{
            if d.getId().contains(id){
                return d
            }
        }
        
        return Dish()
    }
    
    func editDish(dishinfo:Dish,newCategory:String,oldCategory:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let restaurantReference = ref.child("DF").child("Users").child(uid!)
        
        //remove dish from old category
        let oldCategoryRef = ref.child("DF").child("Users").child(uid!).child("menu").child(oldCategory).child(dishinfo.getId())
        oldCategoryRef.removeValue()
        
        // insert dish to new category
        let menuReference = restaurantReference.child("menu").child(newCategory).child(dishinfo.getId())
        menuReference.setValue(dishinfo.getUrl())
        
        // update dish
        let dishReference = ref.child("DF").child("Dishs").child(dishinfo.getId())
        let dishValues = ["id":dishinfo.getId(),"title":dishinfo.getTitle(),"description":dishinfo.getDescription(),
                          "price":dishinfo.getPrice(),"restaurant":dishinfo.getRestaurant(),"type":dishinfo.getType(),
                          "cuisine":dishinfo.getCuisine(),"category":dishinfo.getCategory(),"diet":dishinfo.getDiet(),
                          "url":dishinfo.getUrl()] as [String:Any]
        dishReference.setValue(dishValues)
        
        
    }
    
    func addFavouriteDish(dishID:String,Date:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let favouriteDishs = ref.child("DF").child("Users").child(uid!).child("favourites").child(dishID)
        favouriteDishs.setValue(Date)
    }
    
    func deleteFavouriteDish(dishId:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let favouriteDishs = ref.child("DF").child("Users").child(uid!).child("favourites").child(dishId)
        favouriteDishs.removeValue()
    }
    
    func removeFavouriteAfterRestaurantDeleteDish(){
        var i=0
        while(i<favouriteDishes.count){
            let dish=getDishById(id: favouriteDishes[i])
            if dish.getId().isEmpty{
                deleteFavouriteDish(dishId: favouriteDishes[i])
                favouriteDishes.remove(at: i)
            }else{
                i += 1
            }
        }
    }
    
    func addHistory(key:String){
        for i in 0 ..< historyLocation.count{
            if historyLocation[i].contains(key){
                historySelect=[
                    "unselect",
                    "unselect",
                    "unselect",
                ]
                historySelect[i]="selected"
                
                return
            }
        }
        
        if historyLocation.count<3{
            historyLocation.append(key)
            historyIndex+=1
        }else{
            historyLocation[historyIndex]=key
            historyIndex+=1
        }
    }
    
    func selectHistory(i:Int){
        if historySelect[i].contains("selected"){
            historySelect[i]="unselect"
        }else{
            historySelect=[
                "unselect",
                "unselect",
                "unselect",
            ]
            historySelect[i]="selected"
        }
        
    }
    
    func filterDish(){
        var i=0
        while(i<dishes.count){
            if getRestaurantByRestaurantId(id: dishes[i].getId()).getId().isEmpty{
                dishes.remove(at: i)
            }else{
                i += 1
            }
        }
        
        i=0
        while(i<preferDishes.count){
            if getRestaurantByRestaurantId(id: preferDishes[i].getId()).getId().isEmpty{
                preferDishes.remove(at: i)
            }else{
                i += 1
            }
        }
    }
    
    func setUserInfo(key:String,value:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let userinfo = ref.child("DF").child("Users").child(uid!).child(key)
        userinfo.setValue(value)
    }
 
    
}
