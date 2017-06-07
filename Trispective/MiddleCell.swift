//
//  MiddleCell.swift
//  Trispective
//
//  Created by USER on 2017/4/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class MiddleCell: UITableViewCell {
    
    let textView=UILabel()
    let icons=UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "middleCell")
        if self.isEqual(nil){return;}
        self.contentView.backgroundColor=UIColor(red: 250/225, green: 235/225, blue: 214/225, alpha: 1)
        
        icons.frame=CGRect(x: 0, y: self.contentView.center.y/2, width: 0.3*self.contentView.frame.width, height: self.contentView.frame.height)
        icons.contentMode = .scaleAspectFit
        self.contentView.addSubview(icons)
        textView.frame=CGRect(x: 0.3*self.contentView.frame.width, y: self.contentView.center.y/2, width: 0.6*self.contentView.frame.width, height: self.contentView.frame.height)
        textView.font=UIFont(name: "Helvetica",size: 24)
        textView.textColor=UIColor(red: 20/225, green: 95/225, blue: 153/225, alpha: 1)
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
