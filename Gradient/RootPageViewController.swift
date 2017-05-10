//
//  RootPageViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 5/9/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//
// Used https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/ and https://spin.atomicobject.com/2016/02/11/move-uipageviewcontroller-dots/ for onboarding

import UIKit

class RootPageViewController: UIPageViewController {

    weak var controlDelegate: RootPageViewControllerDelegate?
    
    lazy var viewControllerList:[UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyboard.instantiateViewController(withIdentifier: "OnboardingOne")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "OnboardingTwo")
        let vc3 = storyboard.instantiateViewController(withIdentifier: "OnboardingThree")
        let vc4 = storyboard.instantiateViewController(withIdentifier: "OnboardingFour")
       
        return [vc1, vc2, vc3, vc4]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        controlDelegate?.rootPageViewController(rootPageViewController: self, didUpdatePageCount: viewControllerList.count)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .clear
                let pageControl = view as? UIPageControl
                pageControl?.currentPageIndicatorTintColor = UIColor(red:0.26, green:0.58, blue:1.00, alpha:1.0)
                pageControl?.pageIndicatorTintColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
            }
        }
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return viewControllerList.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        guard let firstViewController = viewControllers?.first,
//            let firstViewControllerIndex = viewControllerList.index(of: firstViewController) else {
//                return 0
//        }
//        return firstViewControllerIndex
//    }
}

extension RootPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }

}

extension RootPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = viewControllerList.index(of: firstViewController) {
            controlDelegate?.rootPageViewController(rootPageViewController: self, didUpdatePageIndex: index)
        }
    }
}

protocol RootPageViewControllerDelegate: class {
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func rootPageViewController(rootPageViewController: RootPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func rootPageViewController(rootPageViewController: RootPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
