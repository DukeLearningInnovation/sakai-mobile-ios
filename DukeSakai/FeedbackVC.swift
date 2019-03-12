
import UIKit
import Foundation
import MessageUI

class FeedbackVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    let thanksText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.00, green:0.10, blue:0.34, alpha:1.0)
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendFeedback()
        
        thanksText.frame = CGRect(x: (UIScreen.main.bounds.maxX - 300)/2, y: (UIScreen.main.bounds.midY - 100)/2, width: 300, height: 150)
        thanksText.backgroundColor = self.view.backgroundColor
        thanksText.textColor = UIColor.white
        thanksText.text = "Thank you for your feedback, you help us improve everyday!"
        thanksText.isEditable = false
        thanksText.font = UIFont(name: "Palatino-BoldItalic", size: 30)
        self.view.addSubview(thanksText)
        
    }
    
    func sendFeedback(){
        let feedbackVC = MFMailComposeViewController()
        feedbackVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        feedbackVC.setToRecipients(["mobilecenter@duke.edu"])
        feedbackVC.setSubject("Feedback DukeSakai App")
        feedbackVC.setMessageBody("Please provide your feedback here!", isHTML: false)
        
        // Present the view controller modally.
        self.present(feedbackVC, animated: true, completion: nil)
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}





