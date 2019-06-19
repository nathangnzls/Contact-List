//
//  ViewController.swift
//  Contacts
//
//  Created by AndroidDev on 16/01/2018.
//  Copyright © 2018 Commude. All rights reserved.
//
import UIKit
import Alamofire
class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var refreshCtrl: UIRefreshControl!
    var name = [String]()
    var email = [String]()
    var address = [String]()
    var contact = [String]()
    var filteredName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        refreshCtrl = UIRefreshControl()
        refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshCtrl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshCtrl)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        let url = "https://api.androidhive.info/contacts/"
        let params:Parameters? = [:];
        request(url, method: .get, parameters: params, encoding: URLEncoding.httpBody , headers: nil).responseJSON(completionHandler: {
            response in
            if(response.result.isSuccess){
                let JSON = response.result.value as? [String: Any]
                let info : NSArray = JSON!["contacts"]! as! NSArray
                for i in 0..<info.count{
                    let name: String? = (info[i] as AnyObject).value(forKey: "name") as? String
                    let email: String? = (info[i] as AnyObject).value(forKey: "email") as? String
                    let address: String? = (info[i] as AnyObject).value(forKey: "address") as? String
                    let contact = (info[i] as AnyObject).value(forKey: "phone") as? [String:AnyObject]
                    self.name.append(name!)
                    self.email.append(email!)
                    self.address.append(address!)
                    self.contact.append(contact?["mobile"] as! String!)
                }
                self.filteredName = self.name
                self.tableView.separatorColor = UIColor.clear
                self.tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 11)
                self.tableView.estimatedRowHeight = 130.0
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.reloadData()
                self.refreshCtrl?.endRefreshing()
            }else if(response.result.isFailure){
                let alert = UIAlertController(title: "", message: "Error", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.name.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.name.text = self.name[indexPath.row]
        cell.email.text = self.email[indexPath.row]
        cell.address.text = self.address[indexPath.row]
        cell.contact.text = self.contact[indexPath.row]

        return (cell)
    }
    @objc func refresh(sender:AnyObject) {
        self.tableView.reloadData()
        self.refreshCtrl?.endRefreshing()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.name = searchText.isEmpty ? self.filteredName : self.filteredName.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.refreshCtrl.endRefreshing()
        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
        self.refreshCtrl?.endRefreshing()
    }
}

