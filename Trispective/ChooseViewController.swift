//
//  ChooseViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/22.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {

    @IBAction func foodie(_ sender: UIButton) {
        performSegue(withIdentifier: "showRegisterView", sender: nil)
    }
    
    @IBAction func buisiness(_ sender: UIButton) {
        let url=URL(string: "http://35.185.182.47/sign_up.html")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
