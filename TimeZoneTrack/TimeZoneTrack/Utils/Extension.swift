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
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.contentMode = .scaleAspectFit
//        imageView.image = #imageLiteral(resourceName: "HiveDesk_Logo_360w")
//        imageView.image = #imageLiteral(resourceName: "logo-white4")
        imageView.image = UIImage(named: "logo-white")
        
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
}

//@IBDesignable extension UIButton {
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//}

extension TimeZone {
    func offsetFromGMT(_ date: Date) -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: date)
    }

    func offset(_ date: Date) -> Int {
       return Int(self.secondsFromGMT(for: date))
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
        components.hour = hour
        components.minute = minute + offsethour * 30

        return cal.date(from: components)
    }
}

extension UITableViewCell {

    var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
}

extension UIImageView {

    func tint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

extension UIView {
    public func addViewBorder(borderColor: CGColor, borderWith: CGFloat, borderCornerRadius: CGFloat = 0.0) {
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = borderCornerRadius

    }
}

extension UIColor
{
    class func backGroundBlack() -> UIColor
    {
        return UIColor(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    }

    
    class func backgroundBlackSecondary() -> UIColor
    {
        return UIColor(red: 58.0/255.0, green: 58.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    }
}


extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        print(timeZone.secondsFromGMT(for: self))
        print(initTimeZone.secondsFromGMT(for: self))
        let delta = TimeInterval(timeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}


@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
