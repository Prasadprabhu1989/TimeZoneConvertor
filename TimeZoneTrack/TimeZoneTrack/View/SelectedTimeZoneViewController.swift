//
//  SelectedTimeZoneViewController.swift
//  TimeZoneTrack
//
//  Created by Anantha on 25/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

enum HoursStyle: String {
    case twentyfourHour = "HH:mm"
    case twelveHour = "hh:mm a"
    case onlyHour = "HH"
    case onlyMinute = "mm"
}

enum DateDisplayStyle: String {
    case weekmonthday = "EEE, MMM dd"
}

class SelectedTimeZoneViewController: UIViewController {
    
    @IBOutlet weak var timeListTableView: UITableView!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var selectedDateTimeView: UIView!
    @IBOutlet weak var hoursListView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var hourStyleSwitch: UISwitch!
    @IBOutlet weak var emptyTimeZoneView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthNameView: UIView!
    @IBOutlet weak var separatorLine1View: UIView!
    @IBOutlet weak var seperatorLine2View: UIView!
    @IBOutlet weak var twetyFourHourStyleLabel: UILabel!
    @IBOutlet weak var seperatorLine3View: UIView!
    @IBOutlet weak var emptyTimeZoneLabel: UILabel!
    @IBOutlet weak var addTimeZoneButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    let calendarViewController = CalendarViewController()
    
    var theme = ThemeManager.currentTheme()
    
    var timeZoneArray: [SelectedTimeZone] = [] {
        didSet {
            if timeZoneArray.count > 0 {
                hideEmptyView(true)
                timeListTableView.reloadData()
            } else {
                hideEmptyView(false)
            }
            
        }
    }
    var currentDateTime:Date!
    var timeTracker: TimeTracker?
    var hoursStyle: HoursStyle = .twentyfourHour
    var timeZoneHelperModel: TimeZoneHelperModel?
    let flowLayout = PaggedFlowLayout()
    var hoursRangeArray: [String] = [] {
        didSet {
            reloadHoursCollection()
            timeListTableView.reloadData()
        }
    }
    
    var selectedHourIndex: Int = -1
    var selectedHourIndexOffset: Int = -1
    
    var _monthYearString : String = ""
    var monthYearString: String {
        get {
            return _monthYearString
        }
        set (aNewValue) {
            if (aNewValue != monthYearString) {
                _monthYearString = aNewValue
                print(aNewValue)
                self.monthLabel.text = aNewValue
            }
        }
    }
    
    var offsetHour: Int = 0
    var offsetDay: Int = 0
    var dateCalendar: Date?
    var offfsetMonth: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyThemeStyle()
        setUpTableView()
        addLogoToNavigationBarItem()
        addCalendarChildViewController()
        setUpCollectionView()
        setSelectedDateTimeViewStyle()
        getInitalCalendarDate()
    }
    
    func getInitalCalendarDate() {
        let calendarDateString = DateFormatters.yyyyMMddDateFormatter.string(from: Date())
        dateCalendar = DateFormatters.yyyyMMddDateFormatter.date(from: calendarDateString)
    }
    
    func applyThemeStyle() {
        self.view.backgroundColor = theme.backgroundColor
        timeListTableView.backgroundColor = theme.tableViewBackGroundColor
        selectedDateTimeView.backgroundColor = theme.selectedRangeColor
        hoursListView.backgroundColor = theme.backgroundColor
        calendarView.backgroundColor = theme.calendarBackgroundColor
        collectionView.backgroundColor = theme.hoursRangeBackgroundColor
        monthNameView.backgroundColor = theme.backgroundColor
        separatorLine1View.backgroundColor = theme.seperatorViewColor
        seperatorLine2View.backgroundColor = theme.seperatorViewColor
        seperatorLine3View.backgroundColor = theme.seperatorViewColor
        emptyTimeZoneView.backgroundColor = theme.backgroundColor
        monthLabel.textColor = theme.titleTextColor
        emptyTimeZoneLabel.textColor = theme.titleTextColor
        
    }
    
    func setUpTableView() {
        timeListTableView.delegate = self
        timeListTableView.dataSource = self
        timeListTableView.estimatedRowHeight = 150
        timeListTableView.rowHeight = UITableView.automaticDimension
        timeListTableView.tableFooterView = UIView()
        timeListTableView.separatorInset = .zero
        timeListTableView.separatorColor = theme.seperatorViewColor
        //        timeListTableView.isEditing = true
        
        timeListTableView.reorder.delegate = self
        timeListTableView.reorder.cellOpacity = 0.7
        timeListTableView.reorder.cellScale = 1.05
        timeListTableView.reorder.shadowOpacity = 0.5
        timeListTableView.reorder.shadowRadius = 20
        timeListTableView.reorder.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func setUpCollectionView() {
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(HourCell.self, forCellWithReuseIdentifier: "HourCell")
    }
    
    func setSelectedDateTimeViewStyle() {
        selectedDateTimeView.addViewBorder(borderColor: theme.selectedRangeBorderColor.cgColor, borderWith: 2.0)
        //        editModeButton.layer.cornerRadius = 5
        addTimeZoneButton.layer.cornerRadius = 5
    }
    
    func setCurrentTime() {
        let currentDateTimeString = DateFormatters.fullFormatter.string(from: Date())
        currentDateTime = DateFormatters.fullFormatter.date(from: currentDateTimeString)
    }
    
    func addCalendarChildViewController() {
        calendarViewController.dateUpdateDelegate = self
        
        // Add the paging view controller as a child view
        // controller and constrain it to all edges
        addChild(calendarViewController)
        calendarView.addSubview(calendarViewController.view)
        calendarView.constrainToTopWithFixedHeight(calendarViewController.view)
        calendarViewController.didMove(toParent: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //                currentDateTime = Date()
        setCurrentTime()
        
        timeZoneHelperModel = TimeZoneHelperModel.init(refreshViewOnHomeTimeZoneChange: self)
        timeTracker = TimeTracker.init(clockDelegate: self)
        fetchSelectedTimeZone()
        hoursRangeArray = timeZoneHelperModel?.getHoursArray(hoursStyle) ?? []
        fetchSelectedHourFromCurrentDateTime()
        monthYearString = DateFormatters.shortDateFormatter.string(from: currentDateTime)
        self.monthLabel.text = monthYearString
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timeTracker?.stopTimer()
        timeTracker?.delegate = nil
        timeZoneHelperModel?.refreshViewOnHomeTimeZoneChange = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.scrollToItem(at:IndexPath(item: selectedHourIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func fetchSelectedTimeZone() {
        timeZoneArray = timeZoneHelperModel?.fetchSelectedTimeZone() ?? []
    }
    
    func fetchSelectedHourFromCurrentDateTime() {
        selectedHourIndex = timeZoneHelperModel?.getSelectedHourIndex(currentDateTime) ?? selectedHourIndex
        selectedHourIndexOffset = selectedHourIndex
    }
    @IBAction func hoursStyleSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            hoursStyle = .twentyfourHour
            twetyFourHourStyleLabel.textColor = theme.titleTextColor
        } else {
            hoursStyle = .twelveHour
            twetyFourHourStyleLabel.textColor = theme.subtitleTextColor
        }
        hoursRangeArray = timeZoneHelperModel?.getHoursArray(hoursStyle) ?? []
    }
    
    @IBAction func toggleHoursFormat(_ sender: UIBarButtonItem) {
        hoursRangeArray = timeZoneHelperModel?.getHoursArray(hoursStyle) ?? []
    }
    
    @IBAction func refreshClicked(_ sender: UIButton) {
        //        calendarViewController.setSelectedDate(currentDateTime)
        refreshView()
    }
    
    //    @IBAction func addCityTimeZoneClicked(_ sender: UIBarButtonItem) {
    //        performSegue(withIdentifier: "showTimeZoneListSegue", sender: self)
    //    }
    
    @IBAction func addTimeZoneClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showTimeZoneListSegue", sender: self)
    }
    
    @IBAction func calendarClicked(_ sender: UIButton) {
        let pickerController = CalendarPickerViewController(
          baseDate: currentDateTime,
          selectedDateChanged: { [weak self] date in
          guard let self = self else { return }

          
          })

        present(pickerController, animated: true, completion: nil)
     }
    
    //    @IBAction func editTableViewClicked(_ sender: UIButton) {
    //        if(isEditable == true) {
    //            isEditable = false
    //            editModeButton.setTitle("Edit", for: .normal)
    //        } else {
    //            isEditable = true
    //            editModeButton.setTitle("Done", for: .normal)
    //        }
    //        timeListTableView.reloadData()
    //    }
    
    func hideEmptyView(_ isHidden: Bool) {
        emptyTimeZoneView.isHidden = isHidden
        refreshBarButton.isEnabled = isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsIdentifier" {
            let nav = segue.destination as! UINavigationController
            let settingsController = nav.viewControllers[0] as? SettingsViewController
            guard let settingsVC = settingsController  else { return }
            settingsVC.hoursStyle = self.hoursStyle
            settingsVC.completionHandler = { [weak self](hoursStyle) in
                self?.hoursStyle = hoursStyle!
                
                //                hoursRangeArray = timeZoneHelperModel?.getHoursArray(hoursStyle) ?? []
                
                self?.hoursRangeArray = self?.timeZoneHelperModel?.getHoursArray(hoursStyle!) ?? []
                
            }
            settingsVC.applyTheme = { [weak self] in
                self?.theme = ThemeManager.currentTheme()
                self?.applyThemeStyle()
                self?.calendarViewController.pagingViewController.collectionView.reloadData()
                self?.collectionView.reloadData()
                self?.timeListTableView.reloadData()
                
            }
            
        }
        guard let addTimeZoneViewController = segue.destination as? AddTimeZoneViewController else { return }
        addTimeZoneViewController.addTimeZoneClosure = { [weak self] timezoneModel in
            guard let self = self else { return }
            
            let timezoneArrayCount = self.timeZoneArray.count
            self.timeZoneHelperModel?.updateSelectedTimeZone(timezoneModel, orderNo: timezoneArrayCount )
            self.fetchSelectedTimeZone()
            if timezoneArrayCount == 0 {
                self.fetchSelectedHourFromCurrentDateTime()
                self.reloadHoursCollection()
            }
        }
    }
    
    func reloadHoursCollection() {
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath.init(item: selectedHourIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func reArrangeOrder(fromIndex: Int, toIndex: Int) {
        
        timeZoneHelperModel?.reArrangeOrder(fromIndex, toIndex, timeZoneArray)
        let movedObject = timeZoneArray[fromIndex]
        timeZoneArray.remove(at: fromIndex)
        timeZoneArray.insert(movedObject, at: toIndex)
    }
}

extension SelectedTimeZoneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZoneArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedTimeZoneCell", for: indexPath) as? SelectedTimeZoneCell else {
            //            print("Cell not exists in storyboard")
            return UITableViewCell()
        }
        
        cell.updateUI(with: currentDateTime, selectedTimeZone: timeZoneArray[indexPath.row], hourStyle: hoursStyle, offsetHour: offsetHour, offsetDay: offsetDay)
        cell.homeTimeZoneButtonClickedDelegate = self
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        if isEditable {
    //            return .delete
    //        }
    //        return .none
    //    }
    
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return .none
    //    }
    
    //    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    //        if isEditable {
    //            return true
    //        }
    //        return false
    //    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath == destinationIndexPath { return }
        
        //        let indexFrom = sourceIndexPath.row
        //        let indexTo   = destinationIndexPath.row
        
        reArrangeOrder(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        //        timeZoneHelperModel?.reArrangeOrder(indexFrom, indexTo, timeZoneArray)
        //
        //        let movedObject = timeZoneArray[sourceIndexPath.row]
        //        timeZoneArray.remove(at: sourceIndexPath.row)
        //        timeZoneArray.insert(movedObject, at: desinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let deleteObject = timeZoneArray[indexPath.row]
            timeZoneHelperModel?.deleteSelectedTimeZone(indexPath.row, self.timeZoneArray, deleteObject)
            self.timeZoneArray.remove(at: indexPath.row)
            if let firstTimeZone = self.timeZoneArray.first {
                timeZoneHelperModel?.updateHomeTimeZone(firstTimeZone)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = theme.backgroundColor
        cell.reorderControlImageView?.tint(color: theme.seperatorViewColor)
    }
    
}

extension SelectedTimeZoneViewController: DateSelectedDelegate {
    func updatedDate(_ monthYear: String, _ date: Date?) {
        monthYearString = monthYear
        guard let dateCalendar = dateCalendar, let dateSelected = date else {
            return
        }
        offsetDay = Calendar.current.dateComponents([.day], from: dateCalendar , to: dateSelected ).day ?? 0
        timeListTableView.reloadData()
    }
    
    
}

extension SelectedTimeZoneViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            print(centerCellIndexPath)
            selectedHourIndex = centerCellIndexPath.row
            offsetHour = centerCellIndexPath.row - selectedHourIndexOffset
            reloadHoursCollection()
            timeListTableView.reloadData()
        }
    }
}

extension SelectedTimeZoneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        return .none
    //    }
    //    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
    //        return false
    //    }
}

extension SelectedTimeZoneViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hoursRangeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
        let hour = hoursRangeArray[indexPath.row]
        let isSelected = indexPath.row == selectedHourIndex ? true : false
        cell.updateUIWith(hour, isSelected)
        return cell
    }
    
}

extension SelectedTimeZoneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHourIndex = indexPath.row
        offsetHour = indexPath.row - selectedHourIndexOffset
        reloadHoursCollection()
        timeListTableView.reloadData()
    }
}

extension SelectedTimeZoneViewController: TableViewReorderDelegate {
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        reArrangeOrder(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
}


extension SelectedTimeZoneViewController: RefreshViewOnHomeTimeZoneChangeDelegate {
    func refreshView() {
        offsetHour = 0
        offsetDay = 0
        calendarViewController.setSelectedDate(currentDateTime)
        fetchSelectedTimeZone()
        fetchSelectedHourFromCurrentDateTime()
        reloadHoursCollection()
        monthYearString = DateFormatters.shortDateFormatter.string(from: currentDateTime)
    }
}

extension SelectedTimeZoneViewController: HomeTimeZoneButtonClickedDelegate {
    func didHomeButtonClicked(_ sender: UITableViewCell) {
        if let indexPath = timeListTableView.indexPath(for: sender) {
            let timeZoneObject = timeZoneArray[indexPath.row]
            timeZoneHelperModel?.updateHomeTimeZone(timeZoneObject)
        }
    }
    
    
}

extension SelectedTimeZoneViewController: UpdateClockDelegate {
    func updateClock(with currentDate: Date) {
        currentDateTime = currentDate
        
        if offsetHour == 0 && offsetDay == 0 {
            let currentSelectedIndex = timeZoneHelperModel?.getSelectedHourIndex(currentDateTime)
            timeListTableView.reloadData()
            if currentSelectedIndex != -1 && currentSelectedIndex != selectedHourIndex  {
                selectedHourIndex = currentSelectedIndex ?? selectedHourIndex
                reloadHoursCollection()
            }
        }
    }
    
}
