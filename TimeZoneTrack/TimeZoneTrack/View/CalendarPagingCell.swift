//
//  CalendarPagingCell.swift
//  TimeZoneTrack
//
//  Created by Anantha on 01/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

class CalendarPagingCell: PagingCell {
  
  private var options: PagingOptions?
  
  lazy var dateLabel: UILabel = {
    let dateLabel = UILabel(frame: .zero)
//    dateLabel.font = UIFont.systemFont(ofSize: 20)
    return dateLabel
  }()
  
  lazy var weekdayLabel: UILabel = {
    let weekdayLabel = UILabel(frame: .zero)
//    weekdayLabel.font = UIFont.systemFont(ofSize: 12)
    return weekdayLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let insets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
    
    dateLabel.frame = CGRect(
      x: 2,
      y: insets.top,
      width: contentView.bounds.width-4,
      height: contentView.bounds.midY - insets.top)
    
    weekdayLabel.frame = CGRect(
      x: 2,
      y: contentView.bounds.midY,
      width: contentView.bounds.width-4,
      height: contentView.bounds.midY - insets.bottom)
  }
  
  fileprivate func configure() {
    weekdayLabel.backgroundColor = .white
    weekdayLabel.textAlignment = .center
    dateLabel.backgroundColor = .white
    dateLabel.textAlignment = .center
    contentView.backgroundColor = .white
    weekdayLabel.backgroundColor = .white
    dateLabel.backgroundColor = .white
    addSubview(weekdayLabel)
    addSubview(dateLabel)
  }
  
  fileprivate func updateSelectedState(selected: Bool) {
    guard let options = options else { return }
    if selected {
      dateLabel.textColor = options.selectedTextColor
      weekdayLabel.textColor = options.selectedTextColor
        dateLabel.font = options.selectedFont
        weekdayLabel.font = options.selectedFont
//        contentView.layer.borderWidth = 2
//        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.backgroundColor = UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        weekdayLabel.backgroundColor = UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
        dateLabel.backgroundColor = UIColor(red: 27/255, green: 79/255, blue: 174/255, alpha: 1.0)
    } else {
      dateLabel.textColor = options.textColor
      weekdayLabel.textColor = options.textColor
        dateLabel.font = options.font
        weekdayLabel.font = options.font
//        contentView.layer.borderWidth = 0
        contentView.backgroundColor = UIColor(red: 234/255, green: 238/255, blue: 245/255, alpha: 1.0)
        weekdayLabel.backgroundColor = UIColor(red: 234/255, green: 238/255, blue: 245/255, alpha: 1.0)
        dateLabel.backgroundColor = UIColor(red: 234/255, green: 238/255, blue: 245/255, alpha: 1.0)
    }
  }
  
  override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
    self.options = options
    let calendarItem = pagingItem as! CalendarItem
    dateLabel.text = calendarItem.dateText
    weekdayLabel.text = calendarItem.weekdayText
    
    updateSelectedState(selected: selected)
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    guard let options = options else { return }

    if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
      dateLabel.textColor = UIColor.interpolate(
        from: options.textColor,
        to: options.selectedTextColor,
        with: attributes.progress)
      
      weekdayLabel.textColor = UIColor.interpolate(
        from: options.textColor,
        to: options.selectedTextColor,
        with: attributes.progress)
    }
  }
  
}
