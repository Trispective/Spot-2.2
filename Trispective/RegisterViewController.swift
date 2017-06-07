//
//  RegisterViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
    @IBAction func birthday(_ sender: UIButton) {
        let popoverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: self.view.frame.height*0.5))
        let datePicker=UIDatePicker(frame: CGRect(x: 0, y: 0, width: popoverView.frame.width, height: popoverView
            .frame.height))
        datePicker.datePickerMode=UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
        
        popoverView.addSubview(datePicker)
        popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        popover.alpha=0.85
        popover.popoverType = .Down
        popover.show(contentView: popoverView, fromView: sender)
    }
    
    var birthDayText=""
    func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy"
        birthDayText=dateFormatter.string(from: sender.date)
        birthdayButton.setTitleColor(UIColor.black, for: .normal)
        birthdayButton.setTitle(birthDayText, for: .normal)
        birthdayButton.titleLabel?.text=birthDayText
    }
    
    @IBAction func register(_ sender: UIButton) {
        if firstName.text!.isEmpty
            || lastName.text!.isEmpty
            || email.text!.isEmpty
            || password.text!.isEmpty
            || confirmPassword.text!.isEmpty
            || birthDayText.isEmpty{
            createAlert(title: "Warning", message: "Infomation is missing!")
            return
        }
        
        if password.text! != confirmPassword.text!{
            createAlert(title: "Warning", message: "Confirm your password!")
            return
        }
        
        handleRegister()
        
    }

    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        birthDayText=""
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }
    
    func registerAsCustomer(uid:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let userReference = ref.child("DF").child("Users").child(uid)
        let values = ["type":"customer","name": firstName.text!+" "+lastName.text!,"email": email.text!,
                      "profileImageurl":"","coverImageurl":"","favourites":["none":"none"],
                      "phoneNumber":"","dob": birthDayText,"description":""] as [String : Any]
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                self.createAlert(title: "Error", message: err!.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Please Check your email for confirmation", message:"(^_^)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true)
            
        })
        
    }
    
    func registerAsRestaurant(uid:String){
        let ref = FIRDatabase.database().reference(fromURL: "https://spotrmit.firebaseio.com/")
        let userReference = ref.child("DF").child("Users").child(uid)
        let values = ["type":"restaurant","name":"","email": email.text!,"profileImageurl":"","coverImageurl":"",
                      "phoneNumber":"","location":"","active":"","latitude":"0","longitude":"0",
                      "postCode":"","aboutUs":"","suburb":"","restaurantType":"",
                      "availableTime":"","abn":"","menu":["none":["none":"none"]],"pending":["none":"none"]] as [String : Any]
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                self.createAlert(title: "Error", message: err!.localizedDescription)
                return
            }
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            self.createAlert(title: "Register Successfully", message: "(^_^)")
        })
        
    }
    
    private func handleRegister(){
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user:FIRUser?, error) in
            if error != nil{
                self.createAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            //create user account sucessfully
            
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                    return
            })
            
            guard let uid = user?.uid else{
                return
            }
            
            self.registerAsCustomer(uid: uid)
            
            
            /*if self.email.text!.contains("cu"){
                self.registerAsCustomer(uid: uid)
            }else if self.email.text!.contains("black"){
                self.registerAsRestaurant(uid: uid)
            }*/
            
            
            
        })
        
    }

}
