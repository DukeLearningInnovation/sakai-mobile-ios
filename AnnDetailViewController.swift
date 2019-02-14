
import UIKit

class AnnDetailViewController: UIViewController {
    var currAnn: Announce? = nil
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var annTitle: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    if (currAnn?.body != nil && currAnn?.title != nil) {
        let attrStr = try! NSAttributedString(
            data: (currAnn?.body.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)

         detail.attributedText = attrStr
         detail.font = UIFont(name: "HelveticaNeue", size: 18.5)
         annTitle.text = currAnn?.title
        }
        // Do any additional setup after loading the view.
        swipeEnabled ()
    }

    func button () {
        back.layer.borderWidth = 1
        back.layer.cornerRadius = back.bounds.size.height / 2
        back.clipsToBounds = true
        back.contentMode = .scaleToFill
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AnnDetailViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AnnDetailViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipetoAnn", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
