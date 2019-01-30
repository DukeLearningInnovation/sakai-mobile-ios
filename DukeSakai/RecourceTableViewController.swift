//
//  RecourceTableViewController.swift
//  DukeSakai
//
//  Created by 毛喆 on 2017-03-17.
//  Copyright © 2017 chengzhang. All rights reserved.
//

import UIKit

class RecourceTableViewController: UITableViewController {


    @IBOutlet weak var backLevel: UIBarButtonItem!
    
    @IBOutlet weak var courses: UIButton!
    var siteId : String = ""
    var resourceArray = [Resource]()
    var curArray = [Resource]()
    var stackArray = [[Resource]]()
    let semaphore = DispatchSemaphore(value: 0)
    var tappedUrl = ""
    var tappedFlag = 0
    
    func button () {
        courses.layer.borderWidth = 1
        courses.layer.cornerRadius = courses.bounds.size.height / 2
        courses.clipsToBounds = true
        courses.contentMode = .scaleToFill
    }
    //add0331
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (RecourceTableViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (RecourceTableViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    //add0331
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            print ("swipe right")
            if(stackArray.count > 0) {
                curArray = stackArray.last!
                stackArray.removeLast()
                tableView.reloadData()
            } else {
                self.tabBarController?.selectedIndex = 2
            }
            
        }
    }
    

    
    func initialResourceItems() {
        let thisurl = "https://sakai.duke.edu/direct/content/site/" + siteId + ".json"
//        print(thisurl)
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            print(123456666)
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.resourceArray = []
                return
            }
            
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                
                    
                    if let content_collection = json["content_collection"] as? [[String: AnyObject]] {
                        for resource in content_collection {

                            var title:String = "Not Available"
                            var numChildren:Int = 0
                            var type : String = "Not Available"
                            var url : String = "Not Available"
                            
                            if let mytitle = resource["title"] as? String {
                                title = (mytitle == "" ? "Not Available" : mytitle)
                            }
                            if let mynumChildren = resource["numChildren"] as? Int {
                                numChildren = (mynumChildren == 0 ? 0: mynumChildren)
                            }
                            if let mytype = resource["type"] as? String {
                                type = (mytype == "" ? "Not Available" : mytype)
                            }
                            if let myurl = resource["url"] as? String {
                                url = (myurl == "" ? "Not Available" : myurl)
                            }
                            let resource_item = Resource(numChildren: numChildren, title: title, type: type, url: url)
                            self.resourceArray.append(resource_item)
                            
                            //print(resource_item.type)
                            if resource_item.type != "collection" {
                                print(resource_item.url)
                            }
                            
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeEnabled ()
       // button()
        initialResourceItems()
        
        if (resourceArray.count > 0){
            resourceArray.remove(at: 0)
        }
        
        
        var skip = 0;
        
        for (index, item) in resourceArray.enumerated() {
            if(skip > 0){
                skip = skip - 1
                continue
            }
            curArray.append(item)
            if (item.type == "collection"){
                skip = item.numChildren + helper(input: item, index: index)
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //back to uplevel of file system
    @IBAction func backLevel(_ sender: Any) {
        if(stackArray.count > 0) {
            curArray = stackArray.last!
            stackArray.removeLast()
            tableView.reloadData()
        }
    }
    
    
    func helper(input : Resource, index: Int) -> Int{
        if(input.numChildren == 0){
            return 0
        }
        var ret = 0
        var skip = 0
        for (dex, item) in resourceArray.enumerated(){
            if(dex <= index) {
                continue
            }
            if (skip > 0){
                skip = skip - 1
                continue
            }
            if (item.type == "collection") {
                input.subView.append(item)
                ret = ret + item.numChildren
                skip = item.numChildren + helper(input: item, index: dex)
            }
            else{
                input.subView.append(item)
            }
            
            if (input.subView.count == input.numChildren) {
                return ret
            }
        }
        return ret
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
        return curArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resource", for: indexPath) as! ResourceCell
        cell.resourceTitle?.text = curArray[indexPath.row].title
        if (curArray[indexPath.row].type == "collection"){
            cell.resouce_icon.image = UIImage(named: "folder.png")
        }
        else if (curArray[indexPath.row].type == "text/url"){
            cell.resouce_icon.image = UIImage(named: "URL.png")
        }
        else {
            cell.resouce_icon.image = UIImage(named: "file.png")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //push previous level of files into the stack
        if (curArray[indexPath.row].type == "collection") {
            var temp = [Resource]()
            for item in curArray {
                temp.append(item)
            }
            stackArray.append(temp)
            curArray = curArray[indexPath.row].subView
            self.tableView.reloadData()
            return
            
        }
        if (curArray[indexPath.row].type == "text/url") {
            tappedUrl = curArray[indexPath.row].url
            tappedFlag = 0
            performSegue(withIdentifier: "toUrlDetail", sender: Any.self)
        }
        else {
            tappedUrl = curArray[indexPath.row].url
            tappedFlag = 1
            performSegue(withIdentifier: "toUrlDetail", sender: Any.self)
        }
        
    }
    
    
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toUrlDetail") {
            let destination = segue.destination as! UINavigationController
            let des = destination.topViewController as! UrlViewController
            des.url = self.tappedUrl
            des.flag = tappedFlag
        }
    }
    
    @IBAction func unwindtoResource(segue: UIStoryboardSegue) {
        
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
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
