//
//  MainRaceCard.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI

struct MainRaceCard: View {
    let model: RaceSummaryModel
    @ObservedObject var timerService: TimerService
    
    init(model: RaceSummaryModel, timerService: TimerService) {
        self.model = model
        self.timerService = timerService
    }
    
    var body: some View {
        HStack {
            Image(systemName: model.raceIconName)
            Text(model.raceNameDisplay)
            Spacer()
            RaceTimerView(timerService: timerService, raceStartTimestamp: TimeInterval(model.raceStart))
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 8)
                .fill(.clear)
                .stroke(.secondary, style: .init(lineWidth: 3))
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
    MainRaceCard(model: RaceSummaryModel.dummyRace, timerService: TimerService())
}
