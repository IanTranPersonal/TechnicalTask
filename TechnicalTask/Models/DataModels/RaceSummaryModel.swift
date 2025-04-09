//
//  RaceSummaryModel.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI

public struct RaceSummaryModel: Hashable {
    public let raceID: String
    public let raceName: String
    public let meetingName: String
    public let raceNumber: Int
    public let raceStart: Int
    public let category: RaceCategory
    
    public init(raceID: String, raceName: String, meetingName: String, raceNumber: Int, raceStart: Int, category: RaceCategory) {
        self.raceID = raceID
        self.raceName = raceName
        self.meetingName = meetingName
        self.raceNumber = raceNumber
        self.raceStart = raceStart
        self.category = category
    }
    
    var raceNameDisplay: String { "\(meetingName) R\(raceNumber)" }
    
    // Note: These icon names will be updated with actual images
    var raceIconName: String {
        switch category {
        case .greyhound: "dog"
        case .horseRacing: "car"
        case .harness: "figure.seated.seatbelt"
        }
    }
    
    static var dummyRace: RaceSummaryModel {
        .init(
            raceID: "1",
            raceName: "Dummy Race",
            meetingName: "Dummy Meeting",
            raceNumber: 1,
            raceStart: 60,
            category: .horseRacing
        )
    }
}
