//
//  firstPage.swift
//  DukeSakai
//
//  Created by ECE564 on 6/20/19.
//  Copyright © 2019 Zhe Mao. All rights reserved.
//

import UIKit

class firstPage: UIViewController {
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.loginPresented() {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "logIn", sender: self)
                self.navigationController?.navigationBar.isHidden = false  // resume the navbar for later pages
            }
        }
    }
    
    func loginPresented(completionHandler: @escaping () -> Void) {
        let vc = loginPage()
        vc.modalPresentationStyle = .formSheet
        
        self.present(vc, animated: true, completion: {
            self.showSpinner(onView: self.view, text: "Loading...")
            print("spinner shown")
        })
        
        vc.onCancel = { _ in
            print("❕ debug info: user canceled")
            DispatchQueue.main.async {
                self.removeSpinner()
                print("spinner removed")
            }
        }
        
        vc.onDoneSubmit = { _ in
            print("✅ debug info: submit is done")
            
        }
        
        vc.onDoneLogin = { _ in  // might be changed to entity
            print("✅ debug info: the results. the original implementation is global variable, which is bad.")
            DispatchQueue.main.async {
                // must update UI on main thread
                UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.removeSpinner()
                }, completion: nil)
                print("spinner removed")
            }
            completionHandler()  // block to refresh the table
        }
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true  // hide the navbar for front page
        self.loginPresented() {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "logIn", sender: self)
                self.navigationController?.navigationBar.isHidden = false  // resume the navbar for later pages
            }
        }
    }
}

