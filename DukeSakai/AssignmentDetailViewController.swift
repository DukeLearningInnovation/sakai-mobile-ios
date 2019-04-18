
import UIKit

class AssignmentDetailViewController: UIViewController {
    var currAssign: Assignment? = nil
    
    @IBOutlet weak var instruction: UITextView!
    @IBOutlet weak var back: UIButton!
    
    func button () {
        back.layer.borderWidth = 1
        back.layer.cornerRadius = back.bounds.size.height / 2
        back.clipsToBounds = true
        back.contentMode = .scaleToFill
    }
    
    @IBOutlet weak var assTitle: UITextView!
    @IBOutlet weak var Due: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeEnabled ()
        if (currAssign?.instructions != nil) {
            let attrStr = try! NSAttributedString(
                data: (currAssign?.instructions.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            assTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            assTitle.text = currAssign?.assignmentTitle
            
            Due.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            Due.text = currAssign?.due
            
            instruction.font = UIFont(name: "HelveticaNeue", size: 14)
            instruction.attributedText = attrStr
        }
    }
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AssignmentDetailViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AssignmentDetailViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipeToAssignment", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
