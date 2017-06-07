//
//  SpotExplorerViewController.swift
//  Trispective
//
//  Created by USER on 2017/3/29.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SpotExplorerViewController: UIViewController,Segue{
    
    func avatarChanged() {
        sidebarButton.setImage(UIImage(data: ModelManager.getInstance().getAvatarData()), for: .normal)
    }
    
    @IBAction func search(_ sender: UIButton) {
        performSegue(withIdentifier: "showSearchView", sender: nil)
    }
    
    var index:Int=0{
        didSet{
            if ModelManager.getInstance().preferDishes.count>0{
                //image=UIImage(named: DemoImage.imageName[index])
                let url=ModelManager.getInstance().preferDishes[index].getUrl()
                imageView.loadImageUsingCacheWithUrlString(url)
            }
            
            //set imageView
//            imageView.center=circleCenter
//            let transform1=CGAffineTransform(translationX: circleCenter.x-imageView.center.x, y: circleCenter.y-imageView.center.y)
//            imageView.layer.setAffineTransform(transform1)
            
            //set RightImageView
//            if(index<ModelManager.getInstance().preferDishes.count-1){
//                //rightImageView.image=UIImage(named: DemoImage.imageName[index+1])
//                let url=ModelManager.getInstance().preferDishes[index+1].getUrl()
//                rightImageView.loadImageUsingCacheWithUrlString(url)
//            }
//            rightImageView.center=CGPoint(x: imageView.center.x+imageView.frame.width,y: imageView.center.y)
//            let transform2=CGAffineTransform(translationX: imageView.center.x+imageView.frame.width-rightImageView.center.x, y: 0)
//            rightImageView.layer.setAffineTransform(transform2)
            
            //set LeftImageView
//            if(index>0){
//                //leftImageView.image=UIImage(named: DemoImage.imageName[index-1])
//                let url=ModelManager.getInstance().preferDishes[index-1].getUrl()
//                leftImageView.loadImageUsingCacheWithUrlString(url)
//            }
//            leftImageView.center=CGPoint(x: imageView.center.x-imageView.frame.width,y: imageView.center.y)
//            let transform3=CGAffineTransform(translationX: imageView.center.x-imageView.frame.width-leftImageView.center.x, y: 0)
//            leftImageView.layer.setAffineTransform(transform3)
        }
    }
    
    var circleCenter=CGPoint()
    let rightImageView=UIImageView()
    let leftImageView=UIImageView()
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            
            //gestures
            let rightSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(_:)))
            rightSwipeGesture.direction = .right
            imageView.addGestureRecognizer(rightSwipeGesture)
            
            let leftSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
            leftSwipeGesture.direction = .left
            imageView.addGestureRecognizer(leftSwipeGesture)
            let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.tapImage(_:)))
            imageView.addGestureRecognizer(tapGesture)
            
            let downSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
            downSwipeGesture.direction = .down
            imageView.addGestureRecognizer(downSwipeGesture)
            
            let upSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
            upSwipeGesture.direction = .up
            imageView.addGestureRecognizer(upSwipeGesture)
            
            
            
//            let panGesture=UIPanGestureRecognizer(target: self, action: #selector(self.panImage(_:)))
//            panGesture.require(toFail: downSwipeGesture)
//            panGesture.require(toFail: upSwipeGesture)
//            panGesture.require(toFail: leftSwipeGesture)
//            panGesture.require(toFail: rightSwipeGesture)
//            imageView.addGestureRecognizer(panGesture)
        }
    }
    
    
    var image:UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.image=newValue
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showDishDetail" :
                let upComing=segue.destination as! DishDetailViewController
                upComing.dish=ModelManager.getInstance().preferDishes[index]
                
            default:
                break
            }
        }
    }
    
    func tapImage(_ gesture:UITapGestureRecognizer){
        performSegue(withIdentifier: "showDishDetail", sender: nil)
    }
    
    
    func panImage(_ gesture:UIPanGestureRecognizer){
        let target=gesture.view!
        
        switch gesture.state{
        case .began:
            circleCenter=target.center
            if index < ModelManager.getInstance().preferDishes.count-1{
                //rightImageView.image=UIImage(named: DemoImage.imageName[index+1])
                let url=ModelManager.getInstance().preferDishes[index+1].getUrl()
                rightImageView.loadImageUsingCacheWithUrlString(url)
            }
            
            if index>0{
                //leftImageView.image=UIImage(named: DemoImage.imageName[index-1])
                let url=ModelManager.getInstance().preferDishes[index-1].getUrl()
                leftImageView.loadImageUsingCacheWithUrlString(url)
            }
            
        case .ended:
            if target.center.x<circleCenter.x{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    let transform=CGAffineTransform(translationX: -target.frame.size.width+((self?.circleCenter.x)!-target.center.x), y: 0)
                    target.layer.setAffineTransform(transform)
                    self?.rightImageView.layer.setAffineTransform(transform)
                }, completion: { [weak self] (true) in
                    self?.index += 1
                })
                
                
            }else if target.center.x>circleCenter.x{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    let transform=CGAffineTransform(translationX: target.frame.size.width-(-(self?.circleCenter.x)!+target.center.x), y: 0)
                    target.layer.setAffineTransform(transform)
                    self?.leftImageView.layer.setAffineTransform(transform)
                    }, completion: { [weak self] (true) in
                        self?.index -= 1
                })
            }
            
            //target.center=circleCenter
            
        case .changed:
            let translation=gesture.translation(in: self.view)
            if (translation.x<0 && index<ModelManager.getInstance().preferDishes.count-1) || (translation.x>0 && index>0){
                imageView.center=CGPoint(x: circleCenter.x+translation.x,y: circleCenter.y)
                rightImageView.center=CGPoint(x: circleCenter.x+target.frame.size.width+translation.x,y: circleCenter.y)
                leftImageView.center=CGPoint(x: circleCenter.x-target.frame.size.width+translation.x,y: circleCenter.y)
            }
            
        default: break
        }
    }
    
    func swipeDown(_ gesture:UISwipeGestureRecognizer){
        let dish=ModelManager.getInstance().preferDishes[index]
        let formatter=DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now=Date()
        let date = formatter.string(from: now)
        ModelManager.getInstance().addFavouriteDish(dishID: dish.getId(), Date: date)
        ModelManager.getInstance().favouriteDishes.append(dish.getId())
        ModelManager.getInstance().customer.addFavouriteInDic(identity: dish.getId(), date: date)
        if ModelManager.getInstance().preferDishes.count>1{
            if index==ModelManager.getInstance().preferDishes.count-1{
                index-=1
                imageView.slideIn(i: 1)
                ModelManager.getInstance().preferDishes.remove(at: index+1)
            }else{
                index+=1
                imageView.slideIn(i: -1)
                
                ModelManager.getInstance().preferDishes.remove(at: index-1)
                index-=1
            }
            
            
        }
    }
    
    func swipeUp(_ gesture:UISwipeGestureRecognizer){
        print("up")
    }
    
    func swipeRight(_ gesture:UISwipeGestureRecognizer){
        if(index != 0){
            imageView.slideIn(i: 1)
            index -= 1
        }
    }
    
    func swipeLeft(_ gesture:UISwipeGestureRecognizer){
        if(index != ModelManager.getInstance().preferDishes.count-1){
            imageView.slideIn(i: -1)
            index += 1
            
            if index+5<ModelManager.getInstance().preferDishes.count{
                let iv=UIImageView()
                iv.loadImageUsingCacheWithUrlString(ModelManager.getInstance().preferDishes[index+5].getUrl())
            }
        }
    }
    
    @IBOutlet weak var backArrowButton: UIButton!
    @IBOutlet weak var forwardArrowButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var sidebarButton: UIButton!
    
    @IBAction func backArraowFunc(_ sender: UIButton) {
//        let frame=imageView.frame
//        
//        if index>0{
//            //leftImageView.image=UIImage(named: DemoImage.imageName[index-1])
//            let url=ModelManager.getInstance().preferDishes[index-1].getUrl()
//            leftImageView.loadImageUsingCacheWithUrlString(url)
//            leftImageView.center=CGPoint(x: imageView.center.x-imageView.frame.width,y: imageView.center.y)
//        }
        
        
        if(index != 0){
//            backArrowButton.isEnabled=false
//            forwardArrowButton.isEnabled=false
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
//                let transform=CGAffineTransform(translationX: (self?.imageView.frame.size.width)!, y: 0)
//                self?.imageView.layer.setAffineTransform(transform)
//                self?.leftImageView.layer.setAffineTransform(transform)
//                }, completion: { [weak self] (true) in
//                    self?.index -= 1
//                    self?.leftImageView.image=UIImage()
//                    self?.rightImageView.image=UIImage()
//                    self?.imageView.frame=frame
//                    self?.backArrowButton.isEnabled=true
//                    self?.forwardArrowButton.isEnabled=true
//            })
            imageView.slideIn(i: 1)
            index -= 1
        }
    }
    
    @IBAction func forwardArrowFunc(_ sender: UIButton) {
//        let frame=imageView.frame
//        
//        if index < ModelManager.getInstance().preferDishes.count-1{
//            //rightImageView.image=UIImage(named: DemoImage.imageName[index+1])
//            let url=ModelManager.getInstance().preferDishes[index+1].getUrl()
//            rightImageView.loadImageUsingCacheWithUrlString(url)
//            rightImageView.center=CGPoint(x: imageView.center.x+imageView.frame.width,y: imageView.center.y)
//        }
        
        if(index != ModelManager.getInstance().preferDishes.count-1){
//            forwardArrowButton.isEnabled=false
//            backArrowButton.isEnabled=false
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
//                let transform=CGAffineTransform(translationX: -(self?.imageView.frame.size.width)!, y: 0)
//                self?.imageView.layer.setAffineTransform(transform)
//                self?.rightImageView.layer.setAffineTransform(transform)
//                }, completion: { [weak self] (true) in
//                    self?.index += 1
//                    self?.leftImageView.image=UIImage()
//                    self?.rightImageView.image=UIImage()
//                    self?.imageView.frame=frame
//                    self?.forwardArrowButton.isEnabled=true
//                    self?.backArrowButton.isEnabled=true
//            })
            
            imageView.slideIn(i: -1)
            index += 1
            
            if index+5<ModelManager.getInstance().preferDishes.count{
                let iv=UIImageView()
                iv.loadImageUsingCacheWithUrlString(ModelManager.getInstance().preferDishes[index+5].getUrl())
            }
        }
    }
    
    @IBOutlet weak var showInfoButton: UIButton!
    @IBAction func showInfo(_ sender: UIButton) {
        
        if backArrowButton.alpha==0{
            showInfoButton.setImage(UIImage(named: "Arrow Icons Up (Black)"),for: .normal)
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.switchButtons(i: 1, valid: true)
            })
        }else{
            showInfoButton.setImage(UIImage(named: "Arrow Icons Down (Black)"), for: .normal)
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.switchButtons(i: 0, valid: false)
            })
        }
    }
    
    func switchButtons(i:CGFloat,valid:Bool){
        backArrowButton.alpha=i
        backArrowButton.isEnabled=valid
        forwardArrowButton.alpha=i
        forwardArrowButton.isEnabled=valid
        saveButton.alpha=i
        saveButton.isEnabled=valid
        //shareButton.alpha=i
        //shareButton.isEnabled=valid
    }
    
    let sideMenuController=SideMenuController()
    @IBAction func showSidebar(_ sender: UIButton) {
        sideMenuController.setSidebar()
        sideMenuController.delegate=self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=false
        self.tabBarController?.tabBar.tintColor=UIColor(red: 12/225, green: 206/225, blue: 148/225, alpha: 1)
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.navigationBar.alpha=1
        self.navigationController?.isNavigationBarHidden=false
        
        sidebarButton.layer.masksToBounds=true
        sidebarButton.layer.cornerRadius=sidebarButton.frame.height/2
        let cus=ModelManager.getInstance().customer
        if ModelManager.getInstance().getAvatarData().isEmpty{
            let url=cus.getProfileImageurl()
            if !url.isEmpty{
                //sidebarButton.imageView?.loadImageUsingCacheWithUrlString(url)
                sidebarButton.loadImage(url)
            }else{
                sidebarButton.setImage(UIImage(named: "Profile Icon Default (Greyish Blue)"), for: .normal)
            }
        }else{
            sidebarButton.setImage(UIImage(data: ModelManager.getInstance().getAvatarData()), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DemoImage.frame=view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(self.avatarChanged), name: ModelManager.getInstance().notifyAvatarChanged, object: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: 24)!,NSForegroundColorAttributeName: UIColor(red: 0/225, green: 0/225, blue: 0/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        
        circleCenter=imageView.center
        

        
        switchButtons(i: 0, valid: false)
        index=0
    }
    @IBAction func saveFavourite(_ sender: UIButton) {
        let dish=ModelManager.getInstance().preferDishes[index]
        let formatter=DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now=Date()
        let date = formatter.string(from: now)
        ModelManager.getInstance().addFavouriteDish(dishID: dish.getId(), Date: date)
        ModelManager.getInstance().favouriteDishes.append(dish.getId())
        ModelManager.getInstance().customer.addFavouriteInDic(identity: dish.getId(), date: date)
        
        if ModelManager.getInstance().preferDishes.count>1{
            if index==ModelManager.getInstance().preferDishes.count-1{
                index-=1
                imageView.slideIn(i: 1)
                ModelManager.getInstance().preferDishes.remove(at: index+1)
            }else{
                index+=1
                imageView.slideIn(i: -1)
                
                ModelManager.getInstance().preferDishes.remove(at: index-1)
                index-=1
            }
            
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //RightImageView
        rightImageView.frame.size=imageView.frame.size
        rightImageView.contentMode = .scaleToFill
        //rightImageView.image=UIImage(named: DemoImage.imageName[index+1])
        rightImageView.center=CGPoint(x: imageView.center.x+imageView.frame.size.width,y: imageView.center.y)
        
        //LeftImageView
        leftImageView.frame.size=imageView.frame.size
        leftImageView.contentMode = .scaleToFill
        //leftImageView.image=UIImage(named: DemoImage.imageName[index])
        leftImageView.center=CGPoint(x: imageView.center.x-imageView.frame.size.width,y: imageView.center.y)
        
        view.addSubview(rightImageView)
        view.addSubview(leftImageView)

        
    }
    
    func segue(i:Int){
        switch i {
        case 0:
            performSegue(withIdentifier: "showProfile", sender: nil)
        case 1:
            self.tabBarController?.selectedIndex=2
        case 2:
            performSegue(withIdentifier: "showSearchView", sender: nil)
        case 3:
            performSegue(withIdentifier: "showSetting", sender: nil)
            
        default:
            break
        }
    }

    

}

extension UIView {
    func slideIn(i:Int,duration: TimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            slideInTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInTransition.type = kCATransitionPush
        
        if i==1{
            slideInTransition.subtype = kCATransitionFromLeft
        }else{
            slideInTransition.subtype = kCATransitionFromRight
        }
        
        slideInTransition.duration = duration
        slideInTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInTransition, forKey: "slideInTransition")
    }
}
