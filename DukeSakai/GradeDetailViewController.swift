
import UIKit

class GradeDetailViewController: UIViewController {
    var itemName:String = ""
    var siteId:String = ""
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var GradeItem: UITextView!
    @IBOutlet weak var gradeView: UITextView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var commentHeader: UILabel!
    let semaphore = DispatchSemaphore(value: 0)
    var grade:String = ""
    var points:Int = 0
    var commentText = "Not Available"
    
    func button () {
        back.layer.borderWidth = 1
        back.layer.cornerRadius = back.bounds.size.height / 2
        back.clipsToBounds = true
        back.contentMode = .scaleToFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeEnabled ()
        initialComment()
        
        GradeItem.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        GradeItem.text = itemName
        
        gradeView.font = UIFont.init(name: "HelveticaNeue-Medium", size: 20)
        gradeView.textColor = UIColor(red:0.31, green:0.55, blue:0.94, alpha:1.0)
        gradeView.text = grade + " / " + String(points)  + toPercent(grade: grade, points: points)
        
        commentHeader.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        commentHeader.numberOfLines = 2
        commentHeader.text = "Additional instructor's comments about your submission:"
        
        comment.font = UIFont(name: "HelveticaNeue", size: 14)
        comment.text = commentText
    }
    
    func toPercent(grade:String, points:Int)->String {
        let grade_number = Double(grade)
        if (grade_number != nil && grade_number != 0){
            return "       (" + String((grade_number)! / Double(points) * 100) + " %)"
        } else {
            return ""
        }
    }
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (GradeDetailViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (GradeDetailViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipetoGrade", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialComment() {
        let theitemName = itemName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let thisurl = "https://sakai.duke.edu/direct/gradebook/item/" + siteId + "/" + theitemName + ".json"
        let requestURL: NSURL = NSURL(string: thisurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        commentText = "Not Available"
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (httpResponse == nil) {
                self.semaphore.signal()
                self.commentText = ""
                return
            }
            let statusCode = httpResponse?.statusCode
            if (statusCode == 200) {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    if let mycomment = json["comment"] as? String {
                        self.commentText = (mycomment == "" ? "Not Available" : mycomment)
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
}
