//
//  CalendarViewController.swift
//  TimeZoneTrack
//
//  Created by Anantha on 01/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

// First thing we need to do is create our own PagingItem that will
// hold our date. We need to make sure it conforms to Hashable and
// Comparable, as that is required by PagingViewController. We also
// cache the formatted date strings for performance.
struct CalendarItem: PagingItem, Hashable, Comparable {
  let date: Date
  let dateText: String
  let weekdayText: String
  
  init(date: Date) {
    self.date = date
    self.dateText = DateFormatters.dateFormatter.string(from: date)
    self.weekdayText = DateFormatters.weekdayFormatter.string(from: date)
  }
  
  static func < (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date < rhs.date
  }
}

protocol DateSelectedDelegate: class {
    func updatedDate(_ monthYear: String, _ date: Date?)
}

class CalendarViewController: UIViewController {

  weak var dateUpdateDelegate: DateSelectedDelegate?
  let pagingViewController = PagingViewController()
    
  var selectedDate = Date()
    
  override func viewDidLoad() {
    super.viewDidLoad()

    pagingViewController.register(CalendarPagingCell.self, for: CalendarItem.self)
    pagingViewController.menuItemSize = .fixed(width: 51, height: 59)
//    pagingViewController.textColor = UIColor.gray
    pagingViewController.delegate = self

//    pagingViewController.menuPosition = .bottom
    // Add the paging view controller as a child view
    // controller and constrain it to all edges
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParent: self)
    
    // Set our custom data source
    pagingViewController.infiniteDataSource = self
    
    // Set the current date as the selected paging item
    setSelectedDate(selectedDate)
  }
 
    func setSelectedDate(_ date: Date) {
        pagingViewController.select(pagingItem: CalendarItem(date: date))
    }
    
}

// We need to conform to PagingViewControllerDataSource in order to
// implement our custom data source. We set the initial item to be the
// current date, and every time pagingItemBeforePagingItem: or
// pagingItemAfterPagingItem: is called, we either subtract or append
// the time interval equal to one day. This means our paging view
// controller will show one menu item for each day.
extension CalendarViewController: PagingViewControllerInfiniteDataSource {
  
  func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.addingTimeInterval(86400))
  }
  
  func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.addingTimeInterval(-86400))
  }
  
  func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
//    let calendarItem = pagingItem as! CalendarItem
//    let formattedDate = DateFormatters.shortDateFormatter.string(from: calendarItem.date)
//    print(formattedDate, calendarItem.date)
//    dateUpdateDelegate?.updatedDate(formattedDate)
    return UIViewController()
  }
  
}

extension CalendarViewController: PagingViewControllerDelegate {
    func pagingViewController(
      _ pagingViewController: PagingViewController,
      didSelectItem pagingItem: PagingItem) {
        let calendarItem = pagingItem as! CalendarItem
        let formattedDate = DateFormatters.MMMMYYYYDateFormatter.string(from: calendarItem.date)
        let shortDateString = DateFormatters.shortDateFormatter.string(from: calendarItem.date)
        let shortDate = DateFormatters.shortDateFormatter.date(from: shortDateString)
        print(formattedDate, calendarItem.date)
        dateUpdateDelegate?.updatedDate(formattedDate, shortDate)
        
    }
}

