//
//  MealTypeCollectionViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class MealTypeCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var mealTypeState=[String]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notifyRefresh(){
        mealTypeState.removeAll()
        for _ in 0 ..< 4{
            mealTypeState.append("unselect")
        }
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyRefresh), name: ModelManager.getInstance().notifyPreferenceTableViewRefresh, object: nil)
        
        mealTypeState.removeAll()
        for _ in 0 ..< 4{
            mealTypeState.append("unselect")
        }
        let dish=ModelManager.getInstance().publishDish
        if !dish.getType().isEmpty{
            for i in 0 ..< DemoImage.mealType.count{
                if DemoImage.mealType[i].contains(dish.getType()){
                    mealTypeState[i]="selected"
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
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mealTypeCell", for: indexPath) as! PreferenceCollectionViewCell
    
        // Configure the cell
        if mealTypeState.count>0 {
            if mealTypeState[indexPath.row].contains("unselect"){
                cell.selectImage.image=UIImage(named: "Select Icon (Grey)")
            }else{
                cell.selectImage.image=UIImage(named: "Select Icon (Teal)")
            }
        }
        cell.title.text=DemoImage.mealType[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: 45)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ModelManager.getInstance().customer.getId().isEmpty{
            if mealTypeState[indexPath.row].contains("unselect"){
                mealTypeState.removeAll()
                for _ in 0 ..< 4{
                    mealTypeState.append("unselect")
                }
                mealTypeState[indexPath.row]="selected"
                ModelManager.getInstance().publishDish.setType(type: DemoImage.mealType[indexPath.row])
            }else{
                mealTypeState[indexPath.row]="unselect"
                ModelManager.getInstance().publishDish.setType(type: "")
            }
        }else{
            if mealTypeState[indexPath.row].contains("unselect"){
                mealTypeState[indexPath.row]="selected"
            }else{
                mealTypeState[indexPath.row]="unselect"
            }
            ModelManager.getInstance().mealTypeState=self.mealTypeState
        }
        
        collectionView.reloadData()
    }

}
