//
//  NetworkService.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 9/4/2025.
//

import SwiftUI
import Observation

@Observable
class NetworkService {
    var errorString: String = ""
    
    func fetchRaces() async throws -> [RaceSummaryModel] {
        do {
            guard let url = URL(string: Constants.baseURLString) else {
                throw URLError(.badURL)
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            guard let apiResponse = try? decoder.decode(RaceAPIResponse.self, from: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            let raceSummaries = apiResponse.data.raceSummaries.values
            return raceSummaries.compactMap {
                RaceSummaryModel(
                    raceID: $0.raceId,
                    raceName: $0.raceName,
                    meetingName: $0.meetingName,
                    raceNumber: $0.raceNumber,
                    raceStart: Int($0.advertisedStart.seconds),
                    category: RaceCategory(rawValue: $0.categoryId) ?? .horseRacing // Only in the event a different category ID is passed
                )
            }
        } catch {
            errorString = "Error fetching races: \n\(error.localizedDescription)"
            throw error
        }
    }
}
