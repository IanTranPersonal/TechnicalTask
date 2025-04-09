//
//  RaceTimerView.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI
// MARK: Timer view
struct RaceTimerView: View {
    var timerService: TimerService
    let raceStartTimestamp: TimeInterval
    
    var body: some View {
        Text(formattedTimeRemaining)
            .font(.body)
            .foregroundColor(timeRemainingColor)
    }
    
    private var timeRemaining: TimeInterval {
        timerService.timeRemaining(for: Int(raceStartTimestamp))
    }
    
    private var formattedTimeRemaining: String {
        if timeRemaining <= -59 {
            return "Underway"
        }
        
        let minutes = Int(timeRemaining) / Constants.racesStartBuffer
        let seconds = Int(timeRemaining) % Constants.racesStartBuffer
        if minutes <= 0 {
            return "\(seconds)s"
        }
        return "\(minutes)m \(seconds)s"
        
    }
    
    private var timeRemainingColor: Color {
        switch timeRemaining {
        case ...0: return .gray
        case 0..<60: return .red
        case 60..<300: return .green
        default: return .primary
        }
    }
}

