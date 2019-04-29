
import UIKit

class EmptyScreenVC: UIViewController{
    
    let  date = NSDate(timeIntervalSince1970: 1536166800)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        ReadableDate(date)
    }
    
    func ReadableDate(_: NSDate){
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY 'at' hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        print( " _ts value is 1536166800")
        print( " _ts value is \(dateString)")
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
