//
//  BusinessSettingViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/12.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit
import Firebase

class BusinessSettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView=UIView()
        
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.alpha=1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return DemoImage.businessSet1.count
        case 1:
            return DemoImage.businessSet2.count
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v=UIView()
        v.backgroundColor=tableView.backgroundColor
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.title.text=DemoImage.businessSet1[indexPath.row]
        case 1:
            cell.title.text=DemoImage.businessSet2[indexPath.row]
        case 2:
            cell.title.text="Log out"
            cell.title.textAlignment = .center
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if indexPath.row==0{
                if ModelManager.getInstance().customer.getId().isEmpty{
                    performSegue(withIdentifier: "showBusinessGeneral", sender: nil)
                }else{
                   performSegue(withIdentifier: "showCustomerGeneral", sender: nil)
                }
            }else if indexPath.row==1{
                let alertController = UIAlertController(title: "Change Password",message: "", preferredStyle: .alert)
                alertController.addTextField {
                    (textField: UITextField!) -> Void in
                    textField.isSecureTextEntry=true
                    textField.placeholder = "New Password"
                }
                alertController.addTextField {
                    (textField: UITextField!) -> Void in
                    textField.isSecureTextEntry=true
                    textField.placeholder = "Confirm New Password"
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                    action in
                    
                    let new1=alertController.textFields!.first!.text!
                    let new2=alertController.textFields!.last!.text!
                    if new1 == new2{
                        self.setNewPassword(newPassword: new1)
                        
                    }else{
                        self.createAlert(title: "Failed", message: "Please confirm your new password!")
                    }
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        case 2:
            ModelManager.getInstance().setAvatarData(data: Data())
            ModelManager.getInstance().setCoverData(data: Data())
            ModelManager.getInstance().customer=Customer()
            ModelManager.getInstance().restaurant=Restaurant()
            ModelManager.getInstance().publishDish=Dish()
            handleLogout()
            
            self.tabBarController?.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func handleLogout(){
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
    }
    
    func setNewPassword(newPassword:String){
        FIRAuth.auth()?.currentUser?.updatePassword(newPassword) { (error) in
            if error != nil{
                self.createAlert(title: "Failed", message: (error?.localizedDescription)!)
                return
            }else{
                self.createAlert(title: "Success", message: "Password has been changed.")
            }
        }
    }
    

}
