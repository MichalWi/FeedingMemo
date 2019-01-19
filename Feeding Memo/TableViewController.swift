//
//  ViewController.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let dataKey = "feedingDataKey"
}

class TableViewController: UITableViewController {
 
  
    //todo later adv structure
    let dic:[Date: String] = [:]
    
    
    var feedData : NSMutableArray = NSMutableArray.init()
    let cellReuseIdentifier = "cell"
    let dataKey = "feedingArray"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initDataSource()
        
        //debug init remove
        initDebugData()
        
  
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
     
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feedData.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = feedData[indexPath.row] as? String
        
        return cell
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.feedData.removeObject(at: indexPath.row)
            self.persistDataSource();
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            
        }
    }
    
    private func initDebugData(){
        
        if feedData.count == 0 {
            feedData.addObjects(from: ["Horse", "Cow", "Camel", "Sheep", "Goat"])
            persistDataSource()
        }
    }
    
    private func persistDataSource(){
        
        let defaults = UserDefaults.standard
        defaults.set(self.feedData, forKey: defaultsKeys.dataKey);
    }
    
    private func initDataSource(){ 
        let defaults = UserDefaults.standard
        feedData = defaults.mutableArrayValue(forKey: defaultsKeys.dataKey);
    }
}


