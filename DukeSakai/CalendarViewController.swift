
import UIKit

var presentMonthEvent = [CalendarEvent]()          //default events of month
//var lastMonthEventDay = [CalendarEvent]()
//var nextMonthEventDay = [CalendarEvent]()
var month : Int = 2
var year : Int = 2017
//var selectedEvent : CalendarEvent = CalendarEvent(title: "default", siteId: "default", eventId: "default", time: NSDate(), ft_display: "default")
var selectedEvents = [CalendarEvent]()

class CalenderViewController: UIViewController {
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (CalenderViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (CalenderViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipetoCourse", sender: self)
        }
    }

    
    
    @IBOutlet weak var courses: UIButton!
    
    @IBOutlet weak var calendar: CalendarView!
    var eventArray = [CalendarEvent]()
    let semaphore = DispatchSemaphore(value: 0)
    
    func button () {
        courses.layer.borderWidth = 1
        courses.layer.cornerRadius = courses.bounds.size.height / 2
        courses.clipsToBounds = true
        courses.contentMode = .scaleToFill
    }
    
    func setbutton() {
        // enter.layer.cornerRadius = 50
        Cbutton.layer.borderWidth = 0.0
        Cbutton.layer.cornerRadius = 10
        Cbutton.clipsToBounds = true
        Cbutton.contentMode = .scaleToFill
        
    }

    
    @IBOutlet weak var Cbutton: UIButton!
    
    @IBAction func toEventDetailButton(_ sender: Any) {
        if (selectedEvents.count != 0) {
            performSegue(withIdentifier: "toEventDetail", sender: (Any).self)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  button ()
        setbutton()
        swipeEnabled () 
        
        calendar.delegate = self        //实现代理
        
        let now = NSDate()
        let cal = Calendar.current
        let time = cal.dateComponents([.year, .month, .day], from: now as Date)
        month = time.month!
        year = time.year!
        
        eventArray = []
        presentMonthEvent = []
        
        initiaCalendarEvents()
        //dealwithEvents()
        
        for event in eventArray {
            let date = event.time
            let cal = Calendar.current
            let time = cal.dateComponents([.year, .month, .day], from: date as Date)
            let mon = time.month!
            if (mon == month){
                //presentMonthEvents.append(day!)
                presentMonthEvent.append(event)
            }
        }
        
        calendar.EventList = presentMonthEvent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initiaCalendarEvents() {
        
        //let thisurl = "https://sakai.duke.edu/direct/calendar/my.json?firstDate=2017-03-01&lastDate=2017-06-01"
        var monthCh = String(month)
        if month < 10 {
            monthCh = "0" + monthCh
        }
        let yearCh = String(year)
        let thisurl = "https://sakai.duke.edu/direct/calendar/my.json?firstDate=" + yearCh + "-" + monthCh + "-01&lastDate=" + yearCh +  "-" + monthCh + "-32"
        
        print(thisurl)
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            print(123456666)
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.eventArray = []
                return
            }
            
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    
                    //print(json)
                    
                    
                    if let content_collection = json["calendar_collection"] as? [[String: AnyObject]] {
                        for event in content_collection {
                            
                            var title:String = "Not Available"
                            var eventId : String = "Not Available"
                            var siteId : String = "Not Available"
                            var time : NSDate = NSDate()
                            var ft_display : String = "Not Available"
                            //var tempTime : NSDate = NSDate()
                            
                            if let mytitle = event["title"] as? String {
                                title = (mytitle == "" ? "Not Available" : mytitle)
                            }
                            if let mytime = (event["firstTime"])?["time"] as? Int64 {
                                time = NSDate(timeIntervalSince1970: TimeInterval(mytime/1000))
                                //tempTime = NSDate(timeIntervalSince1970: TimeInterval(mytime/1000 - 18000))
                            }
                            if let myeventId = event["eventId"] as? String {
                                eventId = (myeventId == "" ? "Not Available" : myeventId)
                            }
                            if let mysiteId = event["siteId"] as? String {
                                siteId = (mysiteId == "" ? "Not Available" : mysiteId)
                            }
                            if let myft_display = event["firstTime"]?["display"] as? String {
                                ft_display = (myft_display == "" ? "Not Available" : myft_display)
                            }
                            
                            let eventItem = CalendarEvent(title: title, siteId: siteId, eventId: eventId, time: time, ft_display: ft_display)
                            self.eventArray.append(eventItem)
                            //print(time)
                            
                            let dayPosition = CalendarTool.Day(time as Date) + CalendarTool.DayinWeek(time as Date) - 1
                            eventItem.dayPosition = dayPosition
                        }
                    }
                    
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            self.semaphore.signal()
            
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        //print(eventArray)
    }
    
    @IBAction func unwindtoCalendar(segue: UIStoryboardSegue) {
        
    }
    
    /*
    func dealwithEvents(){
        //var lastMonthEvents = [Int]()
        //var presentMonthEvents = [Int]()
        //var nextMonthEvents = [Int]()
        
        for event in eventArray {
            let date = event.time
            let cal = Calendar.current
            let time = cal.dateComponents([.year, .month, .day], from: date as Date)
            let mon = time.month!
            if (mon == month){
                //presentMonthEvents.append(day!)
                presentMonthEventDay.append(event)
            }
            else if (mon == month - 1 || (month == 1 && mon == 12)) {
                //lastMonthEvents.append(day!)
                lastMonthEventDay.append(event)
                
            }
            else if (mon == month + 1 || (month == 12 && mon == 1)) {
                //nextMonthEvents.append(day!)
                nextMonthEventDay.append(event)
            }
        }
        
    }*/
    
    
}


// MARK: - CalendarDelegate
extension UIViewController:CalendarDelegate{
    /**
     
     - parameter calendar: calendar
     - parameter year:
     - parameter month:
     */
    func CalendarNavClickView(_ calendar: CalendarView, year: Int, month: Int) {
        
        //calendar.SigninList = signinList
    }
}


