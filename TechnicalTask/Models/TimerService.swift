//
//  TimerService.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

// MARK: Timer

import Foundation
import Combine

class TimerService: ObservableObject {
    @Published private(set) var currentTime: Date = Date()
    private var cancellable: AnyCancellable?
    
    init() {
        // Update every second
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentTime = date
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    // Helper method to calculate time remaining for a race
    func timeRemaining(for timestamp: Int) -> TimeInterval {
        let targetDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return targetDate.timeIntervalSince(currentTime)
    }
}
