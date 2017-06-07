//
//  ViewController.swift
//  Trispective
//
//  Created by USER on 2017/3/24.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class LoginViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var coverView: UIView!
    @IBOutlet private weak var userAccount: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private var state="login"
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        }
        let locale=NSLocale(localeIdentifier: "zh_CN")
        //print(countries)*/
        
        loginState=false
        dishDownloaded=false
        restaurantDownloaded=false
        ModelManager.getInstance().fetchDish()
        ModelManager.getInstance().fetchRestaurantsData()
        
        if (FIRAuth.auth()?.currentUser?.uid) != nil{
            if (FIRAuth.auth()?.currentUser?.isEmailVerified)!{
                coverView.isHidden=false
                loginState=true
                handleNotification()
                self.timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeAction), userInfo: nil, repeats: true)
            }else{
                coverView.isHidden=true
            }

        }else{
            coverView.isHidden=true
        }
    }
    
    var timeRemaining:Int=0
    var timer=Timer()
    func timeAction(){
        timeRemaining+=1
        if timeRemaining>8{
            timeRemaining=0
            coverView.isHidden=true
            loginState=false
            timer.invalidate()
            
            //createAlert(title: "Error", message: "Please try agian!")
        }
    }
    
    let manager=CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[0]
        ModelManager.getInstance().latitude=location.coordinate.latitude
        ModelManager.getInstance().longitude=location.coordinate.longitude
        manager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(location) { (pms, err) in
            let placemark:CLPlacemark=(pms?.last)!
            let locality=placemark.locality!
            let country=placemark.country!
            ModelManager.getInstance().location="\(locality) \(country)"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotiForRes), name: ModelManager.getInstance().notifyResDownloaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotiForDish), name: ModelManager.getInstance().notifyDishDownloaded, object: nil)
        
        manager.delegate=self
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        loginButton.setTitleColor(UIColor.gray, for: .highlighted)
        forgetPasswordButton.setTitleColor(UIColor.gray, for: .highlighted)
        createAccountButton.setTitleColor(UIColor.gray, for: .highlighted)
        
        let tap: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction private func forgetPassword(_ sender: UIButton) {
        let alertSheet=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Reset Password", style: .default){ _ in
            self.resetPassword()
        })
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
            
        })
        
        self.present(alertSheet,animated: true)
    }
    
    func resetPassword(){
        let alertController = UIAlertController(title: "Reset Password",message: "What is your email address?", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Email"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            
            let title=alertController.textFields!.first!.text!
            FIRAuth.auth()?.sendPasswordReset(withEmail: title, completion: { (error) in
                if error != nil{
                    self.createAlert(title: "Error", message: error!.localizedDescription)
                    return
                    //print("\(error)")
                }
                
                self.createAlert(title: "Success", message: "An reset password email has been sent to your address!")
            })
            
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func createAccount(_ sender: UIButton) {
        performSegue(withIdentifier: "showChooseView", sender: nil)
    }
    
    @IBAction private func login(_ sender: UIButton) {
        handleLogin()
        
        
//        let loginName = userAccount.text!
//        let userPassword = password.text!
//        
//        if state.contains("login"){
//            if loginName=="customer" && userPassword=="customer"{
//                performSegue(withIdentifier: "showSpot", sender: sender)
//            }else if loginName=="restaurant" && userPassword=="restaurant"{
//                performSegue(withIdentifier: "showRestaurant", sender: sender)
//            }else{
//                createAlert(title: "Sign in Failed!", message: "User account or password is incorrect!")
//                return
//            }
//        }else if state.contains("register"){
//            if loginName.isEmpty || (userPassword.isEmpty) {
//                createAlert(title: "Register Failed!", message: "User account or password is empty!")
//                return
//            }
//        }
    }
    
    var loginState=false
    var dishDownloaded=false
    var restaurantDownloaded=false
    
    func handleNotiForDish(){
        dishDownloaded=true
        var c=0
        if ModelManager.getInstance().preferDishes.count>4{
            c=5
        }else{
            c=ModelManager.getInstance().preferDishes.count
        }
        
        for i in 0 ..< c{
            let iv=UIImageView()
            iv.loadImageUsingCacheWithUrlString(ModelManager.getInstance().preferDishes[i].getUrl())
        }
        handleNotification()
    }
    
    func handleNotiForRes(){
        restaurantDownloaded=true
        handleNotification()
    }
    
    func handleNotification(){
        if loginState{
            if self.dishDownloaded && self.restaurantDownloaded{
                if let uid = FIRAuth.auth()?.currentUser?.uid{
                    ModelManager.getInstance().filterDish()
                    fetchUserDataByUid(uid: uid)
                }
            }
        }
    }
    
    private func handleLogin(){
        coverView.isHidden=false
        timeRemaining=0
        self.timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeAction), userInfo: nil, repeats: true)
        guard let email = userAccount.text, let password = password.text else{
            print("Form is not vaild")
            return
        }
        
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                self.createAlert(title: "Error", message: error!.localizedDescription)
                self.coverView.isHidden=true
                print("\(error)")
                return
            }
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            print("\(uid)")
            
            if  FIRAuth.auth()?.currentUser?.uid == nil{
                print("Nothing ")
                return
            }else{
                if (FIRAuth.auth()?.currentUser?.isEmailVerified)!{
                    if self.dishDownloaded && self.restaurantDownloaded{
                        ModelManager.getInstance().filterDish()
                        self.fetchUserDataByUid(uid: uid!)
                    }else{
                        self.loginState=true
                    }
                }else{
                    self.coverView.isHidden=true
                    let alert = UIAlertController(title: "Please Confirm your email", message:"(^_^)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { _ in
                     FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                     return
                     })
                     }))
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        
                    })
                    self.present(alert, animated: true)
                }
            }
            
            
        })
        //Sucessfully login
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }


}

