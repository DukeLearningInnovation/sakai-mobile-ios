
import UIKit

class AnnDetailViewController: UIViewController {
    var currAnn: Announce? = nil
    @IBOutlet weak var back: UIButton!
    var annTitle = UITextView(frame: CGRect(x: 0, y: 65, width: UIScreen.main.bounds.width - 70, height: 120))
    var detail = UITextView(frame: CGRect(x: 0, y: 185, width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.height - 240))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (currAnn?.body != nil && currAnn?.title != nil) {
            let attrStr = try! NSAttributedString(data: (currAnn?.body.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)

            annTitle.text = currAnn?.title
            annTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            annTitle.isEditable = false
            annTitle.textAlignment = .center
            annTitle.center.x = self.view.center.x
        
            detail.attributedText = attrStr
            detail.font = UIFont(name: "HelveticaNeue", size: 15)
            detail.isEditable = false
            detail.textAlignment = .natural
            detail.center.x = self.view.center.x
        }
        // Do any additional setup after loading the view.
        self.view.addSubview(annTitle)
        self.view.addSubview(detail)

        //swipeEnabled ()
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
