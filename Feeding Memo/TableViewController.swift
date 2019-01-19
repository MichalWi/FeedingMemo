//
//  ViewController.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import UIKit
import CircleMenu

struct defaultsKeys {
    static let dataKey = "feedingDataKey"
}

class TableViewController: UITableViewController, CircleMenuDelegate {
 
  
    //todo later adv structure
    let dic:[Date: String] = [:]
    
    
    var feedData : NSMutableArray = NSMutableArray.init()
    let cellReuseIdentifier = "cell"
    let dataKey = "feedingArray"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initDataSource()
        
        formatter.dateFormat = "HH:mm"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        let button = CircleMenu(
            frame: CGRect(x: (view.frame.width / 2) - 25, y: view.frame.height - 200, width: 50, height: 50),
            normalIcon:"plus_filled",
            selectedIcon:"baby",
            buttonsCount: 2,
            duration: 0.15,
            distance: 110)
        button.subButtonsRadius = 30
        button.delegate = self
        button.startAngle = -50
        button.endAngle = 50
        button.layer.cornerRadius = button.frame.size.width / 2.0 
      
        
        view.addSubview(button)
        
        
    } 
    
     func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if atIndex == 0 {
            button.setImage(#imageLiteral(resourceName: "left_footprint"), for: .normal)
        }
        if atIndex == 1{
            button.setImage(#imageLiteral(resourceName: "right_footprint"), for: .normal)
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        if atIndex == 0 {
            addLeft();
        }
        if atIndex == 1{
            addRight()
        }
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
    
    let formatter = DateFormatter()
   
    
    private func addLeft(){
        feedData.add("\(formatter.string(from: Date())) Lewa")
        persistDataSource()
        self.tableView.reloadData()
        
    }
    private func  addRight(){
        feedData.add("\(formatter.string(from: Date())) Prawa")
        persistDataSource()
        self.tableView.reloadData()
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


