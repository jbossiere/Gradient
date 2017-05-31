//
//  RatingViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 4/12/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

//    @IBOutlet weak var neutralSelectionRing: UIImageView!
    @IBOutlet weak var openSelectionRing: UIImageView!
    @IBOutlet weak var busySelectionRing: UIImageView!
    @IBOutlet weak var busyTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var confirmNotificationView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.neutralSelectionRing.isHidden = true
        self.openSelectionRing.isHidden = true
        self.busySelectionRing.isHidden = true
        self.sendButton.isEnabled = false
        self.confirmNotificationView.alpha = 0
    }
    
    // Dismiss Modal
    @IBAction func dismissModal(_ sender: Any) {
            dismiss(animated: true, completion: nil)
       
    }
    
    // Show button selection
    @IBAction func selectionMade(_ sender: UIButton) {
        guard let button = sender as? UIButton else {
            return
        }
//        self.neutralSelectionRing.isHidden = true
        self.openSelectionRing.isHidden = true
        self.busySelectionRing.isHidden = true
        
        switch button.tag {
        case 1:
            self.busySelectionRing.isHidden = false
//        case 2:
//            self.neutralSelectionRing.isHidden = false
        case 3:
            self.openSelectionRing.isHidden = false
        default:
            return
        }
        self.sendButton.isEnabled = true
    }

    @IBAction func sendRating(_ sender: Any) {
        // Save the user rating
        
        UIView.animate(withDuration: 0.3, animations: {
                self.confirmNotificationView.alpha = 1
        }, completion: { [weak self] finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self?.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    // Following two overrides lock app orientation portrait view
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
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
