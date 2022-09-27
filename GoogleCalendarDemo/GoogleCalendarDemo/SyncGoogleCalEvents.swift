//
//  SyncGoogleCalEvents.swift
//  GoogleCalendarDemo
//
//  Created by Kalpita on 16/09/22.
//

import UIKit
import EventKit
import GTMSessionFetcher
import GoogleSignIn
import FSCalendar
import Alamofire
import SwiftyJSON
struct CalenderModel{
    var title : String!
    var startdate :String!
    var enddate : String!
    init(json : JSON){
        self.title = json["title"].stringValue
        self.startdate = json["startdate"].stringValue
        self.enddate = json["enddate"].stringValue
    }
}

class SyncGoogleCalEvents: UIViewController {
    @IBOutlet weak var calenderEventsTableview: UITableView!
    var calenderEvents = [CalenderModel]()
    var eventsDisplayCalender = [String]()
    var selectedDateEvents = [CalenderModel]()
    var startDate = ""
    var endDate = ""
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendar.reloadData()
        }
    }
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    var isSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderEventsTableview.register(UINib(nibName: "LocalNotificationCell", bundle: nil), forCellReuseIdentifier: "LocalNotificationCell")

        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calendar.accessibilityIdentifier = "calendar"
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calendar.select(self.formatter.date(from: "2017/08/10")!)
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        let sdate = Date().startOfWeek
        let edate = Date().endOfWeek
        self.startDate = self.formatter.string(from:sdate);
        self.endDate = self.formatter.string(from: edate);
        self.calendar.select(self.formatter.date(from: self.startDate))
        
        self.calendar.reloadData()
        self.calenderEventsTableview.reloadData()
    }
    
    
    @IBAction func btn_PrevRef(_ sender: Any) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
    }
    
    @IBAction func btn_NextRef(_ sender: Any) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
    }

    @IBAction func shuffleAction(_ sender: Any) {

        if self.isSelected == false{
            self.isSelected = true
            self.calendar.setScope(.week, animated: true)
        }else{
            self.isSelected = false
            self.calendar.setScope(.month, animated: true)
        }
    }
}

extension SyncGoogleCalEvents : UITableViewDataSource,UITableViewDelegate {
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedDateEvents.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalNotificationCell", for: indexPath) as! LocalNotificationCell
        cell.switchaction.isHidden = true
        cell.myCellLabel.text = "\(self.selectedDateEvents[indexPath.row].title!)\nStart date : \(self.selectedDateEvents[indexPath.row].startdate!)\nEnd date : \(self.selectedDateEvents[indexPath.row].enddate!)"
        cell.myCellLabel.font = UIFont.systemFont(ofSize: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SyncGoogleCalEvents : FSCalendarDataSource, FSCalendarDelegate{

    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2200-04-17")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.formatter.string(from: date)
        if self.eventsDisplayCalender.contains(dateString) {
            return 1;
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        return UIColor.purple
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.formatter.string(from: date)
        if self.eventsDisplayCalender.contains(key) {
            return [UIColor.magenta, appearance.eventDefaultColor, UIColor.orange]
        }
        return nil
    }
    
    
    // MARK:- FSCalendarDelegate
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

        
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)
        //display events as dots
        cell.eventIndicator.isHidden = false
        if self.eventsDisplayCalender.contains(dateString){
            cell.eventIndicator.numberOfEvents = 1
        }
    }
    
    //MARK:- Calender Didselect
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDateEvents.removeAll()
        let selectedDate = (self.formatter.string(from: date))
        for i in (0..<self.eventsDisplayCalender.count){
            if self.eventsDisplayCalender[i] == selectedDate{
                self.selectedDateEvents.append(self.calenderEvents[i])
            }
        }
        let formatterSelected = DateFormatter()
        formatterSelected.dateFormat = "MMM dd,yyyy"
        self.calenderEventsTableview.reloadData()
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    

    func getNextMonth(date:Date)->Date {
        if self.calendar.scope == .week {
            return  Calendar.current.date(byAdding: .weekOfMonth, value: 1, to:date)!
        }else{
            return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
        }
    }
    
    func getPreviousMonth(date:Date)->Date {
        if self.calendar.scope == .week {
            return  Calendar.current.date(byAdding: .weekOfMonth, value: -1, to:date)!
        }else{
            return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
        }
    }
    
}
extension Date {
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
}
