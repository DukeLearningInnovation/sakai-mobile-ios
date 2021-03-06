
import UIKit


//Calendar Reference: https://github.com/LitterL/CalendarDemo 

//MARK: - define delegate
protocol CalendarDelegate{
    
    func CalendarNavClickView(_ calendar:CalendarView,year:Int,month:Int)
}

class CalendarView: UIView {
    
    var delegate: CalendarDelegate?
    //data to draw
    var EventList = [CalendarEvent](){
        didSet{
            for i in 0..<contentWrapperView.subviews.count{
                for j in 0..<EventList.count{
                    if i == EventList[j].dayPosition{
                        let btn =  contentWrapperView.subviews[i] as! UIButton
                        let day = btn.titleLabel?.text!
                        let date = EventList[j].time
                        let cal = Calendar.current
                        let time = cal.dateComponents([.year, .month, .day], from: date as Date)
                        let myday = time.day
                        let daynum = Int(day!)
                        if (daynum == myday) {
                            logDate(btn)
                        }
                        else if(daynum! > myday!){
                            let bt =  contentWrapperView.subviews[i-1] as! UIButton
                            logDate(bt)
                        }
                        else{
                            let bt =  contentWrapperView.subviews[i+1] as! UIButton
                            logDate(bt)
                        }                        
                    }
                }
            }
        }
    }
    //------------------------------- color of title -------------------------------------
    var weekdayHeaderTextColor = UIColor(red: 0.70, green: 0.20, blue: 0.10, alpha: 1) {                             //Mon to Fri
        didSet{
            for i in 0..<weekHeaderView.subviews.count{
                let label = weekHeaderView.subviews[i] as! UILabel
                label.textColor = (i == 0 || i == 6) ? weekdayHeaderWeekendTextColor : weekdayHeaderTextColor
            }
        }
    }
    var weekdayHeaderWeekendTextColor = UIColor(red: 0.70, green: 0.20, blue: 0.10, alpha: 1){                     //Sat and Sun
        didSet{
            for i in 0..<weekHeaderView.subviews.count{
                let label = weekHeaderView.subviews[i] as! UILabel
                label.textColor = (i == 0 || i == 6) ? weekdayHeaderWeekendTextColor : weekdayHeaderTextColor
            }
        }
    }
    //----------------------------------- color of calendar ----------------------------------------
    //color of month
    var componentTextColor =  UIColor.black {
        didSet{
            for btn in contentWrapperView.subviews{
                let bt = btn as! UIButton
                bt.setTitleColor(componentTextColor, for: UIControl.State())
            }
        }
    }
    //color of today
    var todayIndicatorColor =  UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    {
        didSet{
            for btn in contentWrapperView.subviews{
                let bt = btn as! UIButton
                if bt.titleLabel?.text == "\(CalendarTool.Day(Date()))"{
                    bt.backgroundColor = todayIndicatorColor
                }
            }
        }
    }
    //highlight color
    var highlightedComponentTextColor = UIColor.white
    //background color
    var selectedIndicatorColor = UIColor(red:0.00, green:0.19, blue:0.53, alpha:1.0)
    
    //------------------------------------ Three main parts of the calendar --------------------------------------
    // Title
    let navigationBar = UIView()
    // Title text
    var textLabel = UILabel()
    // Weekday
    let weekHeaderView = UIView()
    // Days
    let contentWrapperView = UIView()
    // Global time
    var Nowdate = Date()
    // Text view to show details
    var textview = UITextView()
    var eventArray = [CalendarEvent]()
    let semaphore = DispatchSemaphore(value: 0)
    //let semaphore2 = DispatchSemaphore(value: 0)
    //----------------------------------------- Create Calendar --------------------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /**
     three parts
     */
    func commonInit(){
        //TODO:- CALENDAR SIZE MODIFICATIONS
        //let screenSize = UIScreen.main.bounds
        //navigationBar
        if UIDevice.current.orientation.isLandscape {
            navigationBar.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.height))/2, y: 0, width: 0.75*UIScreen.main.bounds.height, height: 40)
            self.addSubview(navigationBar)
            CreateNavigationBar()
            //weekHeader
            weekHeaderView.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.height))/2, y: navigationBar.frame.maxY, width: 0.75*UIScreen.main.bounds.height, height: 40)
            print(navigationBar.frame.maxY)
            self.addSubview(weekHeaderView)
            CreateWeekHeaderView()
            //contentView
            contentWrapperView.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.height))/2, y: weekHeaderView.frame.maxY, width: 0.75*UIScreen.main.bounds.height, height: 0.65*UIScreen.main.bounds.width)
            self.addSubview(contentWrapperView)
            CreatecontentWrapperView(Nowdate)
            //add text view
            textview.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.height))/2, y: contentWrapperView.frame.maxY - 180,width: 0.70*UIScreen.main.bounds.height, height: 100)
            print(contentWrapperView.frame.maxY)
            textview.isEditable = false
            //textView.textAlignment = NSTextAlignment.Center
            textview.textColor = UIColor.blue
            //textview.backgroundColor = UIColor.red
            self.addSubview(textview)
        }
        else{
            navigationBar.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.width))/2, y: 0, width: 0.75*UIScreen.main.bounds.width, height: 40)
            self.addSubview(navigationBar)
            CreateNavigationBar()
            //weekHeader
            weekHeaderView.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.width))/2, y: navigationBar.frame.maxY, width: 0.75*UIScreen.main.bounds.width, height: 40)
            print(navigationBar.frame.maxY)
            self.addSubview(weekHeaderView)
            CreateWeekHeaderView()
            //contentView
            contentWrapperView.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.width))/2, y: weekHeaderView.frame.maxY, width: 0.75*UIScreen.main.bounds.width, height: 0.65*UIScreen.main.bounds.height)
            self.addSubview(contentWrapperView)
            CreatecontentWrapperView(Nowdate)
            //add text view
            textview.frame = CGRect(x: (UIScreen.main.bounds.maxX - (0.75*UIScreen.main.bounds.width))/2, y: contentWrapperView.frame.maxY - 180,width: 0.70*UIScreen.main.bounds.width, height: 100)
            textview.isEditable = false
            //textView.textAlignment = NSTextAlignment.Center
            textview.textColor = UIColor.blue
            //textview.backgroundColor = UIColor.red
            self.addSubview(textview)
        }
    }
}

//MARK:- create title view
extension CalendarView{
    /**
     create title view
     */
      func CreateNavigationBar(){
        let textLabel = UILabel()           //mid title
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 16)
        navigationBar.addSubview(textLabel)
        //layout
        self.addConstraint(NSLayoutConstraint(item: textLabel,
                                              attribute: NSLayoutConstraint.Attribute.centerX,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: navigationBar,
                                              attribute: NSLayoutConstraint.Attribute.centerX,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textLabel,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: navigationBar,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              multiplier: 1.0,
                                              constant: 0))
        let presentMonth = CalendarTool.Month(Nowdate)
        var monthCh = String(presentMonth)
        if (presentMonth < 10) {
            monthCh = "0" + monthCh
        }
        textLabel.text = "\(CalendarTool.Year(Nowdate))." + monthCh
        self.textLabel = textLabel
        //left button
        let prevBtn = UIButton(type: .custom)
        prevBtn.translatesAutoresizingMaskIntoConstraints = false
        prevBtn.tintColor = UIColor.gray
        prevBtn.setBackgroundImage(UIImage(named: "prev")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State())
        prevBtn.addTarget(self, action: #selector(CalendarView.prevButtonDidTap(_:)), for: .touchUpInside)
        navigationBar.addSubview(prevBtn)
        //layout
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: navigationBar,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: navigationBar,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1.0,
                                              constant:16))
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant:30))
        self.addConstraint(NSLayoutConstraint(item: prevBtn,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant:30))
        
        //right button
        let nextBtn = UIButton(type: .custom)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.tintColor = UIColor.gray
        nextBtn.setBackgroundImage(UIImage(named: "next")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State())
        nextBtn.addTarget(self, action: #selector(CalendarView.nextButtonDidTap(_:)), for: .touchUpInside)
        navigationBar.addSubview(nextBtn)
        //layout
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: navigationBar,
                                              attribute: NSLayoutConstraint.Attribute.centerY,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: navigationBar,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1.0,
                                              constant:-16))
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant:30))
        self.addConstraint(NSLayoutConstraint(item: nextBtn,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1.0,
                                              constant:30))
    }
    /**
     left button
     - parameter btn: button
     */
    @objc func prevButtonDidTap(_ btn:UIButton){
        for i in contentWrapperView.subviews{
            i.removeFromSuperview()
        }
        Nowdate = CalendarTool.UpMonth(Nowdate)
        
        if CalendarTool.Month(Nowdate) == 12{
            Nowdate = CalendarTool.UpYear(Nowdate)
        }
        //add month
        CreatecontentWrapperView(Nowdate)
        let presentMonth = CalendarTool.Month(Nowdate)
        var monthCh = String(presentMonth)
        if (presentMonth < 10) {
            monthCh = "0" + monthCh
        }
        textLabel.text = "\(CalendarTool.Year(Nowdate))." + monthCh
        delegate?.CalendarNavClickView(self, year: CalendarTool.Year(Nowdate), month: CalendarTool.Month(Nowdate))
        month = CalendarTool.Month(Nowdate)
        year = CalendarTool.Year(Nowdate)
        initiaCalendarEvents()
        presentMonthEvent = []
        for event in eventArray {
            let date = event.time
            let cal = Calendar.current
            let time = cal.dateComponents([.year, .month, .day], from: date as Date)
            let mon = time.month!
            if (mon == month){
                presentMonthEvent.append(event)
            }
        }
        EventList = presentMonthEvent
    }
    /**
     right button
     - parameter btn: button
     */
    @objc func nextButtonDidTap(_ btn:UIButton){
        for i in contentWrapperView.subviews{
            i.removeFromSuperview()
        }
        Nowdate = CalendarTool.NextMonth(Nowdate)
        if CalendarTool.Month(Nowdate) == 1{
            Nowdate = CalendarTool.NextYear(Nowdate)
        }
        //add month
        CreatecontentWrapperView(Nowdate)
        let presentMonth = CalendarTool.Month(Nowdate)
        var monthCh = String(presentMonth)
        if (presentMonth < 10) {
            monthCh = "0" + monthCh
        }
        textLabel.text = "\(CalendarTool.Year(Nowdate))." + monthCh
        delegate?.CalendarNavClickView(self, year: CalendarTool.Year(Nowdate), month: CalendarTool.Month(Nowdate))
        month = CalendarTool.Month(Nowdate)
        year = CalendarTool.Year(Nowdate)
        initiaCalendarEvents()
        presentMonthEvent = []
        
        for event in eventArray {
            let date = event.time
            let cal = Calendar.current
            let time = cal.dateComponents([.year, .month, .day], from: date as Date)
            let mon = time.month!
            if (mon == month){
                presentMonthEvent.append(event)
            }
        }
        EventList = presentMonthEvent
    }
}
//MARK:- create weekday attribute

//TODO:- CHANGE CALENDAR SIZE
extension CalendarView{
      func  CreateWeekHeaderView(){
        let array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let itemW = weekHeaderView.frame.width / 7
        
        for i in 0..<7{
            let x = itemW * CGFloat(i)
            let label = UILabel(frame: CGRect(x: x ,y: 0,width: itemW,height: weekHeaderView.frame.height))
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = (i == 0 || i == 6) ? weekdayHeaderWeekendTextColor : weekdayHeaderTextColor
            label.text = array[i]
            weekHeaderView.addSubview(label)
        }
    }
}
//MARK:- create calendar body
extension CalendarView{
      func  CreatecontentWrapperView(_ date:Date){
        let wid :CGFloat = 5
        let itemWH = (contentWrapperView.frame.width - 8 * wid) / 7
        //how many days in last month
        let UpMonthdays = CalendarTool.DaysInMonth( CalendarTool.UpMonth(date))
        //total days this month
        let monthDays = CalendarTool.DaysInMonth(date)
        //when is the first day
        let Weekday    = CalendarTool.DayinWeek(date)
        var day = 0
        
        for i in 0..<42{
            let x  = CGFloat(i % 7) * itemWH
            let y  = CGFloat(i / 7) * itemWH
            let spacew = CGFloat(i % 7) * wid + wid
            let btn = UIButton(frame: CGRect(x: x + spacew,  y: y  ,width: itemWH ,height: itemWH))
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(componentTextColor, for: UIControl.State())
            btn.layer.cornerRadius = itemWH / 2
            
            if (i < Weekday) {
                day = UpMonthdays - Weekday + i + 1
                btn.alpha = 0.2
            }else if (i > Weekday + monthDays - 1){
                day = i + 1 - Weekday - monthDays;
                btn.alpha = 0.2
            }else{
                day = i - Weekday + 1;
                btn.alpha = 1.0
                if day == CalendarTool.Day(date) && CalendarTool.Month(Nowdate) == CalendarTool.Month(Date()) && CalendarTool.Year(Nowdate) == CalendarTool.Year(Date()){
                    btn.backgroundColor = todayIndicatorColor
                }
                //push btn
                btn.addTarget(self, action: #selector(CalendarView.selectDate(_:)), for: .touchUpInside)
            }
            contentWrapperView.addSubview(btn)
            btn.setTitle("\(day)", for: UIControl.State())
        }
    }
    
    @objc func logDate(_ btn:UIButton){
        btn.isSelected = true
        btn.backgroundColor = btn.isSelected ?  selectedIndicatorColor : nil
        btn.setTitleColor(highlightedComponentTextColor, for: .selected)
    }
    
    @objc   func selectDate(_ btn:UIButton){
        selectedEvents = []
        textview.text = ""
        let day = btn.titleLabel?.text!
        for event in EventList {
            let date = event.time
            let cal = Calendar.current
            let time = cal.dateComponents([.year, .month, .day], from: date as Date)
            let myday = time.day
            let daynum = Int(day!)
            if (daynum == myday) {
                //initialSelectEvent(event: event)
                textview.text = textview.text + event.title + "\n"
                selectedEvents.append(event)
            }
        }
        
    }
    
    @objc func initiaCalendarEvents() {
        
        eventArray = []
        //let thisurl = "https://sakai.duke.edu/direct/calendar/my.json?firstDate=2017-03-01&lastDate=2017-06-01"
        var monthCh = String(month)
        if month < 10 {
            monthCh = "0" + monthCh
        }
        let yearCh = String(year)
        let thisurl = "https://sakai.duke.edu/direct/calendar/my.json?firstDate=" + yearCh + "-" + monthCh + "-01&lastDate=" + yearCh +  "-" + monthCh + "-32"
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.eventArray = []
                return
            }
            
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    
                    if let content_collection = json["calendar_collection"] as? [[String: AnyObject]] {
                        for event in content_collection {
                            var title:String = "Not Available"
                            var eventId : String = "Not Available"
                            var siteId : String = "Not Available"
                            var time : NSDate = NSDate()
                            //var tempTime : NSDate = NSDate()
                            var ft_display : String = "Not Available"
                            
                            if let mytitle = event["title"] as? String {
                                title = (mytitle == "" ? "Not Available" : mytitle)
                            }
                            if let mytime = (event["firstTime"])?["time"] as? Int64 {
                                time = NSDate(timeIntervalSince1970: TimeInterval(mytime/1000))
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
    }
    
}

