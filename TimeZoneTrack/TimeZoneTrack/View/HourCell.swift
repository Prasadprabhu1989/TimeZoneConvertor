//
//  HourCell.swift
//  TimeZoneTrack
//
//  Created by Anantha on 01/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

struct TimeCollectionModel {
    var time: String
}

class HourCell: UICollectionViewCell {
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.white
        //label.font = UIFont(name: "Lato-Regular", size: 11.0)
        label.numberOfLines = 0
        return label
    }()

    var hoursItem: IndexPath? {
        didSet {
            updateTimeInCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear //UIColor(red: 234/255, green: 238/255, blue: 245/255, alpha: 1.0)//.white
        contentView.addSubview(titleLabel)
        setUpConstraint()
    }
    
    func setUpConstraint() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func updateUIWith(_ hoursText: String, _ isSelected: Bool) {
        titleLabel.text = hoursText
        if isSelected {
            titleLabel.font = UIFont(name: "Lato-Bold", size: 11.0) //UIFont(name: "Lato-Regular", size: 11.0) ??
        } else {
            titleLabel.font = UIFont(name: "Lato-Semibold", size: 11.0) //?? UIFont(name: "Lato-Regular", size: 11.0)
        }
    }
    
    func updateTimeInCell() {
        if let hoursItem = hoursItem {
            titleLabel.text = hoursItem.row + 1 > 12 ? "\((hoursItem.row + 1) - 12) PM" : "\(hoursItem.row + 1) AM"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
}
