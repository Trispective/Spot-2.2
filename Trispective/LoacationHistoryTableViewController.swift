//
//  LoacationHistoryTableViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/30.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class LoacationHistoryTableViewController: UITableViewController,UISearchBarDelegate {
    var searchController:UISearchController!
    func configureSearchController(){
        let resultViewController=storyboard?.instantiateViewController(withIdentifier: "result") as! SearchResultViewController
        searchController=UISearchController(searchResultsController: resultViewController)
        searchController.searchBar.delegate=self
        searchController.searchResultsUpdater=resultViewController
        
        //searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation=false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView=searchController.searchBar
        definesPresentationContext=true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section==0{
            return 1
        }else{
            return ModelManager.getInstance().historyLocation.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==0{
            return 40
        }else{
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0{
            let cell=UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.contentView.backgroundColor=tableView.backgroundColor
            cell.textLabel?.text="Previous Searches"
            cell.textLabel?.font=UIFont(name: DemoImage.font, size: 18)
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled=false
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! LocationHistoryTableViewCell
            cell.contentView.backgroundColor=tableView.backgroundColor
            if ModelManager.getInstance().historySelect[indexPath.row].contains("unselect"){
                cell.selectImage.image=UIImage(named: "Select Icon (Grey)")
            }else{
                cell.selectImage.image=UIImage(named: "Select Icon (Teal)")
            }
            cell.locationTitle.text=ModelManager.getInstance().historyLocation[indexPath.row]
            cell.locationDetail.text="Melbourne, Victoria, Australia(\(DemoImage.locations[ModelManager.getInstance().historyLocation[indexPath.row]]!))"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ModelManager.getInstance().selectHistory(i: indexPath.row)
        
        NotificationCenter.default.post(name: ModelManager.getInstance().notifyLocationButtonSelected, object: nil)

        
        tableView.reloadData()
    }

}
