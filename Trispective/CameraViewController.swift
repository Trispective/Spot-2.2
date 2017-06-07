//
//  CameraViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/5.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController{

    var height:CGFloat=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: DemoImage.fontSize)!]
        
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled=true
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panImage(_:))))
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchImage(_:))))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeight()
    }
    
    func setHeight(){
        if state.contains("businessBackground")
            || state.contains("businessAvatar")
            || state.contains("customerCover"){
            height=view.frame.width*view.frame.width/view.frame.height
        }else{
            height=view.frame.height*0.562
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addMaskLayout()
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        

        let px=(imageView.frame.width/2-view.frame.width/2+view.center.x-imageView.center.x)/imageView.frame.width
        let py=(imageView.frame.height/2-height/2+view.center.y-imageView.center.y)/imageView.frame.height
        
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: (image?.size.width)!*px, y: (image?.size.height)!*py, width: view.frame.width/scale, height: height/scale))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        if state.contains("dish"){
            let imageData=UIImageJPEGRepresentation(croppedImage, 0.1)
            ModelManager.getInstance().uploadDishImage(imageData: imageData!)
            if let navController=self.navigationController{
                navController.popViewController(animated: true)
            }
            
        }else if state.contains("customerAvatar") || state.contains("businessAvatar"){
            //image=croppedImage.roundCornersToCircle()
            //ModelManager.getInstance().setAvatarData(data: UIImageJPEGRepresentation(croppedImage.roundCornersToCircle()!, 0.1)!)
            let imageData=UIImageJPEGRepresentation(croppedImage, 0.1)
            ModelManager.getInstance().uploadImage(type: "profile", imageData: imageData!)
            ModelManager.getInstance().setAvatarData(data: imageData!)
            if let navController=self.navigationController{
                navController.popViewController(animated: true)
            }
            
        }else if state.contains("customerCover") || state.contains("businessBackground"){
            let imageData=UIImageJPEGRepresentation(croppedImage, 0.1)
            ModelManager.getInstance().uploadImage(type: "cover", imageData: imageData!)
            ModelManager.getInstance().setCoverData(data: imageData!)
            if let navController=self.navigationController{
                navController.popViewController(animated: true)
            }
        }

    }
    
    func addMaskLayout(){
        let masklayer = CAShapeLayer()
        
        masklayer.isOpaque = false
        masklayer.frame = view.frame
        var path:UIBezierPath=UIBezierPath()
        
        if state.contains("dish")
            || state.contains("businessBackground")
            || state.contains("businessAvatar")
            || state.contains("customerCover"){
            let squareRect = CGRect(x: 0, y: view.center.y-height/2, width: view.frame.width, height: height)
            path = UIBezierPath(rect: view.frame)
            path.append(UIBezierPath(rect: squareRect))
            path.close()
        }else if state.contains("customerAvatar"){
            let squareRect = CGRect(x: 0, y: view.center.y-view.frame.width/2, width: view.frame.width, height: view.frame.width)
            path=UIBezierPath(rect: view.frame)
            path.append(UIBezierPath(roundedRect: squareRect, cornerRadius: view.frame.width/2))
            path.close()
        }
        
        masklayer.path = path.cgPath
        
        masklayer.fillColor = UIColor(white:0,alpha:0.5).cgColor
        masklayer.fillRule = kCAFillRuleEvenOdd
        
        view.layer.addSublayer(masklayer)
    }
    
    var circleCenter=CGPoint()
    var state=""
    
    func pinchImage(_ gesture:UIPinchGestureRecognizer){
        switch gesture.state {
        case .changed:
            scale=scale*gesture.scale
            gesture.scale=1.0
            imageView.frame.size=CGSize(width: scale*originSize.width, height: scale*originSize.height)
            gesture.view?.center=view.center
            
        case .ended:
            if(scale<minScale){
                scale=minScale
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    gesture.view?.frame.size=CGSize(width: (self?.originSize)!.width*(self?.scale)!, height:(self?.originSize)!.height*(self?.scale)!)
                    gesture.view?.center=(self?.view.center)!
                })
            }
        default:
            break
        }
    }
    
    func panImage(_ gesture:UIPanGestureRecognizer ){
        let target=gesture.view!
        
        switch gesture.state{
        case .began:
            circleCenter=target.center
            
        case .changed:
            let translation=gesture.translation(in: self.view)
            target.center=CGPoint(x: circleCenter.x+translation.x,y: circleCenter.y+translation.y)
            
        case .ended:
            let topEdge=view.center.y-height/2
            let downEdge=view.center.y+height/2
            var offsetX:CGFloat=0
            var offsetY:CGFloat=0
            if target.center.x-target.frame.width/2>0{
                offsetX = -(target.center.x-target.frame.width/2)
            }
            if target.center.x+target.frame.width/2<view.frame.width{
                offsetX = view.frame.width-(target.center.x+target.frame.width/2)
            }
            if target.center.y-target.frame.height/2>topEdge{
                offsetY = -(target.center.y-target.frame.height/2-topEdge)
            }
            if target.center.y+target.frame.height/2<downEdge{
                offsetY = downEdge-(target.center.y+target.frame.height/2)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                target.center=CGPoint(x: target.center.x+offsetX, y: target.center.y+offsetY)
            })
            
        default: break
        }
    }

    
    
    var imageView=UIImageView()
    var minScale:CGFloat=1
    var originSize=CGSize()
    var scale:CGFloat=0
    var image:UIImage?{
        get{
            return imageView.image
        }
        set{

            imageView.image=newValue
            imageView.frame=CGRect(x: 0, y: 0, width: (newValue?.size.width)!, height: (newValue?.size.height)!)
            imageView.contentMode = .scaleToFill
            originSize=imageView.frame.size
            setHeight()

            if (image?.size.height)!*view.frame.width/(image?.size.width)!<height{
                scale=height/imageView.frame.height
                imageView.frame.size=CGSize(width: scale*imageView.frame.width, height: scale*imageView.frame.height)
                minScale=scale
            }else{
                scale=view.frame.width/imageView.frame.width
                imageView.frame.size=CGSize(width: scale*imageView.frame.width, height: scale*imageView.frame.height)
                minScale=scale
            }
            
            imageView.center=view.center
           
        }
    }

}
