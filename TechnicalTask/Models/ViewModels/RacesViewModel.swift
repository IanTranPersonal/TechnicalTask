//
//  RacesViewModel.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI
import Observation

@MainActor
@Observable
class RacesViewModel {
    // MARK: - Published Properties
    var objects: [RaceSummaryModel] = []
    var displayedRaces: [RaceSummaryModel] = []
    var selectedCategory: [RaceCategory] = RaceCategory.allCases
    var errorString: String = ""
    
    // MARK: - Public Properties
    var hasItems: Bool { !displayedRaces.isEmpty }
    
    // MARK: - Services
    let timeService = TimerService()
    
    
   private var raceCheckingTask: Task<Void, Never>?
    
    init() {
        setupRaceChecking()
        Task { try await grabData() }
    }
    
    deinit {
        Task { @MainActor [weak self] in
            self?.raceCheckingTask?.cancel()
        }
    }
    
    // MARK: - Public Methods
    func updateRaceData(races: [RaceSummaryModel]) {
        self.objects = races
        updateDisplayedRaces()
    }
    
    func setFilter(category: [RaceCategory]) {
        withAnimation {
            self.selectedCategory = category
            updateDisplayedRaces()
        }
    }
    
    func grabData() async throws {
        do {
            let races = try await fetchRaces()
            // Merge new races with existing ones, avoiding duplicates
            let existingRaceIDs = Set(objects.map { $0.raceID })
            let uniqueNewRaces = races.filter { !existingRaceIDs.contains($0.raceID) }
            // Add unique new races to our collection
            objects.append(contentsOf: uniqueNewRaces)
            // Clean up expired races
            cleanupExpiredRacesIfNeeded()
            updateDisplayedRaces()
        } catch {
            errorString = "errorMessage".localized(with: error.localizedDescription)
        }
    }
    
    // MARK: - Private Methods
    private func setupRaceChecking() {
        raceCheckingTask = Task { [weak self] in
            while !Task.isCancelled {
                self?.updateDisplayedRaces()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    func updateDisplayedRaces() {
        let currentTime = Date().timeIntervalSince1970
        cleanupExpiredRacesIfNeeded()
        // Get races that haven't passed the 60-second cutoff
        let availableRaces = objects.filter { race in
            let cutoffTime = TimeInterval(race.raceStart + Constants.racesStartBuffer)
            return currentTime <= cutoffTime
        }
        // Apply category filter if selected
        let filteredRaces = applyCategoryFilter(races: availableRaces)
        // Sort races by advertised start time (ascending)
        let sortedRaces = filteredRaces.sorted { $0.raceStart < $1.raceStart }
        // Get started races + 5 Upcoming races
        var finalRacesToShow: [RaceSummaryModel] {
            var startedRaces = sortedRaces.filter { currentTime > TimeInterval($0.raceStart)}
            let upcomingRaces = sortedRaces.filter { currentTime <= TimeInterval($0.raceStart)}
            startedRaces.append(contentsOf: upcomingRaces.prefix(Constants.minimumRaces))
            return startedRaces
        }
        // Update the displayed list only if there's a change
        if !finalRacesToShow.elementsEqual(displayedRaces) {
            DispatchQueue.main.async {
                withAnimation {
                    self.displayedRaces = finalRacesToShow
                }
            }
        }
        // Check if we need to fetch more races
        checkAndFetchMoreRacesIfNeeded(availableRaces: availableRaces)
    }
    
    func cleanupExpiredRacesIfNeeded() {
        let currentTime = Date().timeIntervalSince1970
        // Clean up expired races past started 60s
        objects.removeAll { race in
            let expirationTime = TimeInterval(race.raceStart + Constants.racesStartBuffer)
            return currentTime > expirationTime
        }
    }
    
    private func applyCategoryFilter(races: [RaceSummaryModel]) -> [RaceSummaryModel] {
        guard !selectedCategory.isEmpty else {
            selectedCategory = RaceCategory.allCases
            return races
        }
        return races.filter {selectedCategory.contains( $0.category )}
    }
    
    private func checkAndFetchMoreRacesIfNeeded(availableRaces: [RaceSummaryModel]) {
        let currentTime = Date().timeIntervalSince1970
        // Check upcoming races (not started yet)
        let upcomingRaces = availableRaces.filter { currentTime < TimeInterval($0.raceStart) }
        // Check upcoming races that match current filter
        let filteredUpcomingRaces = applyCategoryFilter(races: upcomingRaces)
        // If fewer than 5 races or fewer than 50 upcoming races, get more (in order to make sure we have enough filtered categories
        if filteredUpcomingRaces.count < 5 || upcomingRaces.count < 50 {
            Task {
                try await grabData()
            }
        }
    }
    
    private func fetchRaces() async throws -> [RaceSummaryModel] {
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
    
    private func cleanUp() {
        raceCheckingTask?.cancel()
        raceCheckingTask = nil
    }
}

