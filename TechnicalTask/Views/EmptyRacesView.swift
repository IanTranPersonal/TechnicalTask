//
//  EmptyRacesView.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 9/4/2025.
//

import SwiftUI
// MARK: EmptyRacesView
struct EmptyRacesView : View {
    var model: RacesViewModel
    var body: some View {
        VStack (spacing: 20) {
            Text("emptyTextTitle".localized)
                .font(.subheadline)
                .bold()
            
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
                    Text("refreshButtonTitle".localized)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func grabData() {
        Task {
            try await model.grabData()
        }
    }
}

#Preview {
    EmptyRacesView(model: .init())
}

