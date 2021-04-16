//
//  SettingsViewController.swift
//  TimeZoneTrack
//
//  Created by Prasad Prabhu on 16/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    @IBOutlet weak var themeSegment: UISegmentedControl!
    @IBOutlet weak var hourStyleSwitch: UISwitch!
    var hoursStyle: HoursStyle = .twentyfourHour
    var completionHandler:((_ hoursStyle:HoursStyle?) ->())!
    let theme = ThemeManager.currentTheme()

    @IBOutlet weak var twetyFourHourStyleLabel: UILabel!
    
    override func viewDidLoad() {
        self.view.backgroundColor = theme.backgroundColor
         hourStyleSwitch.isOn = false
        self.twetyFourHourStyleLabel.textColor = self.theme.subtitleTextColor
       
        if hoursStyle == .twentyfourHour {
            hourStyleSwitch.isOn = true
              self.twetyFourHourStyleLabel.textColor = self.theme.titleTextColor
        }
        
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        
    }
    
    
    
    @IBAction func hoursStyleSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            hoursStyle = .twentyfourHour
            twetyFourHourStyleLabel.textColor = theme.titleTextColor
        } else {
            hoursStyle = .twelveHour
             self.twetyFourHourStyleLabel.textColor = self.theme.subtitleTextColor

        }

        self.completionHandler(hoursStyle)
    }
}
