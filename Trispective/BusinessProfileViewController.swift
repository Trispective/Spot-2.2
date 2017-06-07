//
//  BusinessProfileViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/15.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class BusinessProfileViewController: UIViewController {
    @IBAction func showMenu(_ sender: UIButton) {
        performSegue(withIdentifier: "showMenu", sender: nil)
    }
    @IBAction func showMap(_ sender: UIButton) {
        performSegue(withIdentifier: "showMap", sender: nil)
    }
    var restaurant=Restaurant()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // To delete the white space of tableview
        self.automaticallyAdjustsScrollViewInsets=false
        
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.navigationBar.alpha=1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showDetail" :
                if let vc=segue.destination as? BusinessProfileTableViewController{
                    vc.restaurant=restaurant
                }
            case "showMenu":
                if let vc=segue.destination as? MenuViewController{
                    vc.restaurant=restaurant
                }
            case "showMap":
                if let vc=segue.destination as? MapViewController{
                    vc.restaurant=restaurant
                }
            default:
                break
            }
        }

        
        
    }
}
