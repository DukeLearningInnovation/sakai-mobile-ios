//
//  UrlViewController.swift
//  DukeSakai
//
//  Created by 马丞章 on 3/29/17.
//  Copyright © 2017 Zhe Mao. All rights reserved.
//

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
    
    //add 0331
    func swipeEnabled () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector (UrlViewController.handleSwipes(sender: )))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (UrlViewController.handleSwipes(sender: )))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    //add0331
    func handleSwipes (sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            performSegue(withIdentifier: "swipeToResource", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // swipeEnabled ()
        //button ()
        switch flag {
        case 0 :
            let url = URL(string : self.url)!
            urlWebView.loadRequest(URLRequest(url: url))
        case 1:
            print("hehe")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
