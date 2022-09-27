//
//  ViewController.swift
//  GoogleCalendarDemo
//
//  Created by Kalpita on 16/09/22.
//

import UIKit
import EventKit
import GTMSessionFetcher
import GoogleSignIn
import GoogleAPIClientForREST
import FSCalendar
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    var calenderEvents = [CalenderModel]()
    var eventsDisplayCalender = [String]()
    var selectedDateEvents = [CalenderModel]()
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func btn_PrevRef(_ sender: Any) {
        self.fetchEventsFromGoogleCalender()
    }
    
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = .medium;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
    }

    func stopLoading(){
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    func fetchEventsFromGoogleCalender() {
        
        let scopes = [kGTLRAuthScopeCalendar,kGTLRAuthScopeCalendarReadonly]
//        let service = GTLServiceCalendar()
        var googleSignIn = GIDSignIn.sharedInstance
        googleSignIn.addScopes(scopes, presenting: self)
        let signInConfig = GIDConfiguration.init(clientID: "348520295106-gvlvb2v6k63uv4otb3up5qao32a6s2pb.apps.googleusercontent.com")
        googleSignIn.signOut()
        googleSignIn.signIn(with: signInConfig, presenting: self, hint: "", additionalScopes: scopes) { user, error in
            if let name = GIDSignIn.sharedInstance.currentUser?.profile {
                print(name.name as Any)
                print(name.email as Any)
                let accesstoken = googleSignIn.currentUser!.authentication.accessToken
                    print(accesstoken)
                    self.startLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.getmethod(accesstoken : accesstoken)
                }
            }
        }
    }

    func getmethod(accesstoken:String){
        let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/primary/events")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accesstoken)",
            "Accept": "application/json"
        ]
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let datavalue = response.value {
                if let items = (datavalue as AnyObject).value(forKeyPath:"items") as? [AnyObject] {
                    print(items)
                    for event in items {
                        var startdate = ""
                        var enddate = ""
                        let summary = event.value(forKeyPath: "summary")
                        if let start_date = (event.value(forKeyPath: "start") as AnyObject).value(forKeyPath: "dateTime"){
                            if let stdate = LocalNotificationModel.dateandtime(createddate: start_date as! String) as? String{
                                startdate = stdate
                            }
                        }else if let start_date = (event.value(forKeyPath: "start") as AnyObject).value(forKeyPath: "date"){
                            if let stdate = LocalNotificationModel.date(createddate: start_date as! String) as? String{
                                startdate = stdate
                            }
                        }
                        
                        if let end_date = (event.value(forKeyPath: "end") as AnyObject).value(forKeyPath: "dateTime"){
                            if let edate = LocalNotificationModel.dateandtime(createddate: end_date as! String) as? String{
                                enddate = edate
                            }
                        }else if let end_date = (event.value(forKeyPath: "end") as AnyObject).value(forKeyPath: "date"){
                            if let edate = LocalNotificationModel.date(createddate: end_date as! String) as? String{
                                enddate = edate
                            }
                        }
                        let json: JSON =  ["title": "\(summary!)", "startdate": startdate, "enddate": enddate]
                        self.calenderEvents.append(CalenderModel.init(json: json))
                        let startDate = LocalNotificationModel.calenderformat(date: startdate as! String)
                        self.eventsDisplayCalender.append(startDate)
                    }
                    self.selectedDateEvents = self.calenderEvents
                    DispatchQueue.main.async {
                        self.stopLoading()
                        let syncGoogleCalEvents = self.storyboard?.instantiateViewController(withIdentifier: "SyncGoogleCalEvents") as! SyncGoogleCalEvents
                        syncGoogleCalEvents.eventsDisplayCalender = self.eventsDisplayCalender
                        syncGoogleCalEvents.selectedDateEvents = self.selectedDateEvents
                        syncGoogleCalEvents.calenderEvents = self.calenderEvents
                        self.navigationController?.pushViewController(syncGoogleCalEvents, animated: true)

                    }
                }
            }
        }
    }

    
    
}


