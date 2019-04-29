
import UIKit

class EmptyScreenVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
    }



    extension String {
        var htmlToAttributedString: NSAttributedString? {
            guard let data = data(using: .utf8) else { return NSAttributedString() }
            do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
                } 
            catch {
            return NSAttributedString()
            }
        }
        var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
        }
    }

}
