//
//  ViewController.swift
//  Feeding Memo
//
//  Created by Mich W on 19/01/2019.
//  Copyright © 2019 Mich W. All rights reserved.
//

import UIKit
import CircleMenu
import fluid_slider

struct defaultsKeys {
    static let dataKey = "feedingDataKey"
}

struct consts {
    static let maxFeedingTime = CGFloat(90)
}
struct ApplcationData : Codable {
    let feedSessions: [FeedSession]
}
struct FeedSession : Codable {
    let end : Date
    let duration : DateInterval
    
    var jsonRepresentation: [String: Any] {
        return [
            "end" : end,
            "duration" : duration
        ]
    }
}


class TableViewController: UITableViewController, CircleMenuDelegate {
 
  
    //todo later adv structure
    let dic:[Date: String] = [:]
    
    
    var feedData : NSMutableArray = NSMutableArray.init()
    var slider: Slider = Slider()
    
    let formatter = DateFormatter()
    let sliderFormatter = NumberFormatter()
    
    let cellReuseIdentifier = "cell"
    let dataKey = "feedingArray"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initDataSource()
        
        //debug clear
        feedData.removeAllObjects()
        persistDataSource()
        self.tableView.reloadData()
        //end debug clear
        
        
        formatter.dateFormat = "HH:mm"
        
        sliderFormatter.maximumIntegerDigits = 3
        sliderFormatter.maximumFractionDigits = 0
        
        initComponents()
        
    }
    
    func initComponents(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        
        // circle button
        let button = CircleMenu(
            frame: CGRect(x: (view.frame.width / 2) - 25, y: view.frame.height - 100, width: 50, height: 50),
            normalIcon:"plus_filled",
            selectedIcon:"baby",
            buttonsCount: 2,
            duration: 0.35,
            distance: 110)
        button.subButtonsRadius = 30
        button.delegate = self
        button.startAngle = -50
        button.endAngle = 50
        button.layer.cornerRadius = button.frame.size.width / 2.0
        
        view.addSubview(button)
        
        
        //slider
        slider = Slider()
        slider.frame = CGRect(x: 25, y: view.frame.height - 200, width: view.frame.width - 50, height: 50)
        slider.attributedTextForFraction = { fraction in
           
            let string = (self.sliderFormatter.string(from: (fraction * consts.maxFeedingTime) as NSNumber) ?? "")
            return NSAttributedString(string: string)
        }
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "0"))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "90"))
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = .orange
        slider.valueViewColor = .white
       
        view.addSubview(slider)
        slider.isHidden = true;
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
        
        showTimeButton()
    }
    
    private func showTimeButton(){
        slider.isHidden = false;
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
    
    private func formatEntry(left : Bool) -> String{
        let sideText = left ? "Left" : "Right"
        let feedDuration = (slider.fraction * consts.maxFeedingTime) as NSNumber
        let feedDurationText = (self.sliderFormatter.string(from: feedDuration) ?? "")
        
        let feedText = "\(self.formatter.string(from: Date.init(timeInterval: (TimeInterval(Int(truncating: feedDuration) * -60)), since: Date()))) - \(self.formatter.string(from: Date())) \(sideText) \(feedDurationText) min"
        
        return feedText;
    }
    
    private func addLeft(){
        slider.didEndTracking = { (slider) -> () in
            slider.isHidden = true;
            self.feedData.add(self.formatEntry(left: true))
            self.persistDataSource()
            self.tableView.reloadData()
        }
      
        
    }
    private func  addRight(){
        slider.didEndTracking = { (slider) -> () in
            slider.isHidden = true;
            self.feedData.add(self.formatEntry(left: false))
            self.persistDataSource()
            self.tableView.reloadData()
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


