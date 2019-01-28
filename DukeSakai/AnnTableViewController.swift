//
//  AnnounceTableViewController.swift
//  DukeSakai
//
//  Created by 毛喆 on 2017-03-17.
//  Copyright © 2017 chengzhang. All rights reserved.
//

import UIKit

class AnnTableViewController: UITableViewController {
    
    var siteId : String = ""
    var announceItems:[(title: String, body: String, createdOn: Int64, author: String)] = []
    var tapAnnounceBody: String? = nil
    var tapAnnounceTitle: String? = nil
    var currAnnouncement = [Announce]()
    let semaphore = DispatchSemaphore(value: 0)
    var tapAnn: Announce? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "Annoucenments"
        //        self.navigationItem.title = "Annoucenments"
        //        self.navigationController?.navigationBar.topItem?.title = "Annoucenments";
        //        self.tabBarController?.navigationItem.title="Annoucenments"
        //        self.parent?.title = "Annoucenments"
        
        // button ()
        swipeEnabled ()
        print(siteId)
        initialAnnounceItems()
        print(announceItems)
        formAnnounce()
    }
    
    func formAnnounce () {
        for i in announceItems {
            let announce1 = Announce(title: i.title, body: i.body, createdOn: i.createdOn, author: i.author)
            currAnnouncement.append(announce1)
        }
        currAnnouncement =  currAnnouncement.sorted(){$0.createdOn > $1.createdOn}
    }
    
    func initialAnnounceItems() {
        let thisurl = "https://sakai.duke.edu/direct/announcement/site/" + siteId + ".json?n=100&d=3000"
        print(thisurl)
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.announceItems = []
                return
            }
            
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    //                    print(json)
                    if let announcement_collection = json["announcement_collection"] as? [[String: AnyObject]] {
                        for announcement in announcement_collection {
                            var title:String = "Not Available"
                            var createdOn:Int64 = 0
                            var body:String = "<h1>Not Available</h1>"
                            var author:String = "Not Available"
                            
                            if let mytitle = announcement["title"] as? String {
                                title = (mytitle == "" ? "Not Available" : mytitle)
                            }
                            if let mybody = announcement["body"] as? String {
                                body = (mybody == "" ? "Not Available" : mybody)
                            }
                            if let myauthor = announcement["createdByDisplayName"] as? String {
                                author = (myauthor == "" ? "Not Available" : myauthor)
                            }
                            if let mycreatedOn = announcement["createdOn"] as? Int64  {
                                createdOn = mycreatedOn
                            }
                            
                            let tuple = (title, body, createdOn, author)
                            self.announceItems.append(tuple);
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currAnnouncement.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnCell", for: indexPath) as! AnnCell
        
        cell.announce?.text = currAnnouncement[indexPath.row].title
        //cell.time?.text = String(currAnnouncement[indexPath.row].createdOn)
        cell.author?.text = currAnnouncement[indexPath.row].author
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tapAnn = currAnnouncement[indexPath.row]
        performSegue(withIdentifier: "toAnnDetail1", sender: (Any).self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAnnDetail1") {
            
            let destination = segue.destination as! UINavigationController
            let desination1 = destination.topViewController as! AnnDetailViewController
            desination1.currAnn = tapAnn
            
        }
    }
    
    @IBAction func unwindtoAnn(segue: UIStoryboardSegue) {
        
    }
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AnnTableViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AnnTableViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    //add0331
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.tabBarController?.selectedIndex = 1
            //performSegue(withIdentifier: "gradeToAss", sender: self)
        }
        if (sender.direction == .left) {
            self.tabBarController?.selectedIndex = 3
            //performSegue(withIdentifier: "gradeToAss", sender: self)
        }
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
