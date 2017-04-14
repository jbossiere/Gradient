//
//  RatingViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 4/12/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var neutralSelectionRing: UIImageView!
    @IBOutlet weak var openSelectionRing: UIImageView!
    @IBOutlet weak var busySelectionRing: UIImageView!
    @IBOutlet weak var busyTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.neutralSelectionRing.isHidden = true
        self.openSelectionRing.isHidden = true
        self.busySelectionRing.isHidden = true
        self.sendButton.isEnabled = false
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
        self.neutralSelectionRing.isHidden = true
        self.openSelectionRing.isHidden = true
        self.busySelectionRing.isHidden = true
        
        switch button.tag {
        case 1:
            self.busySelectionRing.isHidden = false
        case 2:
            self.neutralSelectionRing.isHidden = false
        case 3:
            self.openSelectionRing.isHidden = false
        default:
            return
        }
        self.sendButton.isEnabled = true
    }

    @IBAction func sendRating(_ sender: Any) {
        // Save the user rating
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "supBro"), object: nil)
        dismiss(animated: true, completion: nil)
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
