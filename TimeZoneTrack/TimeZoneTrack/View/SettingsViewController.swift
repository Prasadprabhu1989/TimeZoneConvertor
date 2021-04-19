//
//  SettingsViewController.swift
//  TimeZoneTrack
//
//  Created by Prasad Prabhu on 16/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController{
    @IBOutlet weak var themeSegment: UISegmentedControl!
    @IBOutlet weak var hourStyleSwitch: UISwitch!
    var hoursStyle: HoursStyle = .twentyfourHour
    var completionHandler:((_ hoursStyle:HoursStyle?) ->())!
    var applyTheme :(() -> ())?
//
//
//    @IBOutlet weak var selectThemeLabel: UILabel!
    @IBOutlet weak var twetyFourHourStyleLabel: UILabel!
//
    override func viewDidLoad() {
        setColors()

    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
}



    func setColors(){
//
        let theme = ThemeManager.currentTheme()
        self.view.backgroundColor = theme.backgroundColor
        
        self.tableView.backgroundColor = theme.backgroundColor
//
//        hourStyleSwitch.isOn = false
        self.twetyFourHourStyleLabel.textColor = theme.subtitleTextColor
//
        if hoursStyle == .twentyfourHour {
            hourStyleSwitch.isOn = true
            self.twetyFourHourStyleLabel.textColor = theme.titleTextColor
        }
       
    }
    
//
//    @IBAction func changeTheme(_ sender: Any) {
//        let segmentControl = sender as! UISegmentedControl
//        switch segmentControl.selectedSegmentIndex {
//        case 0:
//            ThemeManager.applyTheme(theme: .theme1)
//
//        case 1:
//            ThemeManager.applyTheme(theme: .white)
//
//        default:
//            ThemeManager.applyTheme(theme: .black)
//        }
//        setColors()
//        applyTheme!()
//    }
//
//
//
    @IBAction func hoursStyleSwitchValueChanged(_ sender: UISwitch) {
        let theme = ThemeManager.currentTheme()
        if sender.isOn {
            hoursStyle = .twentyfourHour
            twetyFourHourStyleLabel.textColor = theme.titleTextColor
        } else {
            hoursStyle = .twelveHour
            self.twetyFourHourStyleLabel.textColor = theme.subtitleTextColor

        }

//        self.completionHandler(hoursStyle)
    }
//}
}
