/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CalendarPickerViewController: UIViewController {
  // MARK: Views
  private lazy var dimmedBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    let color = ThemeManager.currentTheme() == .white ? UIColor.black : UIColor.white
    view.backgroundColor = color.withAlphaComponent(0.25)
    return view
  }()

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private lazy var yearCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
//  var showYear = false {
//    didSet {
//      updateCollection()
//    }
//  }
  
  var _showYear = true

  var showYear : Bool {
      get {
          return _showYear
      }
      set (aNewValue) {
          if (aNewValue != showYear) {
              _showYear = aNewValue
              updateCollection()
          }
      }
  }
  
  private var arrYears = [Int]()
  private var year: Int!
  private var startYear = 0
  private var currentYearIndex: IndexPath!
//  private var index: IndexPath?
  private let startYearCalendar = 2010
  private let endYearCalendar = 2040
  
  func updateCollection() {
      yearCollectionView.isHidden = showYear
      collectionView.isHidden = !showYear
      footerView.hidefooterButtons(!showYear)
      headerView.hideheaderWeekStack(!showYear)
      yearCollectionView.scrollToItem(at: currentYearIndex, at: .centeredVertically, animated: false)
//      index = currentYearIndex
  }
  
  private func generateYears(){
      years:for i in startYearCalendar...endYearCalendar {
          arrYears.append(startYear + i)
      }
    yearCollectionView.reloadData()
  }
  
  private lazy var headerView = CalendarPickerHeaderView(exitButtonTappedCompletionHandler: { [weak self] in
    guard let self = self else { return }

    self.dismiss(animated: true)
  }) {[weak self] in
    guard let self = self else { return }
    self.showYear = !self.showYear
  }
  


  private lazy var footerView = CalendarPickerFooterView(
    didTapLastMonthCompletionHandler: { [weak self] in
    guard let self = self else { return }

    self.baseDate = self.calendar.date(
      byAdding: .month,
      value: -1,
      to: self.baseDate
      ) ?? self.baseDate
      self.updateSelectedYear()
    },
    didTapNextMonthCompletionHandler: { [weak self] in
      guard let self = self else { return }

      self.baseDate = self.calendar.date(
        byAdding: .month,
        value: 1,
        to: self.baseDate
        ) ?? self.baseDate
      self.updateSelectedYear()
    })


  // MARK: Calendar Data Values

  private let selectedDate: Date
  private var baseDate: Date {
    didSet {
      days = generateDaysInMonth(for: baseDate)
      collectionView.reloadData()
      headerView.baseDate = baseDate
    }
  }

  private lazy var days = generateDaysInMonth(for: baseDate)

  private var numberOfWeeksInBaseDate: Int {
    calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
  }

  private let selectedDateChanged: ((Date) -> Void)
  private let calendar = Calendar(identifier: .gregorian)

  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()

  // MARK: Initializers

  init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
    self.selectedDate = baseDate
    self.baseDate = baseDate
    self.selectedDateChanged = selectedDateChanged

    super.init(nibName: nil, bundle: nil)

    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
    definesPresentationContext = true
  }

//  private func setUpYearView(){
//      yearCollectionView = YearCollectionView.init(nibName: "YearCollectionView", bundle: nil)
//      yearCollectionView.passYearClosure = { (year,month) in
//          print(year)
////          self.selectedYear = year
////          let zellerResult = self.zellersFormula(forTheYear: year)
////          self.startDay = zellerResult.0
////          if zellerResult.1{
////              self.yearType = YearType.leapCalendar
////          }else{
////              self.yearType = YearType.calendar
////          }
////          self.calendarDataSetup()
////          if let monthUnwrapped = month{
////              self.calendarCollectionView.scrollToItem(at: IndexPath(row: 0, section: monthUnwrapped), at: .top, animated: false)
////          }
//      }
//    yearCollectionView.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height - 50 )
//      self.addChild(yearCollectionView)
//      self.view.addSubview(yearCollectionView.view)
//
//      yearCollectionView.didMove(toParent: self)
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateCurrentYearToSelected() {
    let diffrenceYear = arrYears[currentYearIndex.row] - year
    if diffrenceYear != 0 {
      self.baseDate = self.calendar.date(
          byAdding: .year,
          value: diffrenceYear,
          to: self.baseDate
          ) ?? self.baseDate
      year = arrYears[currentYearIndex.row]
    }
  }
  
    func applyTheme() {
//        dimmedBackgroundView.backgroundColor = ThemeManager.currentTheme().calendarPickerBackground.withAlphaComponent(0.3)
        collectionView.backgroundColor = ThemeManager.currentTheme().calendarPickerBackground
        yearCollectionView.backgroundColor = ThemeManager.currentTheme().calendarPickerBackground
    }
    
  func updateSelectedYear() {
    year = Calendar.current.component(.year, from: baseDate)
//    currentMonth = Calendar.current.component(.month, from: baseDate)
    currentYearIndex = getIndexFromYearArray()
    
  }
  
  func getIndexFromYearArray() -> IndexPath {
    let index = year - startYearCalendar
    return IndexPath(row: index, section: 0)
  }
  
  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    yearCollectionView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    
    view.addSubview(dimmedBackgroundView)
    view.addSubview(collectionView)
    view.addSubview(headerView)
    view.addSubview(footerView)
    view.addSubview(yearCollectionView)
  
    generateYears()
    updateSelectedYear()
    applyTheme()
    
    var constraints = [
      dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]

    constraints.append(contentsOf: [
      //1
      collectionView.leadingAnchor.constraint(
        equalTo: view.readableContentGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: view.readableContentGuide.trailingAnchor),
      //2
      collectionView.centerYAnchor.constraint(
        equalTo: view.centerYAnchor,
        constant: 10),
      //3
      collectionView.heightAnchor.constraint(
        equalTo: view.heightAnchor,
        multiplier: 0.4)
    ])
    
    constraints.append(contentsOf: [
      //1
      yearCollectionView.leadingAnchor.constraint(
        equalTo: view.readableContentGuide.leadingAnchor),
      yearCollectionView.trailingAnchor.constraint(
        equalTo: view.readableContentGuide.trailingAnchor),
      //2
      yearCollectionView.centerYAnchor.constraint(
        equalTo: view.centerYAnchor,
        constant: 10),
      yearCollectionView.topAnchor.constraint(
      equalTo: headerView.bottomAnchor,
      constant: -25),
      yearCollectionView.bottomAnchor.constraint(
      equalTo: footerView.topAnchor,
      constant: 25)
      //3
//      yearCollectionView.heightAnchor.constraint(
//        equalTo: view.heightAnchor,
//        multiplier: 0.4)
    ])

    constraints.append(contentsOf: [
      headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 85),
      
      footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
      footerView.heightAnchor.constraint(equalToConstant: 60)
    ])
    
//    self.yearCollectionView.view.translatesAutoresizingMaskIntoConstraints  = false
//    constraints.append([
//
//      self.yearCollectionView.view?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//    self.yearCollectionView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//    self.yearCollectionView.view.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//    self.yearCollectionView.view.heightAnchor.constraint(equalToConstant: view.heightAnchor)])
//
    NSLayoutConstraint.activate(constraints)

    collectionView.register(
      CalendarDateCollectionViewCell.self,
      forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
    )
    

    yearCollectionView.register(UINib(nibName:YearCell.reuseIdentifierYearCell, bundle: nil), forCellWithReuseIdentifier:YearCell.reuseIdentifierYearCell)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    yearCollectionView.dataSource = self
    yearCollectionView.delegate = self
    
    yearCollectionView.isHidden = true
    
    headerView.baseDate = baseDate
  }
  
  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    collectionView.reloadData()
  }
}

// MARK: - Day Generation
private extension CalendarPickerViewController {
  // 1
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    // 2
    guard
      let numberOfDaysInMonth = calendar.range(
        of: .day,
        in: .month,
        for: baseDate)?.count,
      let firstDayOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: baseDate))
      else {
        // 3
        throw CalendarDataError.metadataGeneration
    }

    // 4
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

    // 5
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }

  // 1
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    // 2
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }

    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay

    // 3
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        // 4
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        // 5
        let dayOffset =
          isWithinDisplayedMonth ?
          day - offsetInInitialRow :
          -(offsetInInitialRow - day)

        // 6
        return generateDay(
          offsetBy: dayOffset,
          for: firstDayOfMonth,
          isWithinDisplayedMonth: isWithinDisplayedMonth)
      }

    days += generateStartOfNextMonth(using: firstDayOfMonth)

    return days
  }

  // 7
  func generateDay(
    offsetBy dayOffset: Int,
    for baseDate: Date,
    isWithinDisplayedMonth: Bool
  ) -> Day {
    let date = calendar.date(
      byAdding: .day,
      value: dayOffset,
      to: baseDate)
      ?? baseDate

    return Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
      isWithinDisplayedMonth: isWithinDisplayedMonth
    )
  }

  // 1
  func generateStartOfNextMonth(
    using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
    // 2
    guard
      let lastDayInMonth = calendar.date(
        byAdding: DateComponents(month: 1, day: -1),
        to: firstDayOfDisplayedMonth)
      else {
        return []
    }

    // 3
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }

    // 4
    let days: [Day] = (1...additionalDays)
      .map {
        generateDay(
        offsetBy: $0,
        for: lastDayInMonth,
        isWithinDisplayedMonth: false)
      }

    return days
  }

  enum CalendarDataError: Error {
    case metadataGeneration
  }
}

// MARK: - UICollectionViewDataSource
extension CalendarPickerViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    if collectionView == yearCollectionView {
      return arrYears.count
    } else {
      return days.count
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    if collectionView == yearCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearCell.reuseIdentifierYearCell, for: indexPath) as! YearCell
      cell.lblYear.text = "\(arrYears[indexPath.row])"
      if indexPath.row == currentYearIndex?.row {
        cell.lblYear.textColor = ThemeManager.headerBlue
      } else {
        cell.lblYear.textColor = ThemeManager.currentTheme().calendarPickerDayMonthLabelColor
      }
   return cell
    } else {
      let day = days[indexPath.row]

         let cell = collectionView.dequeueReusableCell(
           withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
           for: indexPath) as! CalendarDateCollectionViewCell
         // swiftlint:disable:previous force_cast

         cell.day = day
         return cell
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    if collectionView == yearCollectionView {
      currentYearIndex = indexPath
//      index = indexPath
      updateCurrentYearToSelected()
      showYear = !showYear
      yearCollectionView.reloadData()
    } else {
      let day = days[indexPath.row]
        let dateString = DateFormatters.shortDateFormatter.string(from: day.date)
        let date = DateFormatters.shortDateFormatter.date(from: dateString) ?? day.date
        selectedDateChanged(date)
      dismiss(animated: true, completion: nil)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    if collectionView == yearCollectionView {
      return CGSize(width: 100, height: 50)
    } else {
      let width = Int(collectionView.frame.width / 7)
      let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
      return CGSize(width: width, height: height)
    }
  }
}
