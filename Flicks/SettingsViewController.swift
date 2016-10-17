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

    let pink = UIColor(red:0xF8, green: 0xDB, blue: 0xDA)
    let lightPink = UIColor(red:0xF6, green: 0xCA, blue: 0xC8)
    let blue = UIColor(red:0x91, green:0xA4, blue:0xD0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        segmentedControl.selectedSegmentIndex = defaults.integer(forKey: "displayType")
        
        backButton.layer.cornerRadius = 3
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        backButton.layer.shadowOpacity = 0.3
        backButton.layer.shadowRadius = 3.0
        //backButton.backgroundColor = lightPink
        //backButton.tintColor = UIColor.white

        segmentedControl.tintColor = lightPink
        segmentedControl.backgroundColor = UIColor.white
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: blue], for: .normal)

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
