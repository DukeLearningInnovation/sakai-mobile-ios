//
//  LogInViewController.swift
//  DukeSakai
//
//  Created by 毛喆 on 2017-03-21.
//  Copyright © 2017 Zhe Mao. All rights reserved.
//

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
       // enter.layer.cornerRadius = 50
        enter.layer.borderWidth = 1
        enter.layer.cornerRadius = enter.bounds.size.height / 2
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
        print(1234)
        print(sites)
        for site in sites {
            print(12345)
            
            let thisurl = "https://sakai.duke.edu/direct/site/" + site + ".json"
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
                    courses = []
                    return
                }
                
                let statusCode = httpResponse?.statusCode
                
                if (statusCode == 200) {
                    print("Everyone is fine, file downloaded successfully.")
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                        var name:String = "name"
                        var instructor:String = "instructor"
                        var lastModified:Int64 = 0
                        var term:String = "Project"
                        if let title = json["title"] as? String {
                            name = title
                            print(title)
                        }
                        if let type = json["type"] as? String {
                            print(type)
                            if (type != "project") {
                                if let props = json["props"]  {
                                    print(props)
                                    term = (props["term"] as? String) ?? "Project"
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
    
    /*
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }*/
    
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
            print("11111")

            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                print("haha")
                sites = []
                userId = ""
                self.semaphore1.signal()
                return
            }
            let statusCode = httpResponse?.statusCode
            
            if (statusCode == 200) {
//                print("Everyone is fine, file downloaded successfully.")
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
            
            print(sites)
            print("userId")
            print(userId)
            self.semaphore1.signal()
        }
        
        task.resume()
        _ = semaphore1.wait(timeout: DispatchTime.distantFuture)
        
        initialCourses()
        
        performSegue(withIdentifier: "logIn", sender: self)

    }
//    func wait() {
//        sleep(1)
//        print("userId")
//        print(userId)
//        
//
//        
//        sleep(1)
//        
//
//    }
    
    
    func dismissKeyBoard() {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

