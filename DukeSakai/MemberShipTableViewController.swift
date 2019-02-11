
import UIKit


class MemberShipTableViewController: UITableViewController {
    var currentCourse = [Membership] ()
    var uniqueTerm = [String] ()
    var termArray = [Term]()
    var tapSiteId : String = ""
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
        print(sites)
       // button ()
        super.viewDidLoad()
        //initialCourses()
        //start to opreate
        self.formCourseArray();
        self.uniqueTerm = getUniqueTerm(coursesArray: self.currentCourse)
        self.uniqueTerm = self.uniqueTerm.sorted(by: sortTerm)
        self.termArray = getTermArray (uniqueTerm: self.uniqueTerm, courseArray: self.currentCourse)
        
    }
    
    func formCourseArray () {
        for i in courses {
            let newCourse = Membership(name: i.name, siteId: i.siteId, term: i.term, instructor: i.instructor, lastModified: i.lastModified);
            print(i.term)
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "TermCell", for: indexPath) as! TermCell
           cell.termName?.text = uniqueTerm[indexPath.section]
           return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! MemberCell
            cell.courseTitle?.text = termArray[indexPath.section].courses[indexPath.row - 1].name
            cell.instructor?.text = termArray[indexPath.section].courses[indexPath.row - 1].instructor
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > 0){
            self.tapSiteId = termArray[indexPath.section].courses[indexPath.row-1].siteId
            self.performSegue(withIdentifier: "toTabBar", sender: self)

        }
    }
    
    //MARK: - prepare the transdata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTabBar") {
            print("hehe")
            
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
            return 50;
        } else {
            return 85;
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
