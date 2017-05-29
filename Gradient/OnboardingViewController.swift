//
//  OnboardingViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 5/10/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//
// Used https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/ and https://spin.atomicobject.com/2016/02/11/move-uipageviewcontroller-dots/ for onboarding

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var conatinerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var rootPageViewController: RootPageViewController? {
        didSet {
            rootPageViewController?.controlDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let rootPageViewController = segue.destination as? RootPageViewController {
            self.rootPageViewController = rootPageViewController
        }
    }
    
    @IBAction func nextButtonTouched(_ sender: Any) {
        if nextButton.currentTitle == "NEXT" {
            rootPageViewController?.scrollToNextViewController()
        } else {
            UserDefaults.standard.set(true, forKey: "onboarded")
            print(UserDefaults.standard.bool(forKey: "onboarded"))
            performSegue(withIdentifier: "toMapView", sender: nil)
        }
    }
}

extension OnboardingViewController: RootPageViewControllerDelegate {
    func rootPageViewController(rootPageViewController: RootPageViewController,
                                didUpdatePageCount count: Int){
        pageControl.numberOfPages = count
    }
    
    func rootPageViewController(rootPageViewController: RootPageViewController,
                                didUpdatePageIndex index: Int){
        pageControl.currentPage = index
        if pageControl.currentPage == 3 {
            self.nextButton.setTitle("DONE", for: .normal)
        } else {
            self.nextButton.setTitle("NEXT", for: .normal)
        }
    }
}
