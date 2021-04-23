//
//  SelectedTimeZoneCell.swift
//  TimeZoneTrack
//
//  Created by Anantha on 26/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

protocol HomeTimeZoneButtonClickedDelegate: class {
    func didHomeButtonClicked(_ sender: UITableViewCell)
}

class SelectedTimeZoneCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTimeLabel: UILabel!
    @IBOutlet weak var cityDateLabel: UILabel!
    
    @IBOutlet weak var localTimeZoneLabel: UILabel!
    
    @IBOutlet weak var dayTypeImageView: UIImageView!
    @IBOutlet weak var homeTimeZoneButton: UIButton!
    @IBOutlet weak var timeDiffrenceLabel: UILabel!
    @IBOutlet weak var amOrpmLabel: UILabel!
  
    @IBOutlet weak var trailingTimeLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingAmPmLabelConstraint: NSLayoutConstraint!
    
    
    var timeZoneHelperModel = TimeZoneHelperModel()
    let theme = ThemeManager.currentTheme()
    
    weak var homeTimeZoneButtonClickedDelegate: HomeTimeZoneButtonClickedDelegate?
    var currentDateTime: Date!
    
    func updateUI(with date: Date, selectedTimeZone: SelectedTimeZone, hourStyle: HoursStyle, offsetHour: Int = 0, offsetDay: Int = 0, isLocalTimeZoneNameShown: Bool = false) {
         setThemes()
        
        if let cityName = selectedTimeZone.name {
            cityNameLabel.text = cityName.capitalized
        }
        
        if let cityTimeZone = selectedTimeZone.timeZone {
            guard let timezone = TimeZone(identifier: cityTimeZone) else { return }
            
            if offsetHour != 0 || offsetDay != 0 {
                currentDateTime = date.nearestHour()
                currentDateTime = currentDateTime.setTime(offsetDay, offsetHour, timezone)
            } else {
                currentDateTime = date
            }
            
           // print(currentDateTime)
            let timeString = timeZoneHelperModel.set(from: currentDateTime, format: hourStyle.rawValue, timeZone: timezone)
            let dayType = timeZoneHelperModel.getDay(date: currentDateTime, timeZone: timezone)
            debugPrint("dayType \(dayType)")
           
            if dayType == .Night{
                dayTypeImageView.image = #imageLiteral(resourceName:"Night")
            }
            else{
                dayTypeImageView.image = #imageLiteral(resourceName:"Day")
            }
             
            dayTypeImageView.tint(color: ThemeManager.currentTheme().DaySelectionColor)
            
            if hourStyle == .twelveHour {
                let arrayOfTime = timeString.components(separatedBy: " ")
                if arrayOfTime.count > 1 {
                    cityTimeLabel.text = arrayOfTime.first ?? ""
                    amOrpmLabel.text = arrayOfTime[1]

                } else {
                   cityTimeLabel.text = timeString
                   amOrpmLabel.text = ""

                }
            } else {
                cityTimeLabel.text = timeZoneHelperModel.set(from: currentDateTime, format: hourStyle.rawValue, timeZone: timezone)
                amOrpmLabel.text = ""

            }
            cityDateLabel.text = timeZoneHelperModel.set(from: currentDateTime, format: DateDisplayStyle.weekmonthday.rawValue, timeZone: timezone )
            if isLocalTimeZoneNameShown {
                localTimeZoneLabel.text = timezone.localizedName(for: .standard, locale: .current) ?? ""
            }
            
        }
        
        if selectedTimeZone.homeTimeZone {
            homeTimeZoneButton.setImage(UIImage(named: "home-filled-blue"), for: .normal)
            timeDiffrenceLabel.text = ""
        } else {
            homeTimeZoneButton.setImage(UIImage(named: "home-unfill-blue"), for: .normal)
    
            if let homeTimeZone = timeZoneHelperModel.fetchCurrentHomeTimeZone(),
                let homeCityTimeZone = homeTimeZone.timeZone,
                let homeTimezone = TimeZone(identifier: homeCityTimeZone),
                let cityTimeZone = selectedTimeZone.timeZone,
                let timezone = TimeZone(identifier: cityTimeZone) {
                timeDiffrenceLabel.text = timeDiffrenceBetween(timeOffset1: timezone.offset(currentDateTime) , timeOffset2: homeTimezone.offset(currentDateTime))
            } else {
                timeDiffrenceLabel.text = ""
            }
        }
    }
    
    func timeDiffrenceBetween(timeOffset1: Int, timeOffset2: Int) -> String {
        let hours = Int(timeOffset1 - timeOffset2)/3600
        let minutes =  abs(Int(timeOffset1 - timeOffset2)/60 % 60)
        let minutesString = minutes > 0 ? ":\(minutes)" : ""
        return hours >= 0 ? "+\(hours)\(minutesString)" : "\(hours)\(minutesString)"
    }
    
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        homeTimeZoneButtonClickedDelegate?.didHomeButtonClicked(self)
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()

       setThemes()
    }
    
    func setThemes(){
        contentView.backgroundColor = ThemeManager.currentTheme().tableviewCellBackgroundColor
        cityNameLabel.textColor = ThemeManager.currentTheme().titleTextColor
        cityTimeLabel.textColor = ThemeManager.currentTheme().titleTextColor
        amOrpmLabel.textColor = ThemeManager.currentTheme().titleTextColor
        cityDateLabel.textColor = ThemeManager.currentTheme().titleTextColor
        if let locatioTimeZoneLabel = localTimeZoneLabel {
            locatioTimeZoneLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        }
        timeDiffrenceLabel.textColor = ThemeManager.currentTheme().subtitleTextColor
        
    }
}
