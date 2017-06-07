//
//  ProfileForBusinessTableViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class ProfileForBusinessTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantType: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var state=""
    @IBAction func changeBackground(_ sender: UIButton) {
        state="cover"
        invokePhoto()
    }
    
    @IBAction func changeAvatar(_ sender: UIButton) {
        state="avatar"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let res=ModelManager.getInstance().restaurant
        
        avatarChanged()
        
        restaurantName.text=res.getName()
        restaurantType.text=res.getRestaurantType()
        descriptionLabel.text=res.getAboutUs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection=false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.avatarChanged), name: ModelManager.getInstance().notifyAvatarChanged, object: nil)
    }
    
    func avatarChanged(){
        let res=ModelManager.getInstance().restaurant

        if ModelManager.getInstance().getCoverData().isEmpty{
            let url=res.getCoverImageurl()
            if !url.isEmpty{
                backgroundImage.loadImageUsingCacheWithUrlString(url)
            }
        }else{
            backgroundImage.image=UIImage(data: ModelManager.getInstance().getCoverData())
        }
        
        if ModelManager.getInstance().getAvatarData().isEmpty{
            let url=res.getProfileImageurl()
            if !url.isEmpty{
              restaurantImage.loadImageUsingCacheWithUrlString(url)
            }  
        }else{
            restaurantImage.image=UIImage(data: ModelManager.getInstance().getAvatarData())
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        default:
            break
        }
        return 44
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "coverShowCamera" :
                let upComing=segue.destination as! CameraViewController
                upComing.image=image
                upComing.state="businessBackground"
            case "avatarShowCamera" :
                let upComing=segue.destination as! CameraViewController
                upComing.image=image
                upComing.state="businessAvatar"
                
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
        //choosedImgae = choosedImgae?.normalizedImage()
        if picker.sourceType == .camera && choosedImage?.imageOrientation != UIImageOrientation.up{
            //let imageTemp=UIImage(cgImage: (choosedImage?.cgImage)!, scale: (choosedImage?.scale)!, orientation: UIImageOrientation(rawValue: 3)!)
            //image=imageTemp
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
        //self.dismiss(animated: true, completion: nil)
        if state.contains("cover"){
            self.performSegue(withIdentifier: "coverShowCamera", sender: nil)
        }else{
            self.performSegue(withIdentifier: "avatarShowCamera", sender: nil)
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }



}
