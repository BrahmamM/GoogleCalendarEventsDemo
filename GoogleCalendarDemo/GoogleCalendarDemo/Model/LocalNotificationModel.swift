//
//  LocalNotificationModel.swift
//  SampleAuthenticationDemoApp
//
//  Created by Kalpita on 05/09/22.
//

import Foundation
import SwiftyJSON


class LocalNotificationModel : NSObject {
    class func convertduedateformat(date: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy h:mm a"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MMM-dd h:mm a"
        var timeStamp = ""
        if let date1 = dateFormat.date(from: date){
            timeStamp = dateFormatterPrint.string(from: date1)
        }else {
            timeStamp = ""
        }
        return timeStamp
    }
    
    class func convertReminderformat(date: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy h:mm a"
        var timeStamp = ""
        if let date1 = dateFormat.date(from: date){
            timeStamp = dateFormatterPrint.string(from: date1)
        }else {
            timeStamp = ""
        }
        return timeStamp
    }
    
    class func convertCalenderformat(date: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy h:mm a"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "YYYY-MM-dd"
        var timeStamp = ""
        if let date1 = dateFormat.date(from: date){
            timeStamp = dateFormatterPrint.string(from: date1)
        }else {
            timeStamp = ""
        }
        return timeStamp
    }
    
    class func calenderformat(date: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM yyyy h:mm a"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "YYYY-MM-dd"
        var timeStamp = ""
        if let date1 = dateFormat.date(from: date){
            timeStamp = dateFormatterPrint.string(from: date1)
        }else {
            timeStamp = ""
        }
        return timeStamp
    }
    
    class func currentdateandtime()->String{
        let FormatterGet = DateFormatter()
        FormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        FormatterGet.locale = Locale(identifier: "en_US")
        let todayDateStr = FormatterGet.string(from: NSDate() as Date)
        return todayDateStr
    }
    
    class func selecteddateandtime(createddate:String)->Date{
        let yyyymmddFormatter = DateFormatter()
        yyyymmddFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObjectToFind = yyyymmddFormatter.date(from: createddate)
        return dateObjectToFind!
    }
    
    class func dateandtime(createddate:String)->String{
        let yyyymmddFormatter = DateFormatter()
        yyyymmddFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy h:mm a"
        var dateFind = ""
        if let date1 = yyyymmddFormatter.date(from: createddate){
            dateFind = dateFormatterPrint.string(from: date1)
        }else {
            dateFind = ""
        }
        return dateFind
    }
    
    class func date(createddate:String)->String{
        let yyyymmddFormatter = DateFormatter()
        yyyymmddFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy h:mm a"
        var dateFind = ""
        if let date1 = yyyymmddFormatter.date(from: createddate){
            dateFind = dateFormatterPrint.string(from: date1)
        }else {
            dateFind = ""
        }
        return dateFind
    }

    
    class func selectedString(createddate:Date)->String{
        let yyyymmddFormatter = DateFormatter()
        yyyymmddFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObjectToFind = yyyymmddFormatter.string(from: createddate)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy h:mm a"
        var dateFind = ""
        if let date1 = yyyymmddFormatter.date(from: dateObjectToFind){
            dateFind = dateFormatterPrint.string(from: date1)
        }else {
            dateFind = ""
        }
        return dateFind
    }
    
    
    class func selectedStringGettingYearMonthDay(createddate:Date)->(yearStr:String,monthStr:String,dayStr:String,timeStr:String){
        print(createddate)
        var yearStr = ""
        var monthStr = ""
        var dayStr = ""
        var timeStr = ""
        
        let yyyymmddFormatter = DateFormatter()
        yyyymmddFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObjectToFind = yyyymmddFormatter.string(from: createddate)
        let dateFormatteryearStr = DateFormatter()
        dateFormatteryearStr.dateFormat = "dd MMM yyyy h:mm a"
        if let date1 = yyyymmddFormatter.date(from: dateObjectToFind){
            yearStr = dateFormatteryearStr.string(from: date1)
        }else {
            yearStr = ""
        }
        
        let dateFormattermonthStr = DateFormatter()
        dateFormattermonthStr.dateFormat = "dd MMM yyyy h:mm a"
        if let date1 = yyyymmddFormatter.date(from: dateObjectToFind){
            monthStr = dateFormattermonthStr.string(from: date1)
        }else {
            monthStr = ""
        }
        
        return(yearStr,monthStr,dayStr,timeStr)
    }


    
    class func getRandomnumber()->Int64 {
        let str = "\(Int(NSDate().timeIntervalSince1970))"
        return Int64(str)!
    }
    
}

//class ActivityIndicator: NSObject {
//    var myActivityIndicator:UIActivityIndicatorView!
//
//    func StartActivityIndicator(obj:UIViewController) -> UIActivityIndicatorView{
//        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRect(x: 100, y: 100, width: 100, height: 100)) as UIActivityIndicatorView
//        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.myActivityIndicator.center = obj.view.center;
//        obj.view.addSubview(myActivityIndicator);
//        self.myActivityIndicator.startAnimating();
//        return self.myActivityIndicator;
//    }
//
//    func StopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void
//    {
//        indicator.removeFromSuperview();
//    }
//
//
//}
