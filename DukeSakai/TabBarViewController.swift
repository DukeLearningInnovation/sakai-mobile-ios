
import UIKit

class TabBarViewController: UITabBarController {

    var siteId : String = ""
    let emptyVC = EmptyScreenVC()
    let feedbackVC = FeedbackVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.popToRootViewController(animated: true)
        let destination1 = (self.viewControllers?[0] as! UINavigationController )
        let des1 =  destination1.topViewController as! AssignmentTableViewController
        des1.siteId = self.siteId
        
        let destination2 = (self.viewControllers?[1] as! UINavigationController )
        let des2 =  destination2.topViewController as! GradeTableViewController
        des2.siteId = self.siteId
        
        let destination3 = (self.viewControllers?[2] as! UINavigationController )
        let des3 =  destination3.topViewController as! AnnTableViewController
        des3.siteId = self.siteId
        
        let destination4 = (self.viewControllers?[3] as! UINavigationController )
        let des4 =  destination4.topViewController as! RecourceTableViewController
        des4.siteId = self.siteId

   
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         tabBarController?.moreNavigationController.navigationBar.backgroundColor = UIColor(red: 0.70, green: 0.20, blue: 0.10, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
