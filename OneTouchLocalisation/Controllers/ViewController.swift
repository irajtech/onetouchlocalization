//
//  ViewController.swift
//  OneTouchLocalisation
//
//  Created by Raj. on 27/02/2021.
//  Copyright © 2020 Raj. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var salutation: UILabel!

    @IBOutlet weak var readyToStart: UIButton!

    @IBOutlet weak var languageSegments: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        languageSegments.selectedSegmentIndex = UserSettings.shared.userSegment ?? 0
        configureSalutation()
        confiureReadyToStart()
    }
    
    func configureSalutation() {
        salutation.text = "Welcome".localized(comment: "Hello")
    }
    
    func confiureReadyToStart() {
        readyToStart.setTitle("Are you ready".localized(comment: "Ready button"), for: .normal)
    }

    @IBAction func languageChanger(_ sender: Any) {
        switch languageSegments.selectedSegmentIndex {
        case 0: // English
            UserSettings.shared.userSegment = languageSegments.selectedSegmentIndex
            LocalizationManager.setLanguageTo("en")
        case 1: // Netherlands
            UserSettings.shared.userSegment = languageSegments.selectedSegmentIndex
            LocalizationManager.setLanguageTo("nl")
        case 2: // Germany
            UserSettings.shared.userSegment = languageSegments.selectedSegmentIndex
            LocalizationManager.setLanguageTo("de")
        default:
            break
        }
    }
}

