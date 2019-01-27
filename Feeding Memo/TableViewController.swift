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
import SwiftDate
import UserNotifications

struct tableViewConsts {
    static let bottomMargin : CGFloat = 85
    
    static let buttonSize : CGFloat = 50
}

class TableViewController: UITableViewController, CircleMenuDelegate {
    
    
    let DB = FeedingSessionService()
    
    let reminderService = ReminderService()
    
    @IBAction func ReminderSwitchDidChange(_ sender: Any) {
        if RemindSwitch.isOn {
            reminderService.addFeedingReminder(toSession: feedData.first)
        } else {
            reminderService.removeReminder()
        }
        updateIntervalLabel()
    }
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var RemindSwitch: UISwitch!
    
    
    
    var feedData : [FeedingSession] = []
    var sections : [MonthSection] = []
    
    @IBOutlet weak var nextFeedingCountdownLabel: UILabel!
    
    //UI
    @IBOutlet weak var NextFeedingTimeSwitchLabel: UILabel!
    var slider: Slider!
    var maskView: UIView!
    var hint: UILabel?
    var titSelector : UITitSelector!
    
    
    let cellReuseIdentifier = "cellId"
    let placeholderCellReuseIdentifier = "placeholderCellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reloadDataSource()
        
        initComponents()
        
        
    }
    
    fileprivate func reloadDataSource(){
        self.feedData = self.DB.GetFeedingSessions()
        
        let groups = Dictionary(grouping: self.feedData) { (feedingSession:FeedingSession) in
            return firstDayOfMonth(date: feedingSession.EndTime)
        }
        
        self.sections = groups.map { (arg) -> MonthSection in
            let (key, values) = arg
            return MonthSection(day: key, feeding: values)
            }.sorted()
        
        
        
    }
    
    fileprivate func firstDayOfMonth(date : Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section =  self.sections[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD MMMM yyyy"
        return dateFormatter.string(from: section.day)
    }
    
    func updateIntervalLabel () {
        reminderService.getNextReminderTime() { intervalText in
            
            DispatchQueue.main.async {
                
                self.RemindSwitch.isOn = intervalText != nil
                
                if let interval = intervalText {
                    self.nextFeedingCountdownLabel.text = "\(interval)"
                }
                else
                {
                    if(self.feedData.count > 0){
                        self.nextFeedingCountdownLabel.text = FeedingTime(feedingSession: self.feedData.first!).redableNextFeedingInterval()
                    }else{
                         self.nextFeedingCountdownLabel.text = FeedingTime.defaultRedableNextFeedingTime()
                    }
                  
                }
            }
        }
        
    }
    
    func initComponents(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 15,left: 0,bottom: 0,right: 0)
        
        // reminder
        updateIntervalLabel()
        
        
        //drawer
        maskView = MaskView(
            frame: CGRect(x: 0, y: view.frame.height - 160, width: view.frame.width , height: 140))
        
        view.addSubview(maskView)
        
        // circle button
        titSelector = UITitSelector(
            frame: CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize/2), y: view.frame.height - tableViewConsts.bottomMargin, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize))
        
        titSelector.delegate = self
        
        
        view.addSubview(titSelector)
        
        
        //slider
        slider = DurationSlider(frame : CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin - 50, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
        )
        
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
        
        button.backgroundColor = .gray
        
        
        showHint(withText: "Select Side")
        maskView.fadeIn()
        
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        showTimeButton()
        
        configureAddingFeedingSession(side:  atIndex == 0 ? .Left : .Right)
        
    }
    
    func showHint(withText text : String){
        
        if(hint != nil){
            hint!.removeFromSuperview()
        }
        
        hint = UILabel()
        
        hint!.removeFromSuperview()
        
        hint!.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium), .foregroundColor: UIColor.black])
        
        let w = hint!.intrinsicContentSize.width
        
        hint!.frame = CGRect(x: ((self.view.frame.width / 2) - (w / 2)), y: (self.view.frame.height - tableViewConsts.bottomMargin + 40) + tableView.contentOffset.y, width: view.frame.width, height: 50)
        
        view.addSubview(hint!)
    }
    
    
    private func showTimeButton(){
        slider.isHidden = false
        titSelector.isHidden = true
        showHint(withText: "Set Duration")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = self.sections[section]
        return section.feeding.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 0){
            return 40
        }else{
            return 10
        }
        
    }
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = self.sections[indexPath.section]
        let data = section.feeding[indexPath.row]
        
        let cell : TableCellView = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableCellView
        
        let allFeeds = feedData.sorted {
            $0.EndTime < $1.EndTime
        }
        
        let index = allFeeds.firstIndex {
            $0.Id == data.Id
        }
        
        var endTime = Date()
        if(index != nil && index! > 0 && allFeeds.count != index ){
            
            let prev = allFeeds[index! - 1]
            endTime = prev.EndTime
        }
        
        
        cell.set(feedingSession: data, prevFeeding: endTime)
        
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return slider?.isHidden ?? true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let id = self.feedData[indexPath.row].Id
            self.DB.RemoveFeedingSession(id)
            reloadDataSource()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.tableView.reloadData()
                
            })
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let dy = scrollView.contentOffset.y
        if(titSelector == nil) {
            return
        }
        titSelector.frame =
            CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize/2), y: view.frame.height - tableViewConsts.bottomMargin + dy, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize)
        
        maskView.frame =
            CGRect(x: 0, y: view.frame.height - 160 + dy + 20, width: view.frame.width , height: 140)
        
        slider.frame =
            CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin - 50 + dy + 20, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
        
        if (!scrollView.isDecelerating){
            maskView.fadeOut()
            titSelector.hideButtons(0.2)
            titSelector.isHidden = false
            slider.isHidden = true
            hint?.isHidden = true
        }
        
    }
    
    
    private func configureAddingFeedingSession(side : Side){
        slider.didEndTracking = { (slider) -> () in
            slider.isHidden = true;
            
            self.maskView.fadeOut()
            self.titSelector.isHidden = false;
            
            self.titSelector.isUserInteractionEnabled = true
            
            let newFeedingSession = FeedingSession.Create(side: side, duration: Int(slider.fraction * CGFloat(consts.maxFeedingTime)), endTime: Date())
            
            self.DB.AddFeedingSession(newFeedingSession)
            self.reloadDataSource()
            
            self.tableView.beginUpdates()
            
            let newSection = (self.feedData.count > 1 && Date().dateAtBeginningOfDay() != self.feedData[1].EndTime.dateAtBeginningOfDay()) || self.feedData.count == 1
            if(newSection) {
                self.tableView.insertSections([0] , with: .automatic)
            }
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            // insert row in table
            
            self.tableView.endUpdates()
            
            self.tableView.setContentOffset(CGPoint(x: 0, y:  -20), animated: true)
            
            if self.hint != nil {
                self.hint!.removeFromSuperview()
            }
            
        }
    }
    
    
    func groupByFullDays(feedingSessions : [FeedingSession]) -> [Date:[FeedingSession]] {
        
        var grouped : [Date:[FeedingSession]] = [:]
        
        for fs in feedingSessions {
            
            if(grouped[fs.EndTime.dateAtBeginningOfDay()!] == nil){
                grouped[fs.EndTime.dateAtBeginningOfDay()!] = []
            }
            
            grouped[fs.EndTime.dateAtBeginningOfDay()!]?.append(fs)
        }
        
        return grouped
        
    }
    
}

struct MonthSection : Comparable {
    static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.day > rhs.day
    }
    
    static func == (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.day == rhs.day
    }
    var day : Date
    var feeding : [FeedingSession]
    
}
