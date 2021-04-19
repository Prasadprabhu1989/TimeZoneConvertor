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
    @IBOutlet weak var tickMark2: UIImageView!
    //
    @IBOutlet weak var tickMark3: UIImageView!
    @IBOutlet weak var tickMark1: UIImageView!
    @IBOutlet weak var graphiteContentView: UIView!
    @IBOutlet weak var whiteContentView: UIView!
    @IBOutlet weak var blackContentView: UIView!

    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var graphiteLabel: UILabel!
    @IBOutlet weak var hoursContentView: UIView!
    override func viewDidLoad() {
        
        setColors()
        setCurrentTheme()
        tableView.tableFooterView = UIView()
        
    }
    func setCurrentTheme(){
        let theme = ThemeManager.currentTheme()
        switch theme {
               case .theme1:
                   tickMark1.image = #imageLiteral(resourceName: "Tick")
                   
               case .white:
                   tickMark2.image = #imageLiteral(resourceName: "Tick")
                   
               default:
                   tickMark3.image = #imageLiteral(resourceName: "Tick")
               }
               setTickTintColor()
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
        self.hoursContentView.backgroundColor = theme.backgroundColor
        self.graphiteLabel.textColor = theme.subtitleTextColor
        self.whiteLabel.textColor = theme.subtitleTextColor
        self.blackLabel.textColor = theme.subtitleTextColor
         self.graphiteContentView.backgroundColor = theme.backgroundColor
         self.whiteContentView.backgroundColor = theme.backgroundColor
         self.blackContentView.backgroundColor = theme.backgroundColor
        //
        if hoursStyle == .twentyfourHour {
            hourStyleSwitch.isOn = true
            self.twetyFourHourStyleLabel.textColor = theme.titleTextColor
        }
        
      
        
        
    }
    func setTickTintColor(){
        tickMark1.tint(color: ThemeManager.currentTheme().navigationBarTint)
        tickMark2.tint(color: ThemeManager.currentTheme().navigationBarTint)
        tickMark3.tint(color: ThemeManager.currentTheme().navigationBarTint)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            tickMark1.image = #imageLiteral(resourceName: "Tick")
            tickMark2.image = nil
            tickMark3.image = nil
              ThemeManager.applyTheme(theme: .theme1)
            
        case 2:
            tickMark2.image = #imageLiteral(resourceName: "Tick")
            tickMark1.image = nil
            tickMark3.image = nil
             ThemeManager.applyTheme(theme: .white)
        case 3:
            tickMark3.image = #imageLiteral(resourceName: "Tick")
            tickMark1.image = nil
            tickMark2.image = nil
              ThemeManager.applyTheme(theme: .black)
            
        default: break
            
        }
        setTickTintColor()
        setColors()
        applyTheme!()
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
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
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
