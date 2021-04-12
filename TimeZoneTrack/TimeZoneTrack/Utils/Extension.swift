//
//  Extension.swift
//  TimeZoneTrack
//
//  Created by Anantha on 30/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

extension UIViewController {

    func addLogoToNavigationBarItem() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        imageView.contentMode = .scaleAspectFit
//        imageView.image = #imageLiteral(resourceName: "HiveDesk_Logo_360w")
//        imageView.image = #imageLiteral(resourceName: "logo-white4")
        imageView.image = UIImage(named: "logo-white4")
        
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
}

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

extension TimeZone {
    func offsetFromGMT(_ date: Date) -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: date)
    }

    func offset() -> Int {
       return Int(self.secondsFromGMT())
    }
    
}

extension Date {
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 30 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }

}

extension Date {
    public func setTime(_ offsetDay: Int, _ offsethour: Int, _ timeZone: TimeZone) -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        components.timeZone = TimeZone.autoupdatingCurrent
        components.day = day + offsetDay
        components.hour = hour + offsethour
        components.minute = minute

        return cal.date(from: components)
    }
}
