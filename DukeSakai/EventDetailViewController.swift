
import UIKit

class EventDetailViewController: UIViewController {


    let semaphore = DispatchSemaphore(value: 0)
    var detailTemp = "Not available"
    @IBOutlet weak var detailDis: UITextView!
    @IBOutlet weak var back: UIButton!
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (EventDetailViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (EventDetailViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipetoCalendar", sender: self)
        }
    }
    

    func button () {
        back.layer.borderWidth = 1
        back.layer.cornerRadius = back.bounds.size.height / 2
        back.clipsToBounds = true
        back.contentMode = .scaleToFill
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeEnabled ()
       // button ()
        var tempString = ""
        var i = 0
        for event in selectedEvents {
             initialSelectEvent(selectedEvent: event)
            if(i != 0) {
             tempString = tempString + "<p></p>"
            }
            tempString = tempString + "<font size = \"6\"><b>" + event.title + "</b></font><br/>"
            
            tempString = tempString + "<b>"
            tempString = tempString + event.ft_display
            tempString = tempString + " to "
            tempString = tempString + event.lt_display
            tempString = tempString + "</b><br/><br/>"
            var body = "<font size = \"4\">" + event.detail
            body = body + "</font>"
            tempString = tempString + body
             i = i + 1
        }
      // tempString =  "<font size = \"2\">" + tempString + "</font>"
        
        print(tempString)
        if (tempString != "") {
            let attrStr = try! NSAttributedString(
                data: (tempString.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            detailDis.attributedText = attrStr
        }
        
        
        //to do: display detail
        
        
        //self.textview.text = self.textview.text + "Title  " + selectedEvent.title + "\n"

        //self.textview.text = self.textview.text + "Date:  " + selectedEvent.ft_display + " - " + lt_display + "\n" + "Description:  " + description + "\n"
        
    }
    @IBOutlet weak var textview: UITextView!

    func initialSelectEvent(selectedEvent : CalendarEvent) {
        
        let thisurl = "https://sakai.duke.edu/direct/calendar/event/" + selectedEvent.siteId + "/" + selectedEvent.eventId + ".json"
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            print(123456666)
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                selectedEvent.detail = ""
                selectedEvent.lt_display = ""
                return
            }
            
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    var detail:String = "Not Available"
                    var lt_display : String = "Not Available"
                    
                    if let mydescription = json["description"] as? String {
                        detail = (mydescription == "" ? "Not Available" : mydescription)
                    }
                    if let mylt_display = json["lastTime"]?["display"] as? String {
                        lt_display = (mylt_display == "" ? "Not Available" : mylt_display)
                    }
                    
                    selectedEvent.detail = detail
                    selectedEvent.lt_display = lt_display
             
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            self.semaphore.signal()
            
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
