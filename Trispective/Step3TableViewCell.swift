//
//  Step3TableViewCell.swift
//  Trispective
//
//  Created by USER on 2017/5/6.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class Step3TableViewCell: UITableViewCell {

    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
