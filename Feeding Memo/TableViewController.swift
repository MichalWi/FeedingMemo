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
    static let maxFeedingTime = 90
}

struct tableViewConsts {
    static let bottomMargin : CGFloat = 150
    
    static let buttonSize : CGFloat = 50
}

class TableViewController: UITableViewController, CircleMenuDelegate {
 
    let Service = FeedingSessionService()
    
    
    var feedData : [FeedingSession] = []
    
    
    //UI
    var slider: Slider = Slider()
    var hint: UILabel = UILabel()
    
    
    let cellReuseIdentifier = "cellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reloadData()
        
        initComponents()
        
    }
    
    func initComponents(){
        tableView.delegate = self
        tableView.dataSource = self 
        
        
        // circle button
        let button = CircleMenu(
            frame: CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize/2), y: view.frame.height - tableViewConsts.bottomMargin, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize),
            normalIcon:"plus_filled",
            selectedIcon:"baby",
            buttonsCount: 2,
            duration: 0.2,
            distance: 110)
        button.subButtonsRadius = 30
        button.delegate = self
        button.startAngle = -50
        button.endAngle = 50
        button.layer.cornerRadius = button.frame.size.width / 2.0
        
        view.addSubview(button) 
        //slider
        
        slider = Slider()
        slider.frame = CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
        slider.attributedTextForFraction = { fraction in
            let string = "\(Int((fraction) * CGFloat(consts.maxFeedingTime))) min"
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
            
        }
        let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
       
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = .orange
        slider.valueViewColor = .white
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        
        slider.imagesColor = UIColor.white.withAlphaComponent(0.8)
        slider.valueViewColor = .white
        slider.setMinimumImage(#imageLiteral(resourceName: "past"))
        slider.setMaximumImage(#imageLiteral(resourceName: "future"))
       
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
        
        button.backgroundColor = .orange
        
      
        showHint(withText: "Select Side")
        
    }
    
    func showHint(withText text : String){
        
        hint.removeFromSuperview()
        hint = UILabel()
        hint.text = text
        let w = hint.intrinsicContentSize.width
        
        hint.frame = CGRect(x: ((self.view.frame.width / 2) - (w / 2)), y: (self.view.frame.height - tableViewConsts.bottomMargin + 50), width: view.frame.width, height: 50)
        
        view.addSubview(hint)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        configureAddingFeedingSession(side:  atIndex == 0 ? .Left : .Right)
       
        showTimeButton()
    }
    
    private func showTimeButton(){
        slider.isHidden = false
        
     
        showHint(withText: "Duration")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feedData.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : TableCellView = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableCellView
        let data = feedData[indexPath.row]
        
        cell.set(feedingSession: data) 
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
       
            let id = self.feedData[indexPath.row].Id
            self.Service.RemoveFeedingSession(id)
            
            reloadData()
            
        }
    }
    
    
    private func configureAddingFeedingSession(side : Side){
        slider.didEndTracking = { (slider) -> () in
            slider.isHidden = true;
            
            let newFeedingSession = FeedingSession.Create(side: side, duration: Int(slider.fraction * CGFloat(consts.maxFeedingTime)), endTime: Date())
            
            self.Service.AddFeedingSession(newFeedingSession)
            
            self.reloadData()
            
            self.hint.removeFromSuperview()
            
        }
    }
    
    
    private func persistDataSource(){
        
        let defaults = UserDefaults.standard
        defaults.set(self.feedData, forKey: defaultsKeys.dataKey);
    }
    
    private func reloadData(){
        
        feedData = Service.GetFeedingSessions()
        self.tableView.reloadData()
      
    }
}


