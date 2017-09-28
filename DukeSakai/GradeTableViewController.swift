//
//  GradeTableViewController.swift
//  DukeSakai
//
//  Created by 毛喆 on 2017-03-17.
//  Copyright © 2017 chengzhang. All rights reserved.
//

import UIKit

class GradeTableViewController: UITableViewController {
    var gradeItems:[(itemName: String, points: Int, grade: String)] = []
    var siteId : String = ""
    var currGrade = [Grade]()
    var tapItem: String = ""
    var tapPoints: Int = 0
    var tapGrade:String = ""
    let semaphore = DispatchSemaphore(value: 0)
    @IBOutlet weak var courses: UIButton!
    func button () {
        courses.layer.borderWidth = 1
        courses.layer.cornerRadius = courses.bounds.size.height / 2
        courses.clipsToBounds = true
        courses.contentMode = .scaleToFill
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // button()
        swipeEnabled ()
        print(siteId)
        initialgradeItems()
        print(self.gradeItems)
        formGrade()

    }
    func formGrade() {
        for i in gradeItems {
            let grade1 = Grade(item: i.itemName, grade: i.grade, point: i.points)
            currGrade.append(grade1)
        }
        
    }
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (GradeTableViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (GradeTableViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    //add0331
    func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.tabBarController?.selectedIndex = 0
            //performSegue(withIdentifier: "gradeToAss", sender: self)
        }
        if (sender.direction == .left) {
            self.tabBarController?.selectedIndex = 2
            //performSegue(withIdentifier: "gradeToAss", sender: self)
        }

        }

    func initialgradeItems() {
        let thisurl = "https://sakai.duke.edu/direct/gradebook/site/" + siteId + ".json"
        print(thisurl)
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
//            print(123456666)
            
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.gradeItems = []
                return
            }
            
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")

                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
//                    print(json)
                    if let assignments = json["assignments"] as? [[String: AnyObject]] {
                        for assignment in assignments {
                            var itemName:String = "itemName"
                            var points:Int = 0
                            var grade:String? = nil

                            if let mygrade = assignment["grade"] as? String {
                                grade = mygrade
                            }
                            if let mypoints = assignment["points"] as? Int {
                                points = mypoints
                            }
                            if let myitemName = assignment["itemName"] as? String {
                                itemName = myitemName
                            }
                            let tuple = (itemName, points, grade ?? "Not Available")
                            self.gradeItems.append(tuple);

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
        return currGrade.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "grade", for: indexPath) as! GradeCell

        cell.grade?.text = currGrade[indexPath.row].grade + " / " + String(currGrade[indexPath.row].point)
        cell.item?.text = currGrade[indexPath.row].item

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 74
    }
    
    @IBAction func unwindtoGrade(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toGradeDetail") {
            
            let destination = segue.destination as! UINavigationController
            let desination1 = destination.topViewController as! GradeDetailViewController
            desination1.itemName = tapItem
            desination1.siteId = siteId
            desination1.points = tapPoints
            desination1.grade = tapGrade
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tapItem = gradeItems[indexPath.row].itemName
        self.tapPoints = gradeItems[indexPath.row].points
        self.tapGrade = gradeItems[indexPath.row].grade
        self.performSegue(withIdentifier: "toGradeDetail", sender: self)
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
