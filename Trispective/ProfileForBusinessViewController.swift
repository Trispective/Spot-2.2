//
//  ProfileForBusinessViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class ProfileForBusinessViewController: UIViewController {

    @IBAction func gotoSetting(_ sender: UIButton) {
            self.performSegue(withIdentifier: "showSetting", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.automaticallyAdjustsScrollViewInsets=false
        
        self.tabBarController?.tabBar.isHidden=true
    }

}
