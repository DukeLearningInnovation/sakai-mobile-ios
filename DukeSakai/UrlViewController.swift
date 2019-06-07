
import UIKit

class UrlViewController: UIViewController {
    var url = ""
    var flag = 2
    var urlWebView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlWebView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
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
        self.view.addSubview(urlWebView)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
