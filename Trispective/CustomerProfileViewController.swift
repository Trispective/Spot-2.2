//
//  CustomerProfileViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/12.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class CustomerProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editBackgroundButton: UIButton!
    @IBOutlet weak var editAvatarButton: UIButton!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.avatarChanged), name: ModelManager.getInstance().notifyAvatarChanged, object: nil)
        
        backgroundHeight.constant=view.frame.width*view.frame.width/view.frame.height
        avatar.frame.size.width=view.frame.width*0.35
        avatar.frame.size.height=avatar.frame.width
        avatar.layer.masksToBounds=true
        avatar.layer.cornerRadius=avatar.layer.frame.width/2
        avatar.clipsToBounds=true

        
        helpView.frame.size.width=avatar.frame.width
        helpView.frame.size.height=helpView.frame.width
        helpView.layer.masksToBounds=true
        helpView.layer.cornerRadius=helpView.layer.frame.width/2
        helpView.clipsToBounds=true
        
        let cus=ModelManager.getInstance().customer
        nameLabel.text=cus.getName()
        descriptionLabel.text=cus.getDes()
        locationLabel.text=cus.getLoc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=true
        
        //self.navigationController?.navigationBar.tintColor=UIColor.white
        self.navigationController?.navigationBar.alpha=0.4
        
        avatarChanged()
    }
    
    @IBAction func gotoSetting(_ sender: UIButton) {
        performSegue(withIdentifier: "showSetting", sender: nil)
    }
    
    func avatarChanged(){
        let cus=ModelManager.getInstance().customer
        if ModelManager.getInstance().getCoverData().isEmpty{
            let url=cus.getCoverImageurl()
            if !url.isEmpty{
                background.loadImageUsingCacheWithUrlString(url)
            }
        }else{
            background.image=UIImage(data: ModelManager.getInstance().getCoverData())
        }
        
        if ModelManager.getInstance().getAvatarData().isEmpty{
            let url=cus.getProfileImageurl()
            if !url.isEmpty{
                avatar.loadImageUsingCacheWithUrlString(url)
            } 
        }else{
            avatar.image=UIImage(data: ModelManager.getInstance().getAvatarData())
        }
    }
    
    var state=""
    @IBAction func editAvatar(_ sender: UIButton) {
        state="avatar"
        invokePhoto()
    }
    
    @IBAction func editBackground(_ sender: UIButton) {
        state="cover"
        invokePhoto()
    }
    
    func invokePhoto(){
        let alertSheet=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Photo Library", style: .default){ _ in
            self.libraryAction()
        })
        
        alertSheet.addAction(UIAlertAction(title: "Camera", style: .default){ _ in
            self.cameraAction()
        })
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
            
        })
        
        self.present(alertSheet,animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "avatarShowCamera" :
                let upComing=segue.destination as! CameraViewController
                upComing.image=image
                upComing.state="customerAvatar"
            case "coverShowCamera" :
                let upComing=segue.destination as! CameraViewController
                upComing.image=image
                upComing.state="customerCover"
                
            default:
                break
            }
        }
    }
    
    func cameraAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil)
        }
        
        
    }
    
    func libraryAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil)
        }
    }
    var image=UIImage()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let choosedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if picker.sourceType == .camera{
            image=choosedImage!
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
            let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
            
            let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            image=normalizedImage
        }else{
            image = choosedImage!
        }
        
        if state.contains("cover"){
            self.performSegue(withIdentifier: "coverShowCamera", sender: nil)
        }else{
            self.performSegue(withIdentifier: "avatarShowCamera", sender: nil)
        }
        
        self.dismiss(animated: true, completion: nil)
    }


}
