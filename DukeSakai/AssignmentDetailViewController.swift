
import UIKit

class AssignmentDetailViewController: UIViewController {
    var currAssign: Assignment? = nil
    
    @IBOutlet weak var back: UIButton!
    
    var assnTitle = UITextView(frame: CGRect(x: 15, y: 65, width: UIScreen.main.bounds.width - 30, height: 115))
    
    var due = UILabel(frame: CGRect(x: 120, y: 178, width: 225, height: 21))
    
    var instruction = UITextView(frame: CGRect(x: 15, y: 257, width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height - 240))
    
    /*func button () {
        back.layer.borderWidth = 1
        back.layer.cornerRadius = back.bounds.size.height / 2
        back.clipsToBounds = true
        back.contentMode = .scaleToFill
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeEnabled ()
        if (currAssign?.instructions != nil) {
            let attrStr = try! NSMutableAttributedString(
                data: (currAssign?.instructions.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
             assnTitle.text = currAssign?.assignmentTitle
            assnTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            assnTitle.textAlignment = .center
            assnTitle.isEditable = false
            
            due.text = currAssign?.due
            due.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            due.textColor = UIColor(red: 0.68, green: 0.09, blue: 0.10, alpha: 1.0)
            due.isUserInteractionEnabled = false
            
            instruction.attributedText = attrStr
            instruction.font = UIFont(name: "HelveticaNeue", size: 14.5)
            instruction.isEditable = false

        }
        self.view.addSubview(assnTitle)
        self.view.addSubview(due)
        self.view.addSubview(instruction)
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
