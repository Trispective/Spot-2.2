//
//  Step2TableViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/6.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class Step2TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection=false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row){
        case 0:
            return 150
        case 1:
            return 750
        case 2:
            return 370
        case 3:
            return 150
        default:
            break
        }
        return 44
    }

}
