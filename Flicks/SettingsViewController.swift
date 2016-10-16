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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        segmentedControl.selectedSegmentIndex = defaults.integer(forKey: "displayType")
    }
    
    @IBAction func onValueChanged(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(segmentedControl.selectedSegmentIndex, forKey: "displayType")
        defaults.synchronize()
    }
    
}
