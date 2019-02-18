
import UIKit

class UrlViewController: UIViewController {
    var url = ""
    var flag = 2
    @IBOutlet weak var urlWebView: UIWebView!
    @IBOutlet weak var back: UIButton!
    
    func button () {
        back.layer.borderWidth = 1
        back.layer.cornerRadius = back.bounds.size.height / 2
        back.clipsToBounds = true
        back.contentMode = .scaleToFill
    }
    
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (UrlViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (UrlViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipeToResource", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        switch flag {
        case 0 :
            let url = URL(string : self.url)!
            urlWebView.loadRequest(URLRequest(url: url))
        case 1:
            //let path = URL(fileURLWithPath: url)
            let url = URL(string : self.url)!
            urlWebView.loadRequest(URLRequest(url: url))
            //let request = URLRequest(url: path as URL)
            //urlWebView.loadRequest(request as URLRequest)
        default:
            break
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
