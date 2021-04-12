//
//  HourCell.swift
//  TimeZoneTrack
//
//  Created by Nithin on 01/04/21.
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
        label.font = UIFont(name: "Futura Medium", size: 12.0)
        label.textColor = UIColor.gray
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
        
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        setUpConstraint()
    }
    
    func setUpConstraint() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
//        bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        bottomView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func updateUIWith(_ hoursText: String, _ isSelected: Bool) {
        titleLabel.text = hoursText
        if isSelected {
            contentView.backgroundColor = UIColor.init(red: 231.0/255.0, green: 240.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            //UIColor.init(red: 42.0/255.0, green: 125.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            //
        } else {
            contentView.backgroundColor = .white
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
