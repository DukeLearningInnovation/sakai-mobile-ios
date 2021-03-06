
import UIKit

class MoreTableViewController: UITableViewController {
    
    var allViews = [String]()
    let cellIdentifier = "MoreCell"
    let membershipVC = MemberShipTableViewController()
    let resourceVC = RecourceTableViewController()
    let feedbackEmail = FeedbackVC()
    var siteId : String = ""
    var resourceSiteId = ""
    @IBOutlet weak var courses: UIButton!
    
    func button () {
        courses.layer.borderWidth = 1
        courses.layer.cornerRadius = courses.bounds.size.height / 2
        courses.clipsToBounds = true
        courses.contentMode = .scaleToFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.popToRootViewController(animated: true)
        self.tableView.register(MoreCell.self, forCellReuseIdentifier: "MoreCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        allViews = ["Assignments", "Grades", "Announcements", "Resources", "Feedback"]
        resourceSiteId = self.siteId
        // siteId = tabBarVC.siteId
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allViews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.textColor = UIColor(red:0.00, green:0.10, blue:0.34, alpha:1.0)
        }
        // Configure the cell...
        cell!.textLabel!.text = allViews[indexPath.row]
        
        return cell!
    }
    

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let destination1 = AssignmentTableViewController()
            destination1.siteId = tapSiteId
            navigationController?.pushViewController(destination1, animated: true)
            
        case 1:
            let destination2 = GradeTableViewController()
            destination2.siteId = tapSiteId
            navigationController?.pushViewController(destination2, animated: true)
            
        case 2:
            let destination3 = AnnTableViewController()
            destination3.siteId = tapSiteId
            navigationController?.pushViewController(destination3, animated: true)
            
        case 3:
            // HERE I am trying a new way of calling the ResourceTableVC, this makes it so that the tab does
            // not go black, but I cannot get the siteID right, I have tried it in many ways.
            let destination4 = RecourceTableViewController()
            destination4.siteId = tapSiteId
            self.navigationController!.pushViewController(destination4, animated: true)
            
        case 4:
            let destination6 = FeedbackVC()
            self.navigationController!.pushViewController(destination6, animated: true)
            
        case 5:
            let destination5 = EmptyScreenVC()
            self.navigationController!.pushViewController(destination5, animated: true)
            
        case 6:
            let destination7 = LessonTableVC()
            self.navigationController?.pushViewController(destination7, animated: true)
            
        default:
            let destinationHome = MemberShipTableViewController()
            self.navigationController!.pushViewController(destinationHome, animated: true)
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
