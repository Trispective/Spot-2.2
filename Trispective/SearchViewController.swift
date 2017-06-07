//
//  SearchViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/19.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    var filteredArray=[Restaurant]()
    var searchController:UISearchController!
    
    func configureSearchController(){
        //let resultViewController=storyboard?.instantiateViewController(withIdentifier: "result") as! SearchResultViewController
        searchController=UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate=self
        searchController.searchResultsUpdater=self
        
        //searchController.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation=true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.sizeToFit()
        definesPresentationContext=true
        tableView.tableHeaderView=searchController.searchBar
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let wholeArray=ModelManager.getInstance().allRestaurants
        filteredArray.removeAll()
        for i in 0 ..< wholeArray.count{
            if wholeArray[i].getName().lowercased().contains(searchText.lowercased()){
                filteredArray.append(wholeArray[i])
            }
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController != nil{
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredArray.count
            }
        }
        
        return ModelManager.getInstance().allRestaurants.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchController.isActive && searchController.searchBar.text != ""{
            restaurant=filteredArray[indexPath.row]
        }else{
            restaurant=ModelManager.getInstance().allRestaurants[indexPath.row]
        }
        valid=false
        performSegue(withIdentifier: "showRestaurant", sender: nil)
    }
    
    var restaurant=Restaurant()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showRestaurant" :
                let upComing=segue.destination as! BusinessProfileViewController
                upComing.restaurant=restaurant
            default:
                break
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.contentView.backgroundColor=tableView.backgroundColor
        let res:Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            res=filteredArray[indexPath.row]
        }else{
            res=ModelManager.getInstance().allRestaurants[indexPath.row]
        }
        
        if !res.getProfileImageurl().isEmpty{
            cell.searchImage.loadImageUsingCacheWithUrlString(res.getProfileImageurl())
        }else{
            cell.searchImage.image=UIImage(named: "Polo Bar Restaurant")
        }
        cell.searchLabel.text=res.getName()
        cell.cellHeight.constant=0.3*view.frame.width*view.frame.width/view.frame.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if valid{
           _=self.navigationController?.popToRootViewController(animated: false)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets=false
        tableView.tableFooterView=UIView()
        configureSearchController()
    }
    
    var valid=true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valid=true
        self.tabBarController?.tabBar.isHidden=true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }

}
