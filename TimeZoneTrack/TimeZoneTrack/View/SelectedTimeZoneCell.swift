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
    @IBOutlet weak var cityTimeZoneOffsetLabel: UILabel!
    
    @IBOutlet weak var localTimeZoneLabel: UILabel!
    
    @IBOutlet weak var homeTimeZoneButton: UIButton!
    @IBOutlet weak var timeDiffrenceLabel: UILabel!
    
    var timeZoneHelperModel = TimeZoneHelperModel()
    weak var homeTimeZoneButtonClickedDelegate: HomeTimeZoneButtonClickedDelegate?
    var currentDateTime: Date!
    
    func updateUI(with date: Date, selectedTimeZone: SelectedTimeZone, hourStyle: HoursStyle, offsetHour: Int = 0, offsetDay: Int = 0) {
        
        var timeInterval = TimeInterval()
        
        if let cityName = selectedTimeZone.name {
            cityNameLabel.text = cityName.uppercased()
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
            cityTimeLabel.text = timeZoneHelperModel.set(from: currentDateTime, format: hourStyle.rawValue, timeZone: timezone)
            cityDateLabel.text = timeZoneHelperModel.set(from: currentDateTime, format: DateDisplayStyle.weekmonthday.rawValue, timeZone: timezone )
            cityTimeZoneOffsetLabel.text = timezone.localizedName(for: .standard, locale: .current) ?? ""
            localTimeZoneLabel.text = timezone.abbreviation(for: currentDateTime)
//            localTimeZoneLabel.text = timezone.offset()
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
    
}
