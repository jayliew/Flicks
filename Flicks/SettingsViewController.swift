//
//  SettingsViewController.swift
//  Flicks
//
//  Created by Jay Liew on 10/15/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        segmentedControl.selectedSegmentIndex = defaults.integer(forKey: "displayType")
        
        backButton.layer.cornerRadius = 3
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        backButton.layer.shadowOpacity = 0.3
        backButton.layer.shadowRadius = 3.0

        segmentedControl.layer.cornerRadius = 3
        segmentedControl.layer.shadowColor = UIColor.black.cgColor
        segmentedControl.layer.shadowOffset = CGSize(width: 3, height: 3)
        segmentedControl.layer.shadowOpacity = 0.3
        segmentedControl.layer.shadowRadius = 3.0
    }
    
    @IBAction func onValueChanged(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(segmentedControl.selectedSegmentIndex, forKey: "displayType")
        defaults.synchronize()
    }
    
}
