//
//  SpotBusinessViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/2.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SpotBusinessViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    var dishState=[String]()
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteImage(_ sender: UIButton) {
        var i=0
        while(i<ModelManager.getInstance().restaurant.getPending().count){
            if dishState[i].contains("isSelected"){
                dishState.remove(at: i)
                let id=ModelManager.getInstance().restaurant.getPending()[i].getId()
                ModelManager.getInstance().removeDishFromPending(dishId: id)
                //remove in local database
                ModelManager.getInstance().restaurant.removePendingDish(id: id)
            }else{
                i += 1
            }
        }
        
        updateCollectionView()
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        if deleteButton.isHidden{
            deleteButton.isHidden=false
            for i in 0 ..< ModelManager.getInstance().restaurant.getPending().count{
                dishState[i]="select"
            }
            
        }else{
            deleteButton.isHidden=true
            for i in 0 ..< ModelManager.getInstance().restaurant.getPending().count{
                dishState[i]="hide"
            }
        }
        collectionView.reloadData()
    }
    
    @IBOutlet weak var selectbarHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyVIew: UIView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden=false
        self.tabBarController?.tabBar.tintColor=UIColor(red: 12/225, green: 206/225, blue: 148/225, alpha: 1)
        
        let attrs = [NSUnderlineStyleAttributeName :1]as [String :Any]
        let name=NSAttributedString(string: "View Public Profile", attributes: attrs)
        showProfileButton.setAttributedTitle(name, for: .normal)
        
        dishState.removeAll()
        for _ in 0 ..< ModelManager.getInstance().restaurant.getPending().count{
            dishState.append("hide")
        }
        
        if ModelManager.getInstance().restaurant.getPending().count==0{
            emptyVIew.isHidden=false
            selectbarHeight.constant=0
        }else{
            emptyVIew.isHidden=true
            selectbarHeight.constant=50
        }
        
        collectionView.reloadData()
        
        let res=ModelManager.getInstance().restaurant
        if ModelManager.getInstance().getAvatarData().isEmpty{
            let url=res.getProfileImageurl()
            if !url.isEmpty{
                restaurantImage.loadImageUsingCacheWithUrlString(url)
            }
        }else{
            restaurantImage.image=UIImage(data: ModelManager.getInstance().getAvatarData())
        }
        restaurantName.text=res.getName()
    }

    @IBOutlet weak var showProfileButton: UIButton!
    @IBAction func showProfile(_ sender: UIButton) {
        performSegue(withIdentifier: "showBusinessProfile", sender: nil)
    }
    
    func updateCollectionView(){
        deleteButton.isHidden=true
        
        dishState.removeAll()
        for _ in 0 ..< ModelManager.getInstance().restaurant.getPending().count{
            dishState.append("hide")
        }
        
        if ModelManager.getInstance().restaurant.getPending().count==0{
            emptyVIew.isHidden=false
            selectbarHeight.constant=0
        }else{
            emptyVIew.isHidden=true
            selectbarHeight.constant=50
        }

        collectionView.reloadData()
    }
    
    @IBOutlet weak var titleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DemoImage.frame=view.frame
        
        let titleString=NSMutableAttributedString(string: "Spot Business")
        let color1=UIColor(red: 0/225, green: 0/225, blue: 0/225, alpha: 1)
        let color2=UIColor(red: 30/225, green: 155/225, blue: 156/225, alpha: 1)
        titleString.addAttribute(NSForegroundColorAttributeName, value: color1, range: NSMakeRange(0, 4))
        titleString.addAttribute(NSForegroundColorAttributeName, value: color2, range: NSMakeRange(5, 8))
        titleButton.setAttributedTitle(titleString, for: .normal)
        //self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: DemoImage.font,size: 24)!,NSForegroundColorAttributeName: UIColor(red: 0/225, green: 0/225, blue: 0/225, alpha: 1)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollectionView), name: ModelManager.getInstance().notifyImageChanged, object: nil)
        
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.backgroundColor=view.backgroundColor
        let proportion:CGFloat=0.0265
        collectionView.contentInset=UIEdgeInsets(top: view.frame.width*proportion, left: view.frame.width*proportion, bottom: view.frame.width*proportion, right: view.frame.width*proportion)
        let layout=collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing=view.frame.width*proportion
        layout.minimumInteritemSpacing=view.frame.width*proportion
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ModelManager.getInstance().restaurant.getPending().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "pendingCollectionCell", for: indexPath) as! PendingCollectionViewCell
        let url=ModelManager.getInstance().restaurant.getPending()[indexPath.row].getUrl()
        cell.image.loadImageUsingCacheWithUrlString(url)
        switch dishState[indexPath.row] {
        case "hide":
            cell.boxImage.isHidden=true
        case "select":
            cell.boxImage.isHidden=false
            cell.boxImage.image=UIImage(named: "Rectangle 13")
        case "isSelected":
            cell.boxImage.isHidden=false
            cell.boxImage.image=UIImage(named: "Ticked Box Icon")
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: view.frame.height*0.562/2*0.92)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if deleteButton.isHidden{
            ModelManager.getInstance().publishDish=ModelManager.getInstance().restaurant.getPending()[indexPath.row]
            performSegue(withIdentifier: "showStep1", sender: nil)
        }else{
            if dishState[indexPath.row].contains("isSelected"){
                dishState[indexPath.row]="select"
            }else{
                dishState[indexPath.row]="isSelected"
            }
            
            collectionView.reloadData()
        }
    }

    @IBAction func showCamera(_ sender: UIButton) {
        
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
            case "showCamera" :
                let upComing=segue.destination as! CameraViewController
                upComing.image=image
                upComing.state="dish"
                
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
        
        self.performSegue(withIdentifier: "showCamera", sender: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
