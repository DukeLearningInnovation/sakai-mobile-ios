
import UIKit

class AssignmentTableViewController: UITableViewController {
    var assignmentItems:[(title: String, status: String, dueTimeString: String, gradeScaleMaxPoints: String, instructions: String, dueTime:Int64)] = []
   // var currAssignment = [Assignment]()
    var tapAssignment: Assignment? = nil
    var siteId : String = ""
    let semaphore = DispatchSemaphore(value: 0)

    var openAssignment = [Assignment] ()
    var closeAssignment = [Assignment] ()
    @IBOutlet weak var courses: UIButton!
    func button () {
        courses.layer.borderWidth = 1
        courses.layer.cornerRadius = courses.bounds.size.height / 2
        courses.clipsToBounds = true
        courses.contentMode = .scaleToFill
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeEnabled ()
        initialassignmentItems()
        formAssignment()
    }
    
    func formAssignment () {
        for i in assignmentItems {
            let assignment1 = Assignment(assignmentTitle: i.title, status: i.status, due: i.dueTimeString, scale: i.gradeScaleMaxPoints, instructions: i.instructions, dueTime: i.dueTime)
            if (assignment1.status == "Open") {
               openAssignment.append(assignment1)
            } else {
               closeAssignment.append(assignment1)
            }
        }
        openAssignment = openAssignment.sorted () {$0.dueTime < $1.dueTime}
        closeAssignment = closeAssignment.sorted () {$1.dueTime < $0.dueTime}
    }
    
    func initialassignmentItems() {
        //let thisurl = "https://sakai.duke.edu/direct/assignment/site/" + siteId + ".json"
        //let requestURL: NSURL = NSURL(string: thisurl)!
        //let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        //let session = URLSession.shared
        
        let URLinfo = getInitialItems(siteId: siteId, category: "assignment")
        let urlRequest = URLinfo.urlRequest
        let session = URLinfo.session
        
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.assignmentItems = []
                return
            }

            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    if let assignment_collection = json["assignment_collection"] as? [[String: AnyObject]] {
                        for assignment in assignment_collection {
                            var title:String = "Not Available"
                            var status:String = "Not Available"
                            var dueTimeString:String = "Not Available"
                            var dueTime:Int64 = 0
                            var gradeScaleMaxPoints:String = "Not Available"
                            var instructions:String = "<h5>Not Available</h5>"
                            
                            if let mytitle = assignment["title"] as? String {
                                title = (mytitle == "" ? "Not Available" : mytitle)
                            }
                            if let mystatus = assignment["status"] as? String {
                                status = (mystatus == "" ? "Not Available" : mystatus)
                            }
                            if let mydueTimeString = assignment["dueTimeString"] as? String {
                                dueTimeString = (mydueTimeString == "" ? "Not Available" : mydueTimeString)
                            }
                            if let tempDue = assignment["dueTime"]  {
                                dueTime = (tempDue["epochSecond"] as? Int64) ?? 0
                            }
                            if let mygradeScaleMaxPoints = assignment["gradeScaleMaxPoints"] as? String {
                                gradeScaleMaxPoints = (mygradeScaleMaxPoints == "" ? "Not Available" : mygradeScaleMaxPoints)
                            }
                            if let myinstructions = assignment["instructions"] as? String {
                                instructions = (myinstructions == "" ? "<h5>Not Available</h5>" : myinstructions)
                            }
                            let tuple = (title, status, dueTimeString, gradeScaleMaxPoints, instructions, dueTime)
                            self.assignmentItems.append(tuple);
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
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AssignmentTableViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AssignmentTableViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.tabBarController?.selectedIndex = 1
            //performSegue(withIdentifier: "gradeToAss", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
        return openAssignment.count + 1
        } else {
            return closeAssignment.count + 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! StatusCell
                cell.status.text = "Open"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "assignment", for: indexPath) as! AssignmentCell
                cell.assignmentTitle?.text  = openAssignment[indexPath.row - 1].assignmentTitle
                cell.assignmentTitle?.textColor = UIColor(red:0.00, green:0.10, blue:0.34, alpha:1.0)
                cell.due?.text  = openAssignment[indexPath.row - 1].due
                cell.scale?.text  = openAssignment[indexPath.row - 1].scale
                return cell
            }
        } else {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! StatusCell
                cell.status.text = "Closed"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "assignment", for: indexPath) as! AssignmentCell
                cell.assignmentTitle?.text  = closeAssignment[indexPath.row - 1].assignmentTitle
                cell.assignmentTitle?.textColor = UIColor(red:0.00, green:0.10, blue:0.34, alpha:1.0)
                cell.due?.text  = closeAssignment[indexPath.row - 1].due
                cell.scale?.text  = closeAssignment[indexPath.row - 1].scale
                return cell
            }
        }
    }
    //unwind
    @IBAction func unwindtoAssignment(segue: UIStoryboardSegue) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAssignmentDetail") {
            let destination = segue.destination as! UINavigationController
            let desination1 = destination.topViewController as! AssignmentDetailViewController
            desination1.currAssign = tapAssignment
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return
            } else {
            self.tapAssignment = openAssignment[indexPath.row - 1]
            }
        } else {
            if (indexPath.row == 0) {
                return
            } else {
            self.tapAssignment = closeAssignment[indexPath.row - 1]
            }
        }
        self.performSegue(withIdentifier: "toAssignmentDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return 120;
        }
    }
}
