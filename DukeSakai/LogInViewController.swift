
import UIKit
import WebKit

var task : URLSessionTask!
var userId : String = ""
var sites = [String]()
var courses:[(name: String, siteId: String, term: String,  instructor: String, lastModified: Int64)] = []

class LogInViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    let semaphore = DispatchSemaphore(value: 0)
    let semaphore1 = DispatchSemaphore(value: 0)
    var loginWebView: WKWebView!
    @IBAction func webviewRefresh(_ sender: Any) {
        let url = URL(string:"https://sakai.duke.edu")!
        loginWebView.load(URLRequest(url: url))
    }
    
    let group = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:"https://sakai.duke.edu")!

        self.configurationForWebView { config in
            self.loginWebView = WKWebView(frame: CGRect.zero, configuration: config)
            self.loginWebView.navigationDelegate = self
            self.loginWebView.uiDelegate = self
            self.loginWebView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.loginWebView)
            NSLayoutConstraint.activate([
                self.loginWebView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.loginWebView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.loginWebView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.loginWebView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
            self.loginWebView.load(URLRequest(url: url))
        }
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyBoard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Helpers for WKWebView cookies persistent storage (ref: https://stackoverflow.com/a/52109021/2672265)
    private func configurationForWebView(_ completion: @escaping (WKWebViewConfiguration) -> Void) {
        let configuration = WKWebViewConfiguration()
        let processPool: WKProcessPool

        if let pool: WKProcessPool = self.getData(key: "pool")  {
            processPool = pool
        } else {
            processPool = WKProcessPool()
            self.setData(processPool, key: "pool")
        }

        configuration.processPool = processPool

        if let cookies: [HTTPCookie] = self.getData(key: "cookies") {
            for cookie in cookies {
                group.enter()
                configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                    self.group.leave()
                }
            }
        }

        group.notify(queue: DispatchQueue.main) {
            completion(configuration)
        }
    }

    func setData(_ value: Any, key: String) {
        let ud = UserDefaults.standard
        let archivedPool = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        ud.set(archivedPool, forKey: key)
    }

    func getData<T>(key: String) -> T? {
        let ud = UserDefaults.standard
        if let val = ud.value(forKey: key) as? Data,
            let obj = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(val) as? T {
            return obj
        }

        return nil
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

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !((loginWebView.url?.absoluteString.hasPrefix("https://sakai.duke.edu/portal"))! ){
            return
        }

        loginWebView.isHidden = true

        // Save cookies to disk manually to reuse in the next session
        loginWebView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            self.setData(cookies, key: "cookies")
        }
        loginWebView.configuration.websiteDataStore.httpCookieStore.getAllCookies({cookies in
            self.enterSakai(nil, cookies)
        })
    }
    
    func enterSakai(_ sender: Any?, _ cookies: [HTTPCookie]) {
        if !((loginWebView.url?.absoluteString.hasPrefix("https://sakai.duke.edu/portal"))! ){
            return
        }
        sites = [String]()
        let requestURL: NSURL = NSURL(string: "https://sakai.duke.edu/direct/membership.json?_limit=100")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared

        // Unlike UIWebView, WKWebView doesn't share cookies with URLSession
        // Need to do that manually:
        cookies.forEach { cookie in
            session.configuration.httpCookieStorage?.setCookie(cookie)
        }
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

