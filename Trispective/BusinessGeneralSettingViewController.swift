//
//  BusinessGeneralSettingViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/23.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class BusinessGeneralSettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView=UIView()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoImage.businessGeneralSet.count
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
        cell.title.text=DemoImage.businessGeneralSet[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let alertController = UIAlertController(title: "About Us",message: "", preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = ModelManager.getInstance().restaurant.getAboutUs()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                action in
                
                let title=alertController.textFields!.first!.text!
                ModelManager.getInstance().setUserInfo(key: "aboutUs", value: title)
                ModelManager.getInstance().restaurant.setAboutUs(aboutUs: title)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        default:
            break
        }
    }

}
