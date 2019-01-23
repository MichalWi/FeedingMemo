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
    static let bottomMargin : CGFloat = 85
    
    static let buttonSize : CGFloat = 50
}

class TableViewController: UITableViewController, CircleMenuDelegate {
 
    
    @IBOutlet weak var HeaderLabel: UILabel!
    
    let Service = FeedingSessionService()
    
    
    var feedData : [FeedingSession] = []
    
    
    //UI
    var slider: Slider!
    var maskView: UIView!
    var hint: UILabel?
    var circleButton : CircleMenu!
    
    
    let cellReuseIdentifier = "cellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.feedData = self.Service.GetFeedingSessions()
        
        initComponents()
        
    }
   
    func initComponents(){
        tableView.delegate = self
        tableView.dataSource = self 
        
        //drawer
        maskView = UIView(
            frame: CGRect(x: 0, y: view.frame.height - 160, width: view.frame.width , height: 140))
        
        maskView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        maskView.isUserInteractionEnabled = false
        maskView.alpha = 0
        view.addSubview(maskView)
        
        // circle button
        circleButton = CircleMenu(
            frame: CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize/2), y: view.frame.height - tableViewConsts.bottomMargin, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize),
            normalIcon:"plus",
            selectedIcon:"plus_filled",
            buttonsCount: 2,
            duration: 0.2,
            distance: 100)
        
        circleButton.subButtonsRadius = 25
        circleButton.delegate = self
        circleButton.startAngle = -50
        circleButton.endAngle = 50
        circleButton.layer.cornerRadius = circleButton.frame.size.width / 2.0
        
        
        view.addSubview(circleButton)
        
        
        //slider
        slider = Slider()
        slider.frame = CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin - 50, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
        slider.attributedTextForFraction = { fraction in
            let string = "\(Int((fraction) * CGFloat(consts.maxFeedingTime))) min"
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.black), .foregroundColor: UIColor.black])
            
        }
        let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
       
        slider.fraction = 1
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = .gray
        slider.valueViewColor = .white
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
        
        slider.imagesColor = UIColor.white
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
        
        button.backgroundColor = .gray
        
      
        showHint(withText: "Select Side")
        maskView.fadeIn()
        
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
//        tableView.isScrollEnabled = false
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
   
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        showTimeButton()
        
        configureAddingFeedingSession(side:  atIndex == 0 ? .Left : .Right)
       
    }
    
    
    private func showTimeButton(){
        slider.isHidden = false
        circleButton.isHidden = true
        showHint(withText: "Set Duration")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feedData.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : TableCellView = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableCellView
        let data = feedData[indexPath.row]
        let prevData = indexPath.row == feedData.count - 1 ? nil : feedData[indexPath.row + 1]
        
        
        let timeSinceLast = self.calculateMinutesSinceFeeding(startTime: prevData?.EndTime ?? Date(), endTime: data.EndTime)
        
        cell.set(feedingSession: data, timeSinceLast: timeSinceLast)
        return cell
    }
    
    
   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return slider?.isHidden ?? true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
       
            self.tableView.beginUpdates()
            let id = self.feedData[indexPath.row].Id
            self.Service.RemoveFeedingSession(id) 
            self.feedData = self.Service.GetFeedingSessions()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
           
            self.tableView.endUpdates()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
        let dy = scrollView.contentOffset.y

        circleButton.frame =
         CGRect(x: (view.frame.width / 2) - (tableViewConsts.buttonSize/2), y: view.frame.height - tableViewConsts.bottomMargin + dy, width: tableViewConsts.buttonSize, height: tableViewConsts.buttonSize)

        maskView.frame =
           CGRect(x: 0, y: view.frame.height - 160 + dy + 20, width: view.frame.width , height: 140)
        
         slider.frame =
            CGRect(x: 25, y: view.frame.height - tableViewConsts.bottomMargin - 50 + dy + 20, width: view.frame.width - 50, height: tableViewConsts.buttonSize)
        
        if (!scrollView.isDecelerating){
            maskView.fadeOut()
            circleButton.hideButtons(0.2)
            circleButton.isHidden = false
            slider.isHidden = true
            hint?.isHidden = true
        }
        
    }
    
    
    private func configureAddingFeedingSession(side : Side){
        slider.didEndTracking = { (slider) -> () in
            slider.isHidden = true;

            self.maskView.fadeOut()
            self.circleButton.isHidden = false;

            self.circleButton.isUserInteractionEnabled = true
            
            let newFeedingSession = FeedingSession.Create(side: side, duration: Int(slider.fraction * CGFloat(consts.maxFeedingTime)), endTime: Date())

            self.Service.AddFeedingSession(newFeedingSession)
            self.feedData = self.Service.GetFeedingSessions()
            
            // insert row in table
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            self.tableView.setContentOffset(CGPoint(x: 0, y:  -20), animated: true)
 
            if self.hint != nil {
                self.hint!.removeFromSuperview()
            }

        }
    }
    
    private func calculateMinutesSinceFeeding(startTime: Date, endTime : Date) -> Int{
        
        
        var inputComps = Calendar.current.dateComponents([.hour, .minute], from: startTime)
        let nowComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: endTime )
        
        inputComps.year = nowComps.year
        inputComps.month = nowComps.month
        inputComps.day = nowComps.day
        
        guard let normalisedInputDate = Calendar.current.date(from: inputComps) else { return 0}
        
        return Int(endTime.timeIntervalSince(normalisedInputDate) / 60)
    }
    
    private func persistDataSource(){
        
        let defaults = UserDefaults.standard
        defaults.set(self.feedData, forKey: defaultsKeys.dataKey);
    }
    
    
}
public extension UIView {
    
    /// Fade in a view with a duration
    ///
    /// Parameter duration: custom animation duration
    func fadeIn(withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
}
