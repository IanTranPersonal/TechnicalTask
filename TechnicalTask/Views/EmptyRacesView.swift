//
//  EmptyRacesView.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 9/4/2025.
//

import SwiftUI
// MARK: EmptyRacesView
struct EmptyRacesView : View {
    @ObservedObject var model: RacesViewModel
    var body: some View {
        VStack (spacing: 20) {
            Text("There doesn't seem to be any races yet...")
            
            if !model.errorString.isEmpty {
                Text(model.errorString)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            Button(action: grabData) {
                VStack {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("Refresh")
                }
            }
        }
    }
    
    private func grabData() {
        Task {
            try await model.grabData()
        }
    }
}

