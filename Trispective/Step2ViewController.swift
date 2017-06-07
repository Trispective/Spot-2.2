//
//  Step2ViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/6.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class Step2ViewController: UIViewController {

    @IBOutlet weak var dishImage: UIImageView!
    @IBAction func gotoStep3(_ sender: UIButton) {
        let dish=ModelManager.getInstance().publishDish
        if dish.getType().isEmpty
            || dish.getCuisine().isEmpty{
            self.createAlert(title: "Warning", message: "Please complete meal type and cuisine before going to next step.")
        }else{
            performSegue(withIdentifier: "showStep3", sender: nil)
        }
    }
    
    @IBAction func gotoPending(_ sender: UIButton) {
        _=self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url=ModelManager.getInstance().publishDish.getUrl()
        dishImage.loadImageUsingCacheWithUrlString(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!,NSForegroundColorAttributeName: UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item

        // Do any additional setup after loading the view.
    }

}
