//
//  SideMenuController.swift
//  Trispective
//
//  Created by USER on 2017/4/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

protocol Segue: NSObjectProtocol {
    func segue(i:Int)
}

class SideMenuController:NSObject,UITableViewDelegate,UITableViewDataSource {
    weak var delegate:Segue?
    
    override init() {
        super.init()
        tableView.delegate=self
        tableView.dataSource=self
        
        tableView.register(MiddleCell.classForCoder(), forCellReuseIdentifier: "middleCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoImage.middleCellImage.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //dismiss sidebar
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha=0
            self?.menuView.frame.size.width=0
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate?.segue(i: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "middleCell", for: indexPath) as! MiddleCell
        
        cell.icons.image=UIImage(named: DemoImage.middleCellImage[indexPath.row])
        cell.textView.text=DemoImage.middleText[indexPath.row]
        
        
        return cell
    }
    
    let blackView=UIView()
    let menuView:UIView={
        let mv=UIView(frame: .zero)
        mv.backgroundColor=UIColor.white
        return mv
    }()
    
    let backgroundView=UIImageView()
    let avatarView=UIImageView()
    let userNameView=UILabel()
    let tableView=UITableView()
    func setSidebar() {
        if let window=UIApplication.shared.keyWindow{
            blackView.backgroundColor=UIColor(white: 0, alpha: 0.5)
            blackView.frame=window.frame
            blackView.alpha=0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissSidebar(_:))))
            
            menuView.frame=CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            menuView.clipsToBounds=true
            
            let h=0.7*window.frame.width*window.frame.width/window.frame.height
            backgroundView.frame=CGRect(x: 0, y: 0, width: window.frame.width*0.7, height: h)
            let cus=ModelManager.getInstance().customer
            if ModelManager.getInstance().getCoverData().isEmpty{
                let url=cus.getCoverImageurl()
                if !url.isEmpty{
                    backgroundView.loadImageUsingCacheWithUrlString(url)
                }else{
                    backgroundView.image=UIImage(named: "Display Photo Icon Default (Business)")
                }
            }else{
                backgroundView.image=UIImage(data: ModelManager.getInstance().getCoverData())
            }
            backgroundView.contentMode = .scaleToFill
            
            avatarView.frame.size=CGSize(width: backgroundView.frame.height/2, height: backgroundView.frame.height/2)
            avatarView.contentMode = .scaleAspectFit
            avatarView.center=backgroundView.center
            avatarView.backgroundColor=UIColor.white
            avatarView.layer.masksToBounds=true
            avatarView.layer.cornerRadius=avatarView.frame.height/2
            
            if ModelManager.getInstance().getAvatarData().isEmpty{
                let url=cus.getProfileImageurl()
                if !url.isEmpty{
                    avatarView.loadImageUsingCacheWithUrlString(url)
                }else{
                    avatarView.image=UIImage(named: "Profile Icon Default (Greyish Blue)")
                }
            }else{
                avatarView.image=UIImage(data: ModelManager.getInstance().getAvatarData())
            }
            backgroundView.addSubview(avatarView)
            
            userNameView.text=ModelManager.getInstance().customer.getName()
            userNameView.font=UIFont(name: DemoImage.font,size: 18)
            userNameView.textColor=UIColor.white
            userNameView.frame=CGRect(x: 0, y: backgroundView.frame.height*0.75, width: backgroundView.frame.width, height: backgroundView.frame.height*0.25)
            userNameView.textAlignment = .center
            backgroundView.addSubview(userNameView)
            
            menuView.addSubview(backgroundView)
            
            let middleView=UIView(frame: CGRect(x: 0, y: backgroundView.frame.height, width: backgroundView.frame.width, height: window.frame.height*0.74-h))
            
            tableView.frame=CGRect(x: 0, y: 0, width: middleView.frame.width, height: middleView.frame.height)
            tableView.rowHeight=middleView.frame.height/CGFloat(DemoImage.middleCellImage.count)
            tableView.separatorStyle = .none
            middleView.addSubview(tableView)
            
            menuView.addSubview(middleView)
            
            let downImageView=UIImageView(frame: CGRect(x: 0, y: window.frame.height*0.74, width: middleView.frame.width/2, height: window.frame.height*0.26/2))
            downImageView.center=CGPoint(x: middleView.frame.width/2, y: window.frame.height*0.87)
            downImageView.contentMode = .scaleAspectFit
            downImageView.image=UIImage(named: "TabSpot")
            
            //downView.addSubview(downImageView)
            
            menuView.addSubview(downImageView)
            
            
            window.addSubview(blackView)
            window.addSubview(menuView)
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.blackView.alpha=1
                self?.menuView.frame.size.width = window.frame.width*0.7
            })
        }
        
        
    }
    
    func dismissSidebar(_ gesture:UIGestureRecognizer){
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha=0
            self?.menuView.frame.size.width=0
        }
    }
    
    
}
