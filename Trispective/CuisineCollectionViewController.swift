//
//  CuisineCollectionViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class CuisineCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var cuisine = [String]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notifyRefresh(){
        cuisine.removeAll()
        for _ in 0 ..< 25{
            cuisine.append("unselect")
        }
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyRefresh), name: ModelManager.getInstance().notifyPreferenceTableViewRefresh, object: nil)
        
        cuisine.removeAll()
        let dish=ModelManager.getInstance().publishDish
        for _ in 0 ..< 25{
            cuisine.append("unselect")
        }
        
        if !dish.getCuisine().isEmpty{
            for i in 0 ..< DemoImage.cuisine.count{
                if DemoImage.cuisine[i].contains(dish.getCuisine()){
                    cuisine[i]="selected"
                    break
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 25
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisineCell", for: indexPath) as! PreferenceCollectionViewCell
        
        // Configure the cell
        if cuisine.count>0 {
            if cuisine[indexPath.row].contains("unselect"){
                cell.selectImage.image=UIImage(named: "Select Icon (Grey)")
            }else{
                cell.selectImage.image=UIImage(named: "Select Icon (Teal)")
            }
        }

        
        cell.title.text=DemoImage.cuisine[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: 45)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ModelManager.getInstance().customer.getId().isEmpty{
            if cuisine[indexPath.row].contains("unselect"){
                cuisine.removeAll()
                for _ in 0 ..< 25{
                    cuisine.append("unselect")
                }
                cuisine[indexPath.row]="selected"
                ModelManager.getInstance().publishDish.setCuisine(cuisine: DemoImage.cuisine[indexPath.row])
            }else{
                cuisine[indexPath.row]="unselect"
                ModelManager.getInstance().publishDish.setCuisine(cuisine: "")
            }
        }else{
            if cuisine[indexPath.row].contains("unselect"){
                cuisine[indexPath.row]="selected"
            }else{
                cuisine[indexPath.row]="unselect"
            }
            ModelManager.getInstance().cuisine=cuisine
        }

        
        collectionView.reloadData()
    }


}
