//
//  SearchResultViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/17.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    var searchController:UISearchController!
    var filteredArray=[String]()
    var wholeArray=[String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        wholeArray.removeAll()
        for (key,value) in DemoImage.locations{
            let string=value+key
            wholeArray.append(string)
        }
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchController=searchController
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArray = wholeArray.filter({ (location) -> Bool in
            return location.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredArray.count==0{
            return 1
        }
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if filteredArray.count>0{
            var k=filteredArray[indexPath.row] as NSString
            k=k.substring(from: 4) as NSString
            ModelManager.getInstance().selectHistory(i: ModelManager.getInstance().historyIndex)
            ModelManager.getInstance().addHistory(key: k as String)
            NotificationCenter.default.post(name: ModelManager.getInstance().notifyLocationButtonSelected, object: nil)
            
            searchController.isActive=false
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! LocationHistoryTableViewCell
        cell.contentView.backgroundColor=tableView.backgroundColor
        
        if searchController.isActive{
            if filteredArray.count==0{
                cell.locationTitle.text="'"+searchController.searchBar.text!+"'"+" coming soon!"
                cell.locationDetail.text=""
                return cell
            }else{
                var key=filteredArray[indexPath.row] as NSString
                key=key.substring(from: 4) as NSString
                cell.locationTitle.text=key as String
                cell.locationDetail.text="Melbourne, Victoria, Australia(\(DemoImage.locations[key as String]!))"
                
                return cell
            }
        }
        
        
        return cell

        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }



}
