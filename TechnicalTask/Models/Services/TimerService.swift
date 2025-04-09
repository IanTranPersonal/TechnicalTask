//
//  TimerService.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

// MARK: Timer

import SwiftUI
import Combine

import Observation

@Observable
class TimerService {
    var currentTime: Date = Date()
    private var timer: Timer?
    
    init() {
        // Update every second
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.currentTime = Date()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // Helper method to calculate time remaining for a race
    func timeRemaining(for timestamp: Int) -> TimeInterval {
        let targetDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return targetDate.timeIntervalSince(currentTime)
    }
}
