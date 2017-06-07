//
//  Step1ViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/6.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class Step1ViewController: UIViewController {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishTitle: UITextField!
    @IBOutlet weak var dishDescription: UITextField!
    
    @IBAction func gotoStep2(_ sender: UIButton) {
        let title=dishTitle.text!
        let des=dishDescription.text!
        
        if title.isEmpty || des.isEmpty{
            self.createAlert(title: "Warning", message: "Title and description of the dish can not be empty!")
        }else{
            ModelManager.getInstance().publishDish.setTitle(title: title)
            ModelManager.getInstance().publishDish.setDes(des: des)
            performSegue(withIdentifier: "showStep2", sender: nil)
        }
    }
    
    @IBAction func gotoPendingBoard(_ sender: UIButton) {
        if let navController=self.navigationController{
            navController.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
        
        let dish=ModelManager.getInstance().publishDish
        let url=dish.getUrl()
        dishImage.loadImageUsingCacheWithUrlString(url)
        
        if !dish.getType().isEmpty{
            dishTitle.text=dish.getTitle()
            dishDescription.text=dish.getDescription()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        let tap: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }
}
