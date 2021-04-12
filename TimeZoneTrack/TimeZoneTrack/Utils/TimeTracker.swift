//
//  TimeTracker.swift
//  UnlimitedRuler
//
//  Created by Anantha on 23/03/21.
//  Copyright © 2021 AK. All rights reserved.
//

import Foundation

protocol UpdateClockDelegate {
    func updateClock(with currentDate: Date)
}

class TimeTracker {
    let now  = Date()
    let calendar = Calendar.current
    var currentSeconds = 0
    var timer: Timer?
    var delegate: UpdateClockDelegate?
    
    init(clockDelegate: UpdateClockDelegate) {
        self.delegate = clockDelegate
        currentSeconds = calendar.component(.second, from: now)
        resetTimer()
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = Timer(fire: now.addingTimeInterval(Double(60 - currentSeconds + 1)), interval: 60, repeats: true, block: { [weak self] (timer) in
//            print("Timer Fired")
            self?.updateTimerBlock()
        })
        
        guard let timer = self.timer else { return }
        
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private func updateTimerBlock() {
        let currentDateTimeString = DateFormatters.fullFormatter.string(from: Date())
        guard let currentDateTime = DateFormatters.fullFormatter.date(from: currentDateTimeString) else {
            self.delegate?.updateClock(with: Date())
            return
        }
        self.delegate?.updateClock(with: currentDateTime)
//        self.delegate?.updateClock(with: Date())
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
