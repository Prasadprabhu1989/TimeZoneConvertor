//
//  TimeZoneCell.swift
//  TimeZoneTrack
//
//  Created by Anantha on 26/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

class TimeZoneCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var localTimeZoneStandardNameLabel: UILabel!
    
    let theme = ThemeManager.currentTheme()
    
    func updateUI(_ timeZoneModel: TimeZoneModel) {
        locationNameLabel.text = timeZoneModel.name

        if let locationTimeZone = timeZoneModel.timeZone {
            guard let timezone = TimeZone(identifier: locationTimeZone) else { return }
            
            let locatimeZoneName = timezone.localizedName(for: .standard, locale: .current) ?? ""
            localTimeZoneStandardNameLabel.text = locatimeZoneName
        }
    }
    
    override func awakeFromNib() {
         super.awakeFromNib()
         contentView.backgroundColor = theme.backgroundColor
         locationNameLabel.textColor = theme.titleTextColor
         localTimeZoneStandardNameLabel.textColor = theme.subtitleTextColor
     }

}
