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

class CalendarPickerHeaderView: UIView {
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()
    
    lazy var yearNumberButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        button.setTitleColor(ThemeManager.headerBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Year Number"
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageName = ThemeManager.currentTheme() == .white ? "close-filled-blue" : "close-filled-blue"
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        
        button.tintColor = UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.6)
        button.contentMode = .scaleAspectFill
        button.isUserInteractionEnabled = true
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Close Picker"
        return button
    }()
    
    //  lazy var listYearsButton: UIButton = {
    //      let button = UIButton()
    //      button.translatesAutoresizingMaskIntoConstraints = false
    ////      button.setImage(UIImage(named: "right_arrow"), for: .normal)
    //      button.isUserInteractionEnabled = true
    //      button.isAccessibilityElement = true
    //      button.accessibilityLabel = "List of Years"
    //      return button
    //   }()
    
    lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        return dateFormatter
    }()
    
    private lazy var yearDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("y")
        return dateFormatter
    }()
    
    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
            let year = yearDateFormatter.string(from: baseDate)
            yearNumberButton.setTitle(year, for: .normal)
            //        guard let image = UIImage(named: "right_arrow") else { return  }
            //        let imageAttachment = NSTextAttachment(image: image)
            //        let attributedString = NSMutableAttributedString(string: " \(year)")
            //
            //        attributedString.append(
            //            NSAttributedString(attachment: imageAttachment)
            //        )
            //        listYearsButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    func hideheaderWeekStack(_ isHide: Bool) {
        dayOfWeekStackView.isHidden = isHide
    }
    
    var exitButtonTappedCompletionHandler: (() -> Void)
    var showYearButtonTappedCompletionHandler: (() -> Void)
    
    init(exitButtonTappedCompletionHandler: @escaping (() -> Void), showYearButtonTappedCompletionHandler: @escaping () -> Void) {
        self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler
        self.showYearButtonTappedCompletionHandler = showYearButtonTappedCompletionHandler
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
//        backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        layer.cornerRadius = 15
        
        addSubview(monthLabel)
        addSubview(yearNumberButton)
        addSubview(closeButton)
        //    addSubview(listYearsButton)
        addSubview(dayOfWeekStackView)
        addSubview(separatorView)
        
        applyTheme()
        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
            dayLabel.textColor = ThemeManager.currentTheme().calendarDateOutsideCurrentMonth//UIColor(red: 0.23529411764705882, green: 0.23529411764705882, blue: 0.2627450980392157, alpha: 0.6)
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)
            
            // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
            // If fact, they get in the way!
            // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
            // That method provides the same amount of context as this stack view does to visual users
            dayLabel.isAccessibilityElement = false
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
        
        closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        yearNumberButton.addTarget(self, action: #selector(didTapListYearButton), for: .touchUpInside)
    }
    
    @objc func didTapExitButton() {
        exitButtonTappedCompletionHandler()
    }
    
    @objc func didTapListYearButton() {
        showYearButtonTappedCompletionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return ""
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            monthLabel.trailingAnchor.constraint(equalTo: yearNumberButton.leadingAnchor, constant: -5),
            
            yearNumberButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            
            //      listYearsButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            //      listYearsButton.widthAnchor.constraint(equalToConstant: 25.0)
            //      listYearsButton.heightAnchor.constraint(equalToConstant: 25.0),
            
            closeButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func applyTheme() {
        monthLabel.textColor = ThemeManager.currentTheme().calendarPickerDayMonthLabelColor
        yearNumberButton.setTitleColor(ThemeManager.currentTheme().calendarPickerButtonTitleColor, for: .normal)
        closeButton.tintColor = ThemeManager.currentTheme().calendarPickerCloseButtonColor
        backgroundColor = ThemeManager.currentTheme().calendarPickerBackground
        separatorView.backgroundColor = ThemeManager.currentTheme().calendarDateOutsideCurrentMonth
    }
}
