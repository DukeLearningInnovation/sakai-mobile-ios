//
//  ViewController.swift
//  DukeSakai
//
//  Created by Niral Shah on 11/2/17.
//  Copyright © 2017 Zhe Mao. All rights reserved.
//

import UIKit
protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
}

class HamMenuController: UIViewController {

    var siteId : String = ""
    var hamMenuVisible = false;
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded!")

        print(siteId)
        // Do any additional setup after loading the view.
    }
    @IBAction func openMenu(_ sender: AnyObject) {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuActionDelegate = self
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openAssign") {
            print("loading assignments");
            //self.storyboard?.instantiateViewController(withIdentifier: "Grades")
            let destination = segue.destination as! AssignmentTableViewController
            destination.siteId = self.siteId
        }
        if (segue.identifier == "openResources") {
            //self.storyboard?.instantiateViewController(withIdentifier: "Resources")
            let destination = segue.destination as! RecourceTableViewController
            destination.siteId = self.siteId
        }
        
        if (segue.identifier == "openGrades") {
            //self.storyboard?.instantiateViewController(withIdentifier: "Grades")
            let destination = segue.destination as! GradeTableViewController
            destination.siteId = self.siteId
        }
        if (segue.identifier == "openAnn" || segue.identifier == "embed"){
            print("Going to Ann");
            let destination = segue.destination as! AnnTableViewController
            destination.siteId = self.siteId
        }
    }
    
    @IBAction internal func unwind(for unwindSegue: UIStoryboardSegue) {
        //rewind
    }
}

extension HamMenuController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension HamMenuController : MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?) {
        dismiss(animated: true){
            self.performSegue(withIdentifier: segueName, sender: sender)
        }
    }
    func reopenMenu(){
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
}
