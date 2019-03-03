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

class TableViewController: UITableViewController, UIGestureRecognizerDelegate, CircleMenuDelegate { 
    
    
    
    let DB = FeedingSessionService()
    
    let reminderService = ReminderService()
    
    @IBAction func ReminderSwitchDidChange(_ sender: Any) {
//        if RemindSwitch.isOn {
//            reminderService.addFeedingReminder(fromSession: feedData.first)
//        } else {
//            reminderService.removeReminder()
//        }
       // updateIntervalLabel()
        self.tableView.reloadData()
    }
    
    
    
    var feedData : [FeedingSession] = []
    var sections : [DaySection] = []
    
    //UI
    var slider: Slider!
    var maskView: UIView!
    var hint: UILabel?
    var titSelector : UITitSelector!
    var bell : UIButton!
    
    
    let cellReuseIdentifier = "cellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reloadDataSource()
        
        initComponents()
    }
    
    fileprivate func reloadDataSource(){
        
        self.feedData = self.DB.GetFeedingSessions()
        
        let groups = Dictionary(grouping: self.feedData) { (feedingSession:FeedingSession) in
            return firstHourOfAday(date: feedingSession.EndTime)
        }
        
        self.sections = groups.map { (arg) -> DaySection in
            let (key, values) = arg
            return DaySection(day: key, feeding: values)
            }.sorted()
        
        
        
    }
    
    fileprivate func firstHourOfAday(date : Date) -> Date {
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
        dateFormatter.dateFormat = "EEEE, d MMM"
      
        return dateFormatter.string(from: section.day)
    }
    
    func updateIntervalLabel1 () {
//        reminderService.getNextReminderTime() { intervalText in
//
//            DispatchQueue.main.async {
        
//                self.RemindSwitch.isOn = intervalText != nil
//
//                if let interval = intervalText {
//                    self.nextFeedingCountdownLabel.text = "\(interval)"
//                }
//                else
//                {
//                    if(self.feedData.count > 0){
//
//                        let ft = FeedingTime(feedingSession: self.feedData.first!)
//
//                        if ft.nextFeedingInterval() > 0 {
//                            self.nextFeedingCountdownLabel.text = ft.redableNextFeedingInterval()
//                        } else {
//                            self.nextFeedingCountdownLabel.text = FeedingTime.defaultRedableNextFeedingTime()
//                        }
//                    }else{
//                         self.nextFeedingCountdownLabel.text = FeedingTime.defaultRedableNextFeedingTime()
//                    }
//
//                }
//            }
        //}
        
    }
    
    func initComponents(){
        tableView.delegate = self
        tableView.dataSource = self
        // reminder
       // updateIntervalLabel()
        
        //drawer
        maskView = MaskView(
            frame: CGRect(x: 0, y: view.frame.height - 191, width: view.frame.width , height: 191))
        
        view.addSubview(maskView)
        
        // circle button
        titSelector = UITitSelector(
            frame: CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize / 2), y: view.frame.height - tableViewConsts.bottomMargin, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize))
        
        titSelector.delegate = self
        titSelector.layer.zPosition = 1001
        
        view.addSubview(titSelector)
        
        titSelector.layer.zPosition = 1001
//        //bell button
//        bell = UIButton(
//            frame: CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize / 2) - 50 , y: view.frame.height - tableViewConsts.bottomMargin, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize))
//        
//        bell.setImage(#imageLiteral(resourceName: "bell"), for: .normal)
//        bell.setImage(#imageLiteral(resourceName: "bell"), for: .selected)
//        bell.tintColor = #colorLiteral(red: 0.8349999785, green: 0.5609999895, blue: 0.474999994, alpha: 1)
//        bell.contentMode = .scaleToFill
        
        
//        view.addSubview(bell)
        
        
        //slider
        slider = DurationSlider(frame : CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin - 50, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
        )
        
        view.addSubview(slider)
        
        slider.layer.zPosition = 2
        slider.isHidden = true;
        
        
        // image
        
        let tempImageView = UIImageView(image: UIImage(named: "bgCopy"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if atIndex == 0 {
            button.setImage(#imageLiteral(resourceName: "leftButton"), for: .normal)
        }
        if atIndex == 1{
            button.setImage(#imageLiteral(resourceName: "rightButton"), for: .normal)
        }
        
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        button.layer.zPosition = 1001
        self.view.bringSubviewToFront(button)
        button.layer.zPosition = 1111
        showHint(withText: "Select Side".localized)
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
       
        
        hint!.attributedText = NSAttributedString(string: text, attributes: [.font:  UIFont(name: "Heebo-Regular", size: 12.0)!, .foregroundColor: UIColor(red: 153.0 / 255.0, green: 121.0 / 255.0, blue: 121.0 / 255.0, alpha: 1.0)])
        
       
        
        let w = hint!.intrinsicContentSize.width
        
        hint!.frame = CGRect(x: ((self.view.frame.width / 2) - (w / 2)), y: (self.view.frame.height - tableViewConsts.bottomMargin + 40) + tableView.contentOffset.y, width: view.frame.width, height: 50)
        
        view.addSubview(hint!)
    }
    
    
    private func showTimeButton(){
        slider.isHidden = false
        titSelector.isHidden = true
        
        self.tableView.isScrollEnabled = true
        showHint(withText: "Set Duration".localized)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = self.sections[section]
        return section.feeding.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
	        if indexPath.row == 0 && indexPath.section == 0 {
            return 65.0;
        }
        return 50.0;//Choose your custom row height
    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        if(section == 0){
//            return 40
//        }else{
//            return 10
//        }
//
//    }
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
        
        cell.set(feedingSession: data, prevFeeding: endTime, isOnTop: (indexPath.section == 0) && (indexPath.row == 0))
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return slider?.isHidden ?? true
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        }
        
        let view = UIView(frame: CGRect(x: 20, y: section == 0 ? 30 : 10, width: 200, height: 30))
        view.isUserInteractionEnabled = false
        let label = UILabel(frame: CGRect(x: 0, y:section == 0 ? 28 : 8, width: 200, height: 30))
        label.transform =  CGAffineTransform(translationX: 20.0, y: 0)
        label.textAlignment = .left
        label.tag = section
        let text =  NSAttributedString(string: self.tableView(tableView, titleForHeaderInSection: section) ?? "", attributes: [.font:  UIFont(name: "Heebo-Light", size: 12.0)!, .foregroundColor: #colorLiteral(red: 0.3695555983, green: 0.3659325042, blue: 0.3659325042, alpha: 1)])
        label.isUserInteractionEnabled = false
        label.attributedText = text
        view.addSubview(label)
        return view
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        if editingStyle == .delete {
            
            let id = self.feedData[indexPath.row].Id
            self.DB.RemoveFeedingSession(id)
            reloadDataSource()
            
            self.tableView.reloadData()
           // self.updateIntervalLabel()
           
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return  slider?.isHidden ?? true
    }
    
   
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let dy = scrollView.contentOffset.y
        if(titSelector == nil) {
            return
        }
        titSelector.frame =
            CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize/2), y: view.frame.height - tableViewConsts.bottomMargin + dy, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize)
        
        maskView.frame =
            CGRect(x: 0, y: view.frame.height - 190 + dy + 20, width: view.frame.width , height: 190)
        
        slider.frame =
            CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin - 50 + dy + 20, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
//
//        bell.frame =    CGRect(x: (view.frame.width) - (tableViewConsts.buttonSize + 8), y: 20 + dy, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize)
//
        if (!scrollView.isDecelerating){
            maskView.fadeOut()
            titSelector.hideButtons(0.2)
            titSelector.isHidden = false
            slider.isHidden = true
            hint?.isHidden = true
        }
        
        
    }
    public override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        if slider.isHidden {
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
    private func configureAddingFeedingSession(side : Side){
        slider.didEndTracking = { (slider) -> () in
            slider.isHidden = true;
          
            self.maskView.fadeOut()
            self.titSelector.isHidden = false;
            self.tableView.isScrollEnabled = true
            
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
            
            if self.hint != nil {
                self.hint!.removeFromSuperview()
            }
            
//            if self.RemindSwitch.isOn {
//                self.reminderService.addFeedingReminder(fromSession: self.feedData.first)
//            }
            
            //self.updateIntervalLabel()
            
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

struct DaySection : Comparable {
    static func < (lhs: DaySection, rhs: DaySection) -> Bool {
        return lhs.day > rhs.day
    }
    
    static func == (lhs: DaySection, rhs: DaySection) -> Bool {
        return lhs.day == rhs.day
    }
    var day : Date
    var feeding : [FeedingSession]
    
}
