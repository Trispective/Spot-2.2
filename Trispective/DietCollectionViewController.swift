//
//  DietCollectionViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class DietCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notifyRefresh(){
        diet.removeAll()
        for _ in 0 ..< 3{
            diet.append("unselect")
        }
        collectionView?.reloadData()
    }
    
    var diet=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyRefresh), name: ModelManager.getInstance().notifyPreferenceTableViewRefresh, object: nil)

        diet.removeAll()
        let dish=ModelManager.getInstance().publishDish
        for _ in 0 ..< 3{
            diet.append("unselect")
        }
        if !dish.getDiet().isEmpty{
            for i in 0 ..< DemoImage.diet.count{
                if DemoImage.diet[i].contains(dish.getDiet()){
                    diet[i]="selected"
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
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dietCell", for: indexPath) as! PreferenceCollectionViewCell
        
        // Configure the cell
        if diet.count>0 {
            if diet[indexPath.row].contains("unselect"){
                cell.selectImage.image=UIImage(named: "Select Icon (Grey)")
            }else{
                cell.selectImage.image=UIImage(named: "Select Icon (Teal)")
            }
        }
        
        cell.title.text=DemoImage.diet[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: 45)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ModelManager.getInstance().customer.getId().isEmpty{
            if diet[indexPath.row].contains("unselect"){
                diet.removeAll()
                for _ in 0 ..< 3{
                    diet.append("unselect")
                }
                diet[indexPath.row]="selected"
                ModelManager.getInstance().publishDish.setDiet(diet: DemoImage.diet[indexPath.row])
            }else{
                diet[indexPath.row]="unselect"
                ModelManager.getInstance().publishDish.setDiet(diet: "")
            }
        }else{
            if diet[indexPath.row].contains("unselect"){
                diet[indexPath.row]="selected"
            }else{
                diet[indexPath.row]="unselect"
            }
            ModelManager.getInstance().diet=diet
        }

        
        collectionView.reloadData()
    }





}
