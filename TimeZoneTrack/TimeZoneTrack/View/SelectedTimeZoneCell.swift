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
    
    var timeZoneHelperModel = TimeZoneHelperModel()
    let theme = ThemeManager.currentTheme()
    
    weak var homeTimeZoneButtonClickedDelegate: HomeTimeZoneButtonClickedDelegate?
    var currentDateTime: Date!
    
    func updateUI(with date: Date, selectedTimeZone: SelectedTimeZone, hourStyle: HoursStyle, offsetHour: Int = 0, offsetDay: Int = 0) {
        
        let timeInterval = TimeInterval()
        
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
            
         
            // DayLightSave-TODO
            //            timeInterval = timeZoneHelperModel.checkDayLightSaving(currentDateTime, timezone)
            //            currentDateTime = currentDateTime.addingTimeInterval(timeInterval)
            
           // print(currentDateTime)
            let timeString = timeZoneHelperModel.set(from: currentDateTime, format: hourStyle.rawValue, timeZone: timezone)
            let dayType = timeZoneHelperModel.getDay(date: currentDateTime,timeZone:timezone)
            debugPrint("dayType \(dayType)")
           
            if dayType == .Night{
                dayTypeImageView.image = #imageLiteral(resourceName:"Night")
            }
            else{
                dayTypeImageView.image = #imageLiteral(resourceName:"Day")
            }
             dayTypeImageView.tint(color: UIColor.white)
            
            
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
            localTimeZoneLabel.text = timezone.localizedName(for: .standard, locale: .current) ?? ""
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
                timeDiffrenceLabel.text = timeDiffrenceBetween(timeOffset1: timezone.offset() + Int(timeInterval), timeOffset2: homeTimezone.offset())
                
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

        contentView.backgroundColor = theme.backgroundColor
        cityNameLabel.textColor = theme.titleTextColor
        cityTimeLabel.textColor = theme.titleTextColor
        amOrpmLabel.textColor = theme.titleTextColor
        cityDateLabel.textColor = theme.titleTextColor
        localTimeZoneLabel.textColor = theme.subtitleTextColor
        timeDiffrenceLabel.textColor = theme.subtitleTextColor
         //setBorder()
    }
    func setBorder(){
       
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        
    }
}
