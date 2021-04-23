//
//  DatePickerController.swift
//  TimeZoneTrack
//
//  Created by Prasad Prabhu on 20/04/21.
//  Copyright © 2021 AK. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController {
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var datePickerDoneView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    var selectedDateChanged: ((Date) -> Void)?
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpThemeForDatePicker()

    }
    
    func setUpThemeForDatePicker(){
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = UIColor(red: 73/255, green: 73/255, blue: 84/255, alpha: 0.7)
        view.isOpaque = false
        datePickerContainerView.backgroundColor = theme.backgroundColor
        datePickerDoneView.backgroundColor = theme.backgroundColor
        doneButton.layer.cornerRadius = 5.0
        datePicker.setValue(theme.titleTextColor, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        datePicker.date = selectedDate
    }
    
    
    @IBAction func tapOutside(_ sender: Any) {
        clickDone(sender)
    }
    @IBAction func changeDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print(selectedDate)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let selectedDate = datePicker.date
        let dateString = DateFormatters.shortDateFormatter.string(from: selectedDate)
        let date = DateFormatters.shortDateFormatter.date(from: dateString) ?? selectedDate
        selectedDateChanged?(date)
        dismiss(animated: true, completion: nil)
    }

    
}
