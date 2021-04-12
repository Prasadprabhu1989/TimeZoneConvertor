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
//                    print(timeZone.cityName ?? "")
                    continue
                }
                
                if timeZone.orderNo < destinationIndex {
//                    print(timeZone.cityName ?? "")
                    continue
                }
            }
            
            // 2
            if sourceIndex < destinationIndex {
               
                if sourceIndex > timeZone.orderNo {
//                    print(timeZone.cityName ?? "")
                    continue
                }
                
                if destinationIndex < timeZone.orderNo {
//                    print(timeZone.cityName ?? "")
                    continue
                }
            }
            
//            let tmp = timeZone.orderNo
            
            if timeZone.orderNo < sourceIndex {
                timeZone.orderNo += 1
            } else if timeZone.orderNo > sourceIndex {
                timeZone.orderNo -= 1
            } else if timeZone.orderNo == sourceIndex {
                timeZone.orderNo = Int64(destinationIndex)
            }
            
//            print(timeZone.cityName, tmp, timeZone.orderNo)
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
            return ["12:00 12:59 AM", "01:00 01:59 AM", "02:00 02:59 AM", "03:00 03:59 AM", "04:00 04:59 AM", "05:00 05:59 AM", "06:00 06:59 AM", "07:00 07:59 AM", "08:00 08:59 AM", "09:00 09:59 AM", "10:00 10:59 AM", "11:00 11:59 AM", "12:00 12:59 PM", "01:00 01:59 PM", "02:00 02:59 PM", "03:00 03:59 PM", "04:00 04:59 PM", "05:00 05:59 PM", "06:00 06:59 PM", "07:00 07:59 PM", "08:00 08:59 PM", "09:00 09:59 PM", "10:00 10:59 PM", "11:00 11:59 PM"]
        } else {
            return ["00:00 00:59", "01:00 01:59", "02:00 02:59", "03:00 03:59", "04:00 04:59", "05:00 05:59", "06:00 06:59", "07:00 07:59", "08:00 08:59", "09:00 09:59", "10:00 10:59", "11:00 11:59", "12:00 12:59", "13:00 13:59", "14:00 14:59",
            "15:00 15:59", "16:00 16:59", "17:00 17:59", "18:00 18:59", "19:00 19:59", "20:00 20:59", "21:00 21:59", "22:00 22:59", "23:00 23:59"]
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
    
    func getSelectedHourIndex(_ date: Date) -> Int {
        guard let homeTimeZone = fetchCurrentHomeTimeZone(),
            let timezoneString = homeTimeZone.timeZone,
            let timezone = TimeZone(identifier: timezoneString) else { return -1 }
            
        let selectedHour = set(from: date, format: HoursStyle.onlyHour.rawValue, timeZone: timezone)
        
        return Int(selectedHour) ?? -1
    }

}
