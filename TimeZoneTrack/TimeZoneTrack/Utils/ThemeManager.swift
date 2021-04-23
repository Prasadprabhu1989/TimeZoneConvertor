//
//  ThemeManager.swift
//  TimeZoneTrack
//
//  Created by Anantha on 13/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit
import Foundation


enum Theme: Int {
    
    case theme1, theme2, theme3, theme4,white, black
    
    var navigationBarTint: UIColor {
        switch self {
        case .theme1:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        case .theme2:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        case .theme3:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        case .theme4:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        case .white:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
            case .black:
                   return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        }
       
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .theme1:
            return .default
        case .theme2:
            return .black
        case .theme3:
            return .default
        case .theme4:
            return .default
        case .white:
            return .default
        case .black:
            return .default
        }
    }
    
    var isTransulent: Bool {
        return false
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 1.0)
        case .theme2:
            return UIColor(red: 19/255, green: 25/255, blue: 50/255, alpha: 1.0)
        case .theme3:
            return UIColor(red: 49/255, green: 44/255, blue: 81/255, alpha: 1.0)
        case .theme4:
            return UIColor(red: 42/255, green: 45/255, blue: 73/255, alpha: 1.0)
        case .white:
            return UIColor(red: 239/255, green: 240/255, blue: 244/255, alpha: 1.0)
        case .black:
            return .black
        }
    }
    var calendarBackgroundColor: UIColor {
           switch self {
           case .theme1:
               return UIColor(red: 73/255, green: 73/255, blue: 84/255, alpha: 1.0)
           case .theme2:
               return UIColor(red: 19/255, green: 25/255, blue: 50/255, alpha: 1.0)
           case .theme3:
               return UIColor(red: 49/255, green: 44/255, blue: 81/255, alpha: 1.0)
           case .theme4:
               return UIColor(red: 42/255, green: 45/255, blue: 73/255, alpha: 1.0)
           case .white:
                return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
           case .black:
              return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 1.0)
        }
       }
    
    var tableviewCellBackgroundColor: UIColor {
           switch self {
           case .theme1:
               return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 1.0)
           case .theme2:
               return UIColor(red: 19/255, green: 25/255, blue: 50/255, alpha: 1.0)
           case .theme3:
               return UIColor(red: 49/255, green: 44/255, blue: 81/255, alpha: 1.0)
           case .theme4:
               return UIColor(red: 42/255, green: 45/255, blue: 73/255, alpha: 1.0)
           case .white:
               return UIColor.white
           case .black:
              return .black
        }
       }
    
    
//    var calendarBackgroundColor: UIColor {
//        switch self {
//        case .theme1:
//            return UIColor(red: 110/255, green: 37/255, blue: 64/255, alpha: 0.5)
//        case .theme2:
//            return UIColor(red: 102/255, green: 77/255, blue: 189/255, alpha: 0.5)
//        case .theme3:
//            return UIColor.darkGray
//        case .theme4:
//            return UIColor.darkGray
//        }
//    }
    
    var hoursRangeBackgroundColor: UIColor {
        switch self {
        case .theme1:
             return UIColor(red: 73/255, green: 73/255, blue: 84/255, alpha: 1.0)
//            return UIColor(red: 69/255, green: 87/255, blue: 129/255, alpha: 1.0)
        case .theme2:
            return UIColor(red: 48/255, green: 84/255, blue: 92/255, alpha: 1.0)
        case .theme3:
            return UIColor(red: 72/255, green: 66/255, blue: 108/255, alpha: 1.0)
        case .theme4:
            return UIColor(red: 43/255, green: 79/255, blue: 96/255, alpha: 1.0)
        case .white:
            //return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
            return UIColor.white
            case .black:
            return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 1.0)
        }
    }
    
    var seperatorViewColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.darkGray
        case .theme2:
            return UIColor.lightGray
        case .theme3:
            return UIColor.darkGray
        case .theme4:
            return UIColor.darkGray
        case .white:
            return UIColor.lightGray
        case .black:
            return UIColor.darkGray
        }
        
    }
    
    var tableViewBackGroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 0.5)
        case .theme2:
            return UIColor(red: 19/255, green: 25/255, blue: 50/255, alpha: 0.5)
        case .theme3:
            return UIColor(red: 49/255, green: 44/255, blue: 81/255, alpha: 0.5)
        case .theme4:
            return UIColor(red: 82/255, green: 52/255, blue: 73/255, alpha: 0.5)
        case .white:
            return UIColor(red: 239/255, green: 240/255, blue: 244/255, alpha: 1.0)
        case .black:
            return .black
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.white
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
            return UIColor.black
        case .black:
            return .white
        }
    }
    
    var subtitleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.lightGray
        case .theme2:
            return UIColor.gray
        case .theme3:
            return UIColor.lightGray
        case .theme4:
            return UIColor.lightGray
        case .white:
            return .darkGray
        case .black:
            return .lightGray
        }
        
    }
    
    var selectedRangeColor: UIColor {
        switch self {
        case .theme1:
            return UIColor(white: 0.7, alpha: 1)
            //            return UIColor(red: 125/255, green: 22/255, blue: 44/255, alpha: 0.4)
        //           return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 0.4)
        case .theme2:
            return UIColor.lightGray
        case .theme3:
            return UIColor(red: 77/255, green: 187/255, blue: 201/255, alpha: 0.4)
        case .theme4:
            return UIColor(red: 218/255, green: 114/255, blue: 60/255, alpha: 0.4)
        case .white:
            return UIColor(red: 218/255, green: 114/255, blue: 60/255, alpha: 0.4)
        case .black:
            return .white
        }
    }
    var DaySelectionColor: UIColor{
        switch self {
        case .theme1:
            return UIColor.white
           // return UIColor(red: 105/255, green: 215/255, blue: 228/255, alpha: 1.0)
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor.black
        case .black:
            return .white
        }
    }
    var segmentColor: UIColor{
        switch self {
        case .theme1:
            return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 1.0)
        case .theme2:
                   return UIColor(red: 19/255, green: 25/255, blue: 50/255, alpha: 1.0)
               case .theme3:
                   return UIColor(red: 49/255, green: 44/255, blue: 81/255, alpha: 1.0)
               case .theme4:
                   return UIColor(red: 42/255, green: 45/255, blue: 73/255, alpha: 1.0)
            
        case .white:
            return .black
        case .black:
            return .black
        }
    }
    var selectedRangeBorderColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.white
           // return UIColor(red: 105/255, green: 215/255, blue: 228/255, alpha: 1.0)
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor.lightGray
        case .black:
            return .white
        }
    }
    var reorderTableViewColor: UIColor{
        switch self {
        case .white:
            return .black
            
       @unknown default:
        return .white
        }
    }

    var calendarPickerBackground: UIColor {
        switch self {
        case .theme1:
            return UIColor(red: 58/255, green: 58/255, blue: 71/255, alpha: 1.0)
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        case .black:
            return UIColor.black
        }
    }

    var calendarPickerDayMonthLabelColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.white
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor.black
        case .black:
            return UIColor.white
        }
    }

    var calendarPickerButtonTitleColor: UIColor {
        switch self {
        case .theme1:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        case .black:
            return UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        }
    }

    var calendarPickerCloseButtonColor: UIColor {
        switch self {
        case .theme1:
            return UIColor.white
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.6)
        case .black:
            return UIColor.white
        }
    }
    
    var calendarDateOutsideCurrentMonth : UIColor {
        switch self {
        case .theme1:
            return UIColor.lightGray.withAlphaComponent(0.4)
        case .theme2:
            return UIColor.white
        case .theme3:
            return UIColor.white
        case .theme4:
            return UIColor.white
        case .white:
               return UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.4)
        case .black:
            return UIColor.lightGray.withAlphaComponent(0.4)
        }
        
    }
}


// Enum declaration
let SelectedThemeKey = "SelectedTheme"

class ThemeManager {
    
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .theme1
        }
    }
    
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.navigationBarTint
        
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().barTintColor = theme.navigationBarTint
        UINavigationBar.appearance().isTranslucent = theme.isTransulent
    }
    
    static let headerBlue = UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
}
