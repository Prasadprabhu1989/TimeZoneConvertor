//
//  TimeZoneHelperModel.swift
//  TimeZoneTrack
//
//  Created by Anantha on 25/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import Foundation
import CoreData

protocol RefreshViewOnHomeTimeZoneChangeDelegate {
    func refreshView()
}

class TimeZoneHelperModel {
    
    var timeZoneArray: [TimeZoneModel] = []
    var coredataManager = CoreDataManager.shared
    var refreshViewOnHomeTimeZoneChange: RefreshViewOnHomeTimeZoneChangeDelegate?
    
    init(refreshViewOnHomeTimeZoneChange: RefreshViewOnHomeTimeZoneChangeDelegate? = nil) {
        if !UserDefaults.standard.bool(forKey: "FetchOnce") {
            loadTimeZone()
            UserDefaults.standard.set(true, forKey: "FetchOnce")
        }
        self.refreshViewOnHomeTimeZoneChange = refreshViewOnHomeTimeZoneChange
    }
    
    func loadTimeZone() {
        var id = 0
        let context = coredataManager.mainContext
        let timezoneModelArray = TimeZone.knownTimeZoneIdentifiers.sorted().map { (timezone) -> TimeZoneModel in
            let cityName = timezone.components(separatedBy: "/").last ?? timezone
            let cityNameUpdated = cityName.replacingOccurrences(of: "_", with: " ")
            
            let timezoneModal = TimeZoneModel.init(context: context)
            timezoneModal.setValue(cityNameUpdated, forKey: "name")
            timezoneModal.setValue(timezone, forKey: "timeZone")
            timezoneModal.setValue(id, forKey: "id")
            timezoneModal.setValue(false, forKey: "isSelected")
            id += 1
            return timezoneModal
        }
        
        setDefaultTimezone(timezoneModelArray)
    }
    
    
    func setDefaultTimezone(_ timeZoneModelArray: [TimeZoneModel]) {
        
        let context = coredataManager.mainContext
        var isHomeFirstModel = true
        var orderNo = 0
        let filteredTimeZone = timeZoneModelArray.filter({ $0.name == "London" || $0.name == "Moscow" || $0.name == "Calcutta" })
        
        filteredTimeZone.forEach { (timezoneModel) in
            timezoneModel.isSelected = true
            
            let selectedTimezone = SelectedTimeZone.init(context: context)
            selectedTimezone.setValue(timezoneModel.id, forKey: "id")
            selectedTimezone.setValue(timezoneModel.name, forKey: "name")
            selectedTimezone.setValue(timezoneModel.timeZone, forKey: "timeZone")
            selectedTimezone.setValue(orderNo, forKey: "orderNo")
            selectedTimezone.setValue(isHomeFirstModel, forKey: "homeTimeZone")
            isHomeFirstModel = false
            orderNo += 1
        }
        
        coredataManager.saveContext()
        
    }
    
    func fetchAllNonSelectedTimeZone() -> [TimeZoneModel] {
        let fetchRequest: NSFetchRequest<TimeZoneModel> = TimeZoneModel.fetchRequest()
        let predicate = NSPredicate(format: "isSelected == false")
        fetchRequest.predicate = predicate
        let sort = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var nonSeletedTimeZone = [TimeZoneModel]()
        do {
            nonSeletedTimeZone = try coredataManager.mainContext.fetch(fetchRequest)
            //            print("\(nonSeletedTimeZone.count) Non SelectedTimezone")
            
        } catch {
            //            print("Fetch failed")
        }
        return nonSeletedTimeZone
    }
    
    func fetchSelectedTimeZone(_ filterPredicate: String? = nil) -> [SelectedTimeZone] {
        let fetchRequest: NSFetchRequest<SelectedTimeZone> = SelectedTimeZone.fetchRequest()
        let sort = NSSortDescriptor(key: "orderNo", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        if let filterPredicate = filterPredicate {
            fetchRequest.predicate = NSPredicate(format: filterPredicate)
        }
        var selectedTimeZone = [SelectedTimeZone]()
        do {
            selectedTimeZone = try coredataManager.mainContext.fetch(fetchRequest)
            //            print("\(selectedTimeZone.count) selectedTimezone")
            
        } catch {
            //            print("Fetch failed")
        }
        return selectedTimeZone
    }
    
    func updateSelectedTimeZone(_ timeZoneModel: TimeZoneModel, orderNo: Int) {
        
        let context = coredataManager.mainContext
        //        print(orderNo)
        let selectedTimezone = SelectedTimeZone.init(context: context)
        selectedTimezone.setValue(timeZoneModel.id, forKey: "id")
        selectedTimezone.setValue(timeZoneModel.name, forKey: "name")
        selectedTimezone.setValue(timeZoneModel.timeZone, forKey: "timeZone")
        selectedTimezone.setValue(orderNo, forKey: "orderNo")
        if orderNo == 0 {
            selectedTimezone.setValue(true, forKey: "homeTimeZone")
        }
        
        timeZoneModel.isSelected = true
        
        coredataManager.saveContext()
    }
    
    func deleteSelectedTimeZone(_ indexPath: Int, _ listOfTimeZone: [SelectedTimeZone], _ timezoneModel: SelectedTimeZone) {
        for timeZone in listOfTimeZone {
            //            print(timeZone)
            if timeZone.orderNo < indexPath {
            } else if timeZone.orderNo > indexPath {
                timeZone.orderNo -= 1
            }
        }
        updateTimeZoneToUnselected(id: timezoneModel.id)
        deleteObject(timezoneModel)
    }
    
    func deleteObject(_ timeZoneModel: SelectedTimeZone) {
        coredataManager.mainContext.delete(timeZoneModel)
        coredataManager.saveContext()
    }
    
    func updateTimeZoneToUnselected(id: Int64) {
        let fetchRequest: NSFetchRequest<TimeZoneModel> = TimeZoneModel.fetchRequest()
        let predicate = NSPredicate(format: "id == %d",id)
        
        fetchRequest.predicate = predicate
        do {
            let timezones = try coredataManager.mainContext.fetch(fetchRequest)
            for timezone in timezones {
                timezone.isSelected = false
            }
        } catch {
            //            print("Fetch failed")
        }
        coredataManager.saveContext()
    }
    
    func reArrangeOrder(_ sourceIndex: Int, _ destinationIndex: Int, _ listOfTimeZone: [SelectedTimeZone]) {
        for timeZone in listOfTimeZone {
            // 1
            if sourceIndex > destinationIndex {
                
                if sourceIndex < timeZone.orderNo {
                    continue
                }
                
                if timeZone.orderNo < destinationIndex {
                    continue
                }
            }
            
            // 2
            if sourceIndex < destinationIndex {
                if sourceIndex > timeZone.orderNo {
                    continue
                }
                
                if destinationIndex < timeZone.orderNo {
                    continue
                }
            }
            
            if timeZone.orderNo < sourceIndex {
                timeZone.orderNo += 1
            } else if timeZone.orderNo > sourceIndex {
                timeZone.orderNo -= 1
            } else if timeZone.orderNo == sourceIndex {
                timeZone.orderNo = Int64(destinationIndex)
            }
        }
        coredataManager.saveContext()
    }
    
    func updateHomeTimeZone(_ selectedTimeZone: SelectedTimeZone) {
        
        if let currentHomeTimeZone = fetchCurrentHomeTimeZone() {
            currentHomeTimeZone.homeTimeZone = false
        }
        
        selectedTimeZone.homeTimeZone = true
        
        coredataManager.saveContext()
        
        if let refreshViewOnHomeTimeZoneReference = refreshViewOnHomeTimeZoneChange {
            refreshViewOnHomeTimeZoneReference.refreshView()
        }
    }
    
    func fetchCurrentHomeTimeZone() -> SelectedTimeZone? {
        return fetchSelectedTimeZone("homeTimeZone == true").first
    }
    
    func getHoursArray(_ hoursStyle: HoursStyle) -> [String] {
        if hoursStyle == .twelveHour {
            return ["12:00 AM","12:30 AM", "1:00 AM", "1:30 AM","2:00 AM","2:30 AM", "3:00 AM", "3:30 AM", "4:00 AM", "4:30 AM", "5:00 AM", "5:30 AM", "6:00 AM", "6:30 AM", "7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM","9:00 AM", "9:30 AM","10:00 AM", "10:30 AM","11:00 AM", "11:30 AM","12:00 PM","12:30 PM", "1:00 PM", "1:30 PM","2:00 PM", "2:30 PM","3:00 PM","3:30 PM", "4:00 PM","4:30 PM", "5:00 PM","5:30 PM", "6:00 PM","6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM","9:00 PM", "9:30 PM","10:00 PM", "10:30 PM","11:00 PM","11:30 PM"]
        } else {
            return ["00:00", "00:30", "01:00", "01:30", "02:00", "02:30", "03:00", "03:30", "04:00", "04:30", "05:00", "05:30", "06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30","10:00", "10:30", "11:00", "11:30", "12:00", "12:30","13:00", "13:30", "14:00","14:30",
                    "15:00", "15:30", "16:00","16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "23:30",]
        }
    }
    
    func set(from date: Date, format: String, timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone   = timeZone
        
        if format == "" {
            formatter.dateStyle = .medium
        }
        
        return formatter.string(from: date)
    }
    
    func getDay(date: Date, timeZone: TimeZone) -> DayType{
        
        let selectedHour = set(from: date, format: HoursStyle.onlyHour.rawValue, timeZone: timeZone)
        let hour = Int(selectedHour)!
    
        var day = DayType.Night
        if hour >= 5 && hour < 12
        {
            day = DayType.Morning
        }
        else if hour >= 12 && hour < 17
        {
            day = DayType.Noon
        }
        else if hour >= 17 && hour < 20
        {
            day = DayType.Evening
        }
        return day
    }
    
    func getSelectedHourIndex(_ date: Date, offsetDay: Int = 0, offsetHour: Int = 0 ) -> Int {
        guard let homeTimeZone = fetchCurrentHomeTimeZone(),
            let timezoneString = homeTimeZone.timeZone,
            let timezone = TimeZone(identifier: timezoneString) else { return -1 }
        var currentDateTime = date
        if offsetHour != 0 || offsetDay != 0 {
            currentDateTime = currentDateTime.setTime(offsetDay, offsetHour, timezone) ?? date
        }
        
        let selectedHour = set(from: currentDateTime, format: HoursStyle.onlyHour.rawValue, timeZone: timezone)
        let dateCeild = currentDateTime.nearestHour() ?? currentDateTime
        let minute = set(from: dateCeild, format: HoursStyle.onlyMinute.rawValue, timeZone: timezone)
        let minuteIndex = (Int(minute) ?? 0)/30
        let selectedIndex = ((Int(selectedHour) ?? 0) * 2) + minuteIndex
        return selectedIndex
    }
    
}

enum DayType{
    case Morning
    case Noon
    case Evening
    case Night
}
