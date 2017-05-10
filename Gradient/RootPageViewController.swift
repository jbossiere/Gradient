//
//  RootPageViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 5/9/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var viewControllerList:[UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyboard.instantiateViewController(withIdentifier: "OnboardingOne")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "OnboardingTwo")
        let vc3 = storyboard.instantiateViewController(withIdentifier: "OnboardingThree")
        let vc4 = storyboard.instantiateViewController(withIdentifier: "OnboardingFour")
       
        return [vc1, vc2, vc3, vc4]
        
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .red
        pc.currentPageIndicatorTintColor = UIColor.blue
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .clear
            }
        }
    }
    

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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = viewControllerList.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
}
