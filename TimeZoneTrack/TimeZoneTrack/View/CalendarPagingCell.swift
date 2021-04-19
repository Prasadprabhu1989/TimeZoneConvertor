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
    return dateLabel
  }()
  
  lazy var weekdayLabel: UILabel = {
    let weekdayLabel = UILabel(frame: .zero)
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
    
    weekdayLabel.frame = CGRect(
      x: 2,
      y: insets.top,
      width: contentView.bounds.width-4,
      height: contentView.bounds.midY - insets.top)
    
    dateLabel.frame = CGRect(
      x: 2,
      y: contentView.bounds.midY,
      width: contentView.bounds.width-4,
      height: contentView.bounds.midY - insets.bottom)
  }
  
  fileprivate func configure() {
    weekdayLabel.backgroundColor = .clear
    weekdayLabel.textAlignment = .center
    dateLabel.backgroundColor = .clear
    dateLabel.textAlignment = .center
    contentView.backgroundColor = .clear
    addSubview(weekdayLabel)
    addSubview(dateLabel)
  }
  
  fileprivate func updateSelectedState(selected: Bool) {
    guard let options = options else { return }
//    if selected {
//      dateLabel.textColor = options.textColor
//      weekdayLabel.textColor = options.textColor
//        dateLabel.font = options.selectedFont
//        weekdayLabel.font = options.selectedFont
//    } else {
//      dateLabel.textColor = options.textColor
//      weekdayLabel.textColor = options.textColor
//        dateLabel.font = options.font
//        weekdayLabel.font = options.font
//    }
    if selected {
        dateLabel.textColor = ThemeManager.currentTheme().DaySelectionColor
         weekdayLabel.textColor = ThemeManager.currentTheme().DaySelectionColor
           dateLabel.font = options.selectedFont
           weekdayLabel.font = options.selectedFont
       } else {
         dateLabel.textColor = ThemeManager.currentTheme().DaySelectionColor
         weekdayLabel.textColor = ThemeManager.currentTheme().DaySelectionColor
           dateLabel.font = options.font
           weekdayLabel.font = options.font
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
