//
//  LocationHistoryTableViewCell.swift
//  Trispective
//
//  Created by USER on 2017/4/30.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class LocationHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
