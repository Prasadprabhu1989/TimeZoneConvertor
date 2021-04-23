//
//  SettingsVC.swift
//  TimeZoneTrack
//
//  Created by Anantha on 22/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var selectThemeCell: UITableViewCell!
    @IBOutlet weak var graphiteCell: UITableViewCell!
    @IBOutlet weak var blackCell: UITableViewCell!
    @IBOutlet weak var hoursTimeCell: UITableViewCell!
    @IBOutlet weak var timeZoneNameCell: UITableViewCell!
    @IBOutlet weak var whiteCell: UITableViewCell!
    @IBOutlet weak var aboutCell: UITableViewCell!
    @IBOutlet weak var hourStyleSwitch: UISwitch!
    @IBOutlet weak var selectThemeLabel: UILabel!
    @IBOutlet weak var timeZoneNameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var timeZoneSwitch: UISwitch!
    var hoursStyle: HoursStyle = .twentyfourHour
    var isTimeZoneOn: Bool = false
    var completionHandler:((_ hoursStyle:HoursStyle?) ->())!
    var applyTheme :(() -> ())?
    var timeZoneToggle:((Bool) ->())?
    //
    //
    //    @IBOutlet weak var selectThemeLabel: UILabel!
    @IBOutlet weak var twetyFourHourStyleLabel: UILabel!
    @IBOutlet weak var tickMark2: UIImageView!
    //
    @IBOutlet weak var tickMark3: UIImageView!
    @IBOutlet weak var tickMark1: UIImageView!
  
    
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var graphiteLabel: UILabel!
   
    var theme = ThemeManager.currentTheme()
    override func viewDidLoad() {
        
        setColors()
        setCurrentTheme()
        removeBorderForCell()
        configureTimeZone()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = theme.seperatorViewColor
        let isTwetyFourHour = hoursStyle == .twentyfourHour ? true : false
        checkSwitchState(isOn: isTwetyFourHour, label: twetyFourHourStyleLabel)
        checkSwitchState(isOn: isTimeZoneOn, label: timeZoneNameLabel)
    }
    
    func configureTimeZone(){
        timeZoneSwitch.isOn = isTimeZoneOn
    }
    
    func setCurrentTheme(){
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
        return 7
    }
    
    func removeBorderForCell(){
        selectThemeCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        selectThemeCell.directionalLayoutMargins = .zero
        graphiteCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        graphiteCell.directionalLayoutMargins = .zero
        whiteCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        whiteCell.directionalLayoutMargins = .zero
        
    }
    func setCellColors<T: UITableViewCell>(_ cell: T){
        cell.backgroundColor = theme.backgroundColor
    }
    func setTextColor<T: UILabel>( _ label: T){
        label.textColor = theme.titleTextColor
    }
    func setColors(){
        
        self.view.backgroundColor = theme.backgroundColor
        
        self.tableView.backgroundColor = theme.backgroundColor
        //
        hourStyleSwitch.isOn = false

        setCellColors(self.graphiteCell)
        setCellColors(self.whiteCell)
        setCellColors(self.blackCell)
        setCellColors(self.aboutCell)
        setCellColors(self.hoursTimeCell)
         setCellColors(self.selectThemeCell)
        setCellColors(self.timeZoneNameCell)
        setTextColor(self.timeZoneNameLabel)
        
        setTextColor(self.twetyFourHourStyleLabel)
        setTextColor(self.graphiteLabel)
          setTextColor(self.whiteLabel)
          setTextColor(self.blackLabel)
          setTextColor(self.timeZoneNameLabel)
          setTextColor(self.aboutLabel)
         setTextColor(self.selectThemeLabel)
//        self.timeZoneSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.theme.titleTextColor], for: .selected)

    // color of other options
//        self.timeZoneSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.theme.backgroundColor], for: .selected)
//         self.timeZoneSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.theme.titleTextColor], for: .normal)

//        self.timeZoneSegment.tintColor = .red
//         self.timeZoneSegment.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.seperatorViewColor
        //
        if hoursStyle == .twentyfourHour {
            hourStyleSwitch.isOn = true
            self.twetyFourHourStyleLabel.textColor = theme.titleTextColor
        }

        setSwitchColor(self.hourStyleSwitch)
        setSwitchColor(self.timeZoneSwitch)
    }
    
    func setSwitchColor<T: UISwitch>(_ switchButton: T){
        switchButton.tintColor = .white
        switchButton.layer.cornerRadius = hourStyleSwitch.frame.height / 2.0
        switchButton.backgroundColor = .white
        switchButton.clipsToBounds = true
    }
    
    func setTickTintColor(){
        tickMark1.tint(color: theme.navigationBarTint)
        tickMark2.tint(color: theme.navigationBarTint)
        tickMark3.tint(color: theme.navigationBarTint)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if  indexPath.row > 1{
            switch indexPath.row {
            case 3:
                tickMark1.image = #imageLiteral(resourceName: "Tick")
                tickMark2.image = nil
                tickMark3.image = nil
                ThemeManager.applyTheme(theme: .theme1)
                
            case 4:
                tickMark2.image = #imageLiteral(resourceName: "Tick")
                tickMark1.image = nil
                tickMark3.image = nil
                ThemeManager.applyTheme(theme: .white)
            case 5:
                tickMark3.image = #imageLiteral(resourceName: "Tick")
                tickMark1.image = nil
                tickMark2.image = nil
                ThemeManager.applyTheme(theme: .black)
                
            case 6:
                showAboutScreen()
                
                
                
            default: break
                
            }
            self.theme = ThemeManager.currentTheme()
            setTickTintColor()
            setColors()
            applyTheme!()
        }
    }
    func showAboutScreen(){
        let aboutController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "AboutViewController") as AboutViewController
//        aboutController.modalPresentationStyle = .fullScreen
        present(aboutController, animated: true, completion: nil)
        
    }
    
    @IBAction func toggleTimeZone(_ sender: UISwitch) {
        checkSwitchState(isOn: sender.isOn, label: timeZoneNameLabel)
//        if sender.isOn {
//            timeZoneNameLabel.textColor = theme.titleTextColor
//        } else {
//            self.timeZoneNameLabel.textColor = theme.subtitleTextColor
//        }
        self.timeZoneToggle?(sender.isOn)
    }
    
    func checkSwitchState(isOn: Bool, label: UILabel) {
        if isOn {
            label.textColor = theme.titleTextColor
        } else {
            label.textColor = theme.subtitleTextColor
        }
    }
    
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func hoursStyleSwitchValueChanged(_ sender: UISwitch) {
        hoursStyle = sender.isOn ? .twentyfourHour : .twelveHour
        checkSwitchState(isOn: sender.isOn, label: twetyFourHourStyleLabel)
//        if sender.isOn {
//            hoursStyle = .twentyfourHour
//            twetyFourHourStyleLabel.textColor = theme.titleTextColor
//        } else {
//            hoursStyle = .twelveHour
//            self.twetyFourHourStyleLabel.textColor = theme.subtitleTextColor
//
//        }
        
        self.completionHandler(hoursStyle)
    }
    
}
