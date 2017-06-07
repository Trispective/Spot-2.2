//
//  PreferenceTableViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/30.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class PreferenceTableViewController: UITableViewController{
    var searchController:UISearchController!
    @IBOutlet weak var holdSearchBarView: UIView!
    @IBOutlet weak var locationSelectButton: UIButton!
    @IBOutlet weak var distanceSelectButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > -64{
            self.navigationController?.navigationBar.isHidden=true
        }else{
            self.navigationController?.navigationBar.isHidden=false

        }
    
        
    }
    
    @IBAction func distanceSelect(_ sender: UIButton) {
        if !ModelManager.getInstance().distanceButton{
            ModelManager.getInstance().distanceButton=true
            ModelManager.getInstance().locationButton=false
            distanceSelectButton.setImage(UIImage(named: "Select Icon (Teal)"), for: .normal)
            locationSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
            
            ModelManager.getInstance().preferDistance=Double(Int(distanceSlider.value)*1000)
        }else{
            ModelManager.getInstance().distanceButton=false
            distanceSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
            
            ModelManager.getInstance().preferDistance=0
        }
    }
    
    @IBAction func locationSelect(_ sender: UIButton) {
        if locationSelectButton.tag==0{
            ModelManager.getInstance().distanceButton=false
            ModelManager.getInstance().locationButton=true
            locationSelectButton.setImage(UIImage(named: "Select Icon (Teal)"), for: .normal)
            distanceSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
            
            ModelManager.getInstance().preferDistance=0
        }else{
            ModelManager.getInstance().locationButton=false
            locationSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notifyLocationSelect(){
        ModelManager.getInstance().distanceButton=false
        ModelManager.getInstance().locationButton=true
        locationSelectButton.setImage(UIImage(named: "Select Icon (Teal)"), for: .normal)
        distanceSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
        
        ModelManager.getInstance().preferDistance=0
    }
    
    func notifyRefresh(){
        locationSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
        distanceSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
        
        ModelManager.getInstance().preferDistance=0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyLocationSelect), name: ModelManager.getInstance().notifyLocationButtonSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifyRefresh), name: ModelManager.getInstance().notifyPreferenceTableViewRefresh, object: nil)
        
        distanceSelectButton.tag=0
        locationSelectButton.tag=0
        
        distanceSlider.minimumValue=1
        distanceSlider.maximumValue=50
        distanceSlider.value=10
        distanceLabel.text="10 Km"
        distanceSlider.isContinuous=true
        distanceSlider.addTarget(self, action: #selector(self.sliderDidChange), for: .valueChanged)

        tableView.separatorStyle = .none
        tableView.allowsSelection=false
    }
    
    func sliderDidChange(){
        ModelManager.getInstance().distanceButton=true
        ModelManager.getInstance().locationButton=false
        distanceSelectButton.setImage(UIImage(named: "Select Icon (Teal)"), for: .normal)
        locationSelectButton.setImage(UIImage(named: "Select Icon (Grey)"), for: .normal)
        
        distanceLabel.text="\(Int(distanceSlider.value)) Km"
        ModelManager.getInstance().preferDistance=Double(Int(distanceSlider.value)*1000)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row){
        case 0:
            return 150
        case 1:
            return 360
        case 2:
            return 150
        case 3:
            return 750
        case 4:
            return 370
        case 5:
            return 150
        default:
            break
        }
        return 44
    }

 
}
