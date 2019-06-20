
import UIKit

public var tapSiteId : String = ""

class MemberShipTableViewController: UITableViewController {
    var currentCourse = [Membership] ()
    var uniqueTerm = [String] ()
    var termArray = [Term]()
    
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var calendar: UIButton!
    
    func button () {
        logout.layer.borderWidth = 1
        logout.layer.cornerRadius = logout.bounds.size.height / 2
        logout.clipsToBounds = true
        logout.contentMode = .scaleToFill
        
        calendar.layer.borderWidth = 1
        calendar.layer.cornerRadius = calendar.bounds.size.height / 2
        calendar.clipsToBounds = true
        calendar.contentMode = .scaleToFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MemberCell.self, forCellReuseIdentifier: "courseCell")
        self.tableView.register(TermCell.self, forCellReuseIdentifier: "termCell")
        //start to opreate
        self.formCourseArray();
        self.uniqueTerm = getUniqueTerm(coursesArray: self.currentCourse)
        self.uniqueTerm = self.uniqueTerm.sorted(by: sortTerm)
        self.termArray = getTermArray(uniqueTerm: self.uniqueTerm, courseArray: self.currentCourse)
    }
    
    func formCourseArray () {
        for i in courses {
            let newCourse = Membership(name: i.name, siteId: i.siteId, term: i.term, instructor: i.instructor, lastModified: i.lastModified);
            currentCourse.append(newCourse);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return uniqueTerm.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return termArray[section].courses.count + 1
    }

   //assign info for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
         let cell = tableView.dequeueReusableCell(withIdentifier: "termCell", for: indexPath) as! TermCell
            cell.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
            cell.textLabel?.textColor = UIColor(red:0.00, green:0.10, blue:0.34, alpha:1.0)
            
            cell.textLabel?.text = uniqueTerm[indexPath.section]
            
           return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! MemberCell
            cell.textLabel?.font = UIFont.init(name: "HelveticaNeue-Bold", size: 20)
            cell.detailTextLabel?.font = UIFont.init(name: "HelveticaNeue-Medium", size: 15)
            cell.detailTextLabel?.textColor = UIColor(red:0.31, green:0.55, blue:0.94, alpha:1.0)

            cell.textLabel?.text = termArray[indexPath.section].courses[indexPath.row - 1].name
            cell.detailTextLabel?.text = "Instructor: " + termArray[indexPath.section].courses[indexPath.row - 1].instructor
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > 0){
            tapSiteId = termArray[indexPath.section].courses[indexPath.row-1].siteId
            self.performSegue(withIdentifier: "toTabBar", sender: self)
        }
    }
    
    //MARK: - prepare the transdata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTabBar") {
            let destination = segue.destination as! TabBarViewController
            destination.siteId = tapSiteId
            /*
            var desViewController1 = destination.viewControllers?[0] as! AssignmentTableViewController
            desViewController1.siteId = tapSiteId

        
            var desViewController2 = destination.viewControllers?[1] as! AssignmentTableViewController
            desViewController2.siteId = tapSiteId
            var desViewController3 = destination.viewControllers?[2] as! RecourceTableViewController
            desViewController3.siteId = tapSiteId
            var desViewController4 = destination.viewControllers?[3] as! GradeTableViewController
            desViewController4.siteId = tapSiteId
            */
        }
    }
   
    @IBAction func unwindtoMembership(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.row == 0) {
            return 32;
        } else {
            return 67;
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

}
