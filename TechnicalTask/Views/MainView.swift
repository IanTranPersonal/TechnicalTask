//
//  MainView.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model: RacesViewModel
    
    var body: some View {
        if model.hasItems {
            VStack {
                CategoryFilterBar(viewModel: model)
                ScrollView {
                    ForEach(model.displayedRaces, id: \.self) { race in
                        MainRaceCard(model: race, timerService: model.timeService)
                    }
                }
                .refreshable {
                    Task {
                        try await model.grabData()
                    }
                }
            }
        }
        else {
            EmptyRacesView(model: model)
        }
    }
}

#Preview {
    MainView(model: .init())
}
