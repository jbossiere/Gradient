//
//  OnboardingViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 5/10/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var conatinerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingPageViewController = segue.destination as? RootPageViewController {
            onboardingPageViewController.controlDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension OnboardingViewController: RootPageViewControllerDelegate {
    func rootPageViewController(rootPageViewController: RootPageViewController,
                                didUpdatePageCount count: Int){
        pageControl.numberOfPages = count
    }
    
    func rootPageViewController(rootPageViewController: RootPageViewController,
                                didUpdatePageIndex index: Int){
        pageControl.currentPage = index
    }
}
