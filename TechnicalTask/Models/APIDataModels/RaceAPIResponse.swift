//
//  RaceAPIResponse.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI

struct RaceAPIResponse: Codable {
    let status: Int
    let data: ResponseData
}

struct ResponseData: Codable {
    let nextToGoIds: [String]
    let raceSummaries: [String: RaceSummary]
    
    enum CodingKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

struct RaceSummary: Codable {
    let raceId: String
    let raceName: String
    let raceNumber: Int
    let meetingId: String
    let meetingName: String
    let categoryId: String
    let advertisedStart: AdvertisedStart
    let venueId: String
    let venueName: String
    let venueState: String
    let venueCountry: String
    
    enum CodingKeys: String, CodingKey {
        case raceId = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingId = "meeting_id"
        case meetingName = "meeting_name"
        case categoryId = "category_id"
        case advertisedStart = "advertised_start"
        case venueId = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
}

struct AdvertisedStart: Codable {
    let seconds: Int
}

public enum RaceCategory: String, CaseIterable {
    case horseRacing = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    
    var displayName: String {
        switch self {
        case .horseRacing: return "Horses"
        case .greyhound: return "Greyhounds"
        case .harness: return "Harness"
        }
    }
}
