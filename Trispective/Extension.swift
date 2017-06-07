//
//  Extension.swift
//  Trispective
//
//  Created by Jingting Li on 5/3/17.
//  Copyright © 2017 Trispective. All rights reserved.
//

import UIKit
import Firebase


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIButton{
    func loadImage(_ urlString: String){
        self.setImage(UIImage(), for: .normal)
        
        let spinner=UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        spinner.activityIndicatorViewStyle = .gray
        spinner.startAnimating()
        self.addSubview(spinner)
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.setImage(cachedImage, for: .normal)
            spinner.removeFromSuperview()
            return
        }
        
        //otherwise fire off a new download
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.setImage(downloadedImage, for: .normal)
                    spinner.removeFromSuperview()
                    
                }
            })
            
        }).resume()

    }
}

extension  UIImageView {
    
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        let spinner=UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        spinner.activityIndicatorViewStyle = .gray
        spinner.startAnimating()
        self.addSubview(spinner)
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            spinner.removeFromSuperview()
            return
        }
        
        //otherwise fire off a new download
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                    spinner.removeFromSuperview()
                    
                }
            })
            
        }).resume()
        
        
    }
    
    
}

extension LoginViewController{
    

    
    func fetchUserDataByUid(uid:String){
        
        FIRDatabase.database().reference().child("DF").child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot)
            
            let dictionary = snapshot.value as? [String:AnyObject]
            if dictionary != nil{
                guard let type = dictionary!["type"] else{
                    return
                }
                if type.contains("customer"){
                    ModelManager.getInstance().setCutomser(uid: uid, values: dictionary!)
                    self.performSegue(withIdentifier: "showSpot", sender: self)
                }else{
                    ModelManager.getInstance().setRestaurant(uid: uid, values: dictionary!)
                    self.performSegue(withIdentifier: "showRestaurant", sender: self)
                }
                
                
            }
        }, withCancel: nil)
        
    
    }
    
}

extension UIViewController{
    func createAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        })
        self.present(alert, animated: true)
    }
}




