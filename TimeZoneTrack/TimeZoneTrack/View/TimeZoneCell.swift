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
    
    @IBOutlet weak var timeZoneNameLabel: UILabel!
    
    @IBOutlet weak var localTimeZoneStandardNameLabel: UILabel!
    
    func updateUI(_ timeZoneModel: TimeZoneModel) {
        locationNameLabel.text = timeZoneModel.name
        timeZoneNameLabel.text = timeZoneModel.timeZone
        if let locationTimeZone = timeZoneModel.timeZone {
            guard let timezone = TimeZone(identifier: locationTimeZone) else { return }
            localTimeZoneStandardNameLabel.text = timezone.localizedName(for: .standard, locale: .current) ?? ""
        }
    }

}
