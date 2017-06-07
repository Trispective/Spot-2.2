//
//  MenuTableViewCell.swift
//  Trispective
//
//  Created by USER on 2017/4/27.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit
protocol Step1: NSObjectProtocol {
    func step1()
    func showDish(d:Dish)
}


class MenuTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var restaurant=Restaurant()
    var count=0
    var dishes=[String:String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.backgroundColor=contentView.superview!.backgroundColor
        let proportion:CGFloat=0.0265
        collectionView.contentInset=UIEdgeInsets(top: DemoImage.frame.width*proportion,
                                                 left: DemoImage.frame.width*proportion,
                                                 bottom: DemoImage.frame.width*proportion,
                                                 right: DemoImage.frame.width*proportion)
        let layout=collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing=DemoImage.frame.width*proportion
        layout.minimumInteritemSpacing=DemoImage.frame.width*proportion

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCollectionView(){
        collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBAction func modifyCagegory(_ sender: UIButton) {

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "pendingCollectionCell", for: indexPath) as! PendingCollectionViewCell
        
        let url=restaurant.getDishUrlUnderCategory(dishes: dishes)[indexPath.row]
        cell.image.loadImageUsingCacheWithUrlString(url)
        
        switch restaurant.getDishState()[url]!{
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
        return CGSize(width: DemoImage.frame.width/2*0.92, height: DemoImage.frame.height*0.562/2*0.92)
    }
    
    weak var delegate:Step1?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url=restaurant.getDishUrlUnderCategory(dishes: dishes)[indexPath.row]

        if ModelManager.getInstance().restaurant.getId().isEmpty{
            delegate?.showDish(d: ModelManager.getInstance().getDishByUrl(url: url))
        }else{
            switch ModelManager.getInstance().restaurant.getDishState()[url]!{
            case "hide":
                ModelManager.getInstance().publishDish=ModelManager.getInstance().getDishByUrl(url: url)
                delegate?.step1()
            case "select":
                restaurant.changeState(k: url,value: "isSelected")
            case "isSelected":
                restaurant.changeState(k: url,value: "select")
            default:
                break
            }
        }

        
        collectionView.reloadData()
    }


}

extension UITableViewCell {
    //返回cell所在的UITableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}
