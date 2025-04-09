//
//  RacesViewModel.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 8/4/2025.
//

import SwiftUI
import Combine
import Observation

@MainActor
@Observable
final class RacesViewModel {
    // MARK: - Published Properties
    var objects: [RaceSummaryModel] = []
    var displayedRaces: [RaceSummaryModel] = []
    var selectedCategory: [RaceCategory] = RaceCategory.allCases
    var errorString: String = ""
    
    // MARK: - Public Properties
    var hasItems: Bool { !displayedRaces.isEmpty }
    
    // MARK: - Services
    let timeService = TimerService()
    let networkService = NetworkService()
    // MARK: - Private Properties
    private var timerCancellable: AnyCancellable?
    
    init() {
        setupRaceChecking()
        Task {
            try await grabData()
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
            let races = try await networkService.fetchRaces()
            // Merge new races with existing ones, avoiding duplicates
            let existingRaceIDs = Set(objects.map { $0.raceID })
            let uniqueNewRaces = races.filter { !existingRaceIDs.contains($0.raceID) }
            // Add unique new races to our collection
            objects.append(contentsOf: uniqueNewRaces)
            // Clean up expired races
            cleanupExpiredRaces()
            updateDisplayedRaces()
        } catch {
            errorString = "Error fetching races: \n\(error.localizedDescription)"
        }
    }
    
    // MARK: - Private Methods
    private func setupRaceChecking() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateDisplayedRaces()
            }
    }
    
    private func updateDisplayedRaces() {
        let currentTime = Date().timeIntervalSince1970
        // Clean up expired races past started 60s
        cleanupExpiredRaces()
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
    
    private func cleanupExpiredRaces() {
        let currentTime = Date().timeIntervalSince1970
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
        // Calculate upcoming races (not started yet)
        let upcomingRaces = availableRaces.filter { currentTime < TimeInterval($0.raceStart) }
        // Calculate upcoming races that match current filter
        let filteredUpcomingRaces = applyCategoryFilter(races: upcomingRaces)
        // If fewer than 5 races or fewer than 50 upcoming races, get more (in order to make sure we have enough filtered categories
        if filteredUpcomingRaces.count < 5 || upcomingRaces.count < 50 {
            Task {
                try await grabData()
            }
        }
    }
}

