//
//  TimerService.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

// MARK: Timer

import SwiftUI
import Observation

@MainActor
@Observable
class TimerService {
    var currentTime: Date = Date()
    private var isCancelled = false
    private var task: Task<Void, Never>?
    
    init() {
        startTimer()
    }
    
    private func startTimer() {
        task = Task { [weak self] in
            do {
                while !Task.isCancelled && self?.isCancelled == false {
                    self?.currentTime = Date()
                    try await Task.sleep(for: .seconds(1))
                }
            } catch {
                self?.isCancelled = true
                self?.cancelTimer()
            }
        }
    }
    
    private func cancelTimer() {
        task?.cancel()
    }
    
    // MARK: Helper
    func timeRemaining(for timestamp: Int) -> TimeInterval {
        let targetDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return targetDate.timeIntervalSince(currentTime)
    }
}
