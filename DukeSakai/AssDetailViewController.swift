//
//  AssDetailViewController.swift
//  DukeSakai
//
//  Created by 毛喆 on 2017-03-27.
//  Copyright © 2017 Zhe Mao. All rights reserved.
//

import UIKit

class AssDetailViewController: UIViewController {
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
        //button()
         swipeEnabled ()
        if (currAssign?.instructions != nil) {
        let attrStr = try! NSAttributedString(
            data: (currAssign?.instructions.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
            instruction.attributedText = attrStr
            Due.text = currAssign?.due
            assTitle.text = currAssign?.assignmentTitle
        }
        //
        
       // instruction.text = currAssign?.instructions
        // Do any additional setup after loading the view.
        
      /*  if (currAssign?.assignmentTitle != ""){
            back.title = currAssign?.assignmentTitle
        }
        else {
            back.title = "Back"
        }
        */
    }
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AssDetailViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (AssDetailViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    //add0331
    @objc func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipetoAss", sender: self)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
