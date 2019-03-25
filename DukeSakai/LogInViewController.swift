
import UIKit

var task : URLSessionTask!
var userId : String = ""
var sites = [String]()
var courses:[(name: String, siteId: String, term: String,  instructor: String, lastModified: Int64)] = []

class LogInViewController: UIViewController {
    let semaphore = DispatchSemaphore(value: 0)
    let semaphore1 = DispatchSemaphore(value: 0)
    @IBOutlet weak var loginWebView: UIWebView!
    @IBAction func webviewRefresh(_ sender: Any) {
        let url = URL(string:"https://sakai.duke.edu")!
        loginWebView.loadRequest(URLRequest(url: url))
    }
    
    @IBOutlet weak var enter: UIButton!
    
    func setbutton() {
        enter.layer.borderWidth = 1
        enter.layer.cornerRadius = 7 //enter.bounds.size.height / 2
        enter.clipsToBounds = true
        enter.contentMode = .scaleToFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setbutton()
        let url = URL(string:"https://sakai.duke.edu")!
        loginWebView.loadRequest(URLRequest(url: url))
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    
    func initialCourses() {
        courses = []
        for site in sites {
            let thisurl = "https://sakai.duke.edu/direct/site/" + site + ".json?n=100&d=3000"
            let requestURL: NSURL = NSURL(string: thisurl)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse == nil) {
                    self.semaphore.signal()
                    courses = []
                    return
                }
                let statusCode = httpResponse?.statusCode
                
                if (statusCode == 200) {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                        var name:String = "name"
                        var instructor:String = "instructor"
                        var lastModified:Int64 = 0
                        var term:String = "Project"
                        if let title = json["title"] as? String {
                            name = title
                        }
                        if let type = json["type"] as? String {
                            if (type != "project") {
                                if let props = json["props"]  {
                                    term = (props["term"] as? String)!
                                }
                            }
                        }
                        if let siteOwner = json["siteOwner"]  {
                            if (siteOwner["userDisplayName"] as? String) != nil {
                                instructor = (siteOwner["userDisplayName"] as? String)!
                            }
                        }
                        if let mylastModified = json["lastModified"] as? Int64{
                            lastModified = mylastModified
                        }
                        let tuple = (name, site, term, instructor, lastModified)
                        courses.append(tuple);
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

    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !((loginWebView.request?.url?.absoluteString.hasPrefix("https://sakai.duke.edu/portal"))! ){
            return
        }
    }
    
    @IBAction func enterButton(_ sender: Any) {
        if !((loginWebView.request?.url?.absoluteString.hasPrefix("https://sakai.duke.edu/portal"))! ){
            return
        }
        sites = [String]()
        let requestURL: NSURL = NSURL(string: "https://sakai.duke.edu/direct/membership.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let targetString = "site:"

        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                sites = []
                userId = ""
                self.semaphore1.signal()
                return
            }
            let statusCode = httpResponse?.statusCode
            
            if (statusCode == 200) {
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    if let membership_collection = json["membership_collection"] as? [[String: AnyObject]] {
                        for membership in membership_collection {
                            if let id = membership["id"] as? String {
                                let startIndex = strStr(id, targetString)
                                let mystring = id.substring(from: (startIndex + 5))
                                sites.append(mystring)
                            }
                            if let myuserId = membership["userId"] as? String {
                                userId = myuserId
                            }
                        }
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
            self.semaphore1.signal()
        }
        task.resume()
        _ = semaphore1.wait(timeout: DispatchTime.distantFuture)
        initialCourses()
        performSegue(withIdentifier: "logIn", sender: self)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func unwindtoLogin(segue: UIStoryboardSegue) {
        courses = []
        task?.cancel()
        userId = ""
        sites = []
        print("logout")
        let url = URL(string:"https://sakai.duke.edu/portal/logout")!
        loginWebView.loadRequest(URLRequest(url: url))
    }*/
}

