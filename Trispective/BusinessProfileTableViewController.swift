//
//  BusinessProfileTableViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/15.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class BusinessProfileTableViewController: UITableViewController{
    var restaurant=Restaurant()
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func call(_ sender: UIButton) {
        print("call")
    }
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var availableTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection=false
        
        if !restaurant.getCoverImageurl().isEmpty{
            backgroundImageView.loadImageUsingCacheWithUrlString(restaurant.getCoverImageurl())
        }
        if !restaurant.getProfileImageurl().isEmpty{
            restaurantImageView.loadImageUsingCacheWithUrlString(restaurant.getProfileImageurl())
        }
        
        restaurantNameLabel.text=restaurant.getName()
        restaurantTypeLabel.text=restaurant.getType()
        descriptionLabel.text=restaurant.getAboutUs()
        callButton.setTitle(restaurant.getPhoneNumber(), for: .normal)
        availableTimeLabel.text=restaurant.getAvailableTime()
        locationLabel.text=restaurant.getLocation()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row){
        case 0:
            let h=tableView.superview?.superview?.frame.height
            let w=tableView.superview?.superview?.frame.width

            return 1.2*w!*w!/h!
        case 1:
            return 80
        case 2:
            let myAttribute = [ NSFontAttributeName: UIFont(name: DemoImage.font, size: 20)! ]
            let myString = NSMutableAttributedString(string: descriptionLabel.text!, attributes: myAttribute )
            return myString.heightWithConstrainedWidth(width: tableView.frame.width*0.95)
        case 3:
            return 40
        case 4:
            return 34
        case 5:
            return 30
        default:
            break
        }
        return 44
    }

}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
