//
//  CategoryCollectionViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit
class CategoryCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notifyRefresh(){
        category.removeAll()
        for _ in 0 ..< 11{
            category.append("unselect")
        }
        collectionView?.reloadData()
    }
    
    var category=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyRefresh), name: ModelManager.getInstance().notifyPreferenceTableViewRefresh, object: nil)
        
        category.removeAll()
        let dish=ModelManager.getInstance().publishDish
        for _ in 0 ..< 11{
            category.append("unselect")
        }
        
        if !dish.getCategory().isEmpty{
            for i in 0 ..< DemoImage.searchCategory.count{
                if DemoImage.searchCategory[i].contains(dish.getCategory()){
                    category[i]="selected"
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
        return 11
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! PreferenceCollectionViewCell
        
        // Configure the cell
        if category.count>0 {
            if category[indexPath.row].contains("unselect"){
                cell.selectImage.image=UIImage(named: "Select Icon (Grey)")
            }else{
                cell.selectImage.image=UIImage(named: "Select Icon (Teal)")
            }
        }
        
        cell.title.text=DemoImage.searchCategory[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: 45)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ModelManager.getInstance().customer.getId().isEmpty{
            if category[indexPath.row].contains("unselect"){
                category.removeAll()
                for _ in 0 ..< 11{
                    category.append("unselect")
                }
                category[indexPath.row]="selected"
                ModelManager.getInstance().publishDish.setCategory(category: DemoImage.searchCategory[indexPath.row])
            }else{
                category[indexPath.row]="unselect"
                ModelManager.getInstance().publishDish.setCategory(category: "")
            }
        }else{
            if category[indexPath.row].contains("unselect"){
                category[indexPath.row]="selected"
            }else{
                category[indexPath.row]="unselect"
            }
            ModelManager.getInstance().category=category
        }

        
        collectionView.reloadData()
    }



}
