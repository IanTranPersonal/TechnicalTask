//
//  RacesViewModelTests.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 9/4/2025.
//

import Testing
import SwiftUI
@testable import TechnicalTask

@MainActor
struct RacesViewModelTests {
    
    // MARK: - Test Cases
    @Test("Test Initial State of RacesViewModel")
    func testInitialState() async throws {
        let vm = MockRacesViewModel()
        #expect(vm.selectedCategory == RaceCategory.allCases)
        #expect(vm.errorString.isEmpty)
    }
    
    @Test("Test Displayed Races (inc started race)")
    func testDisplayedRaces() async throws {
        let vm = MockRacesViewModel()
        let dummyRaces = [
            RaceViewModelHelpers.recentlyStartedRace,
            RaceViewModelHelpers.firstUpcomingRace,
            RaceViewModelHelpers.secondUpcomingRace
        ]
        // Update race data
        vm.updateRaceData(races: dummyRaces)
        try await Task.sleep(for: .milliseconds(100))
        
        // Verify race count
        #expect(vm.displayedRaces.count == 3, "Should display all 3 races")
        
        // Verify started race is first
        #expect(vm.displayedRaces.first?.raceID == "1", "Started race should be first")
    }

    @Test("Check Race Filtering")
    func testRaceFilter() async throws {
        let vm = MockRacesViewModel()
        
        // Add test data
        let horseRace = RaceSummaryModel(
            raceID: "1",
            raceName: "Horse Race",
            meetingName: "Meeting 1",
            raceNumber: 1,
            raceStart: Int(Date().timeIntervalSince1970 + 100),
            category: .horseRacing
        )
        
        let greyhoundRace = RaceSummaryModel(
            raceID: "2",
            raceName: "Greyhound Race",
            meetingName: "Meeting 2",
            raceNumber: 2,
            raceStart: Int(Date().timeIntervalSince1970 + 200),
            category: .greyhound
        )
        
        // Insert race data
        vm.updateRaceData(races: [horseRace, greyhoundRace])
        try await Task.sleep(for: .milliseconds(50))

        #expect(vm.displayedRaces.count == 2, "Should display both races when unfiltered")

        // Apply horse racing filter
        vm.setFilter(category: [.horseRacing])
        try await Task.sleep(for: .milliseconds(50))
        
        #expect(vm.displayedRaces.count == 1, "Should display only horse race")
        #expect(vm.displayedRaces.first?.category == .horseRacing, "Should be horse racing category")

        // Apply greyhound filter
        vm.setFilter(category: [.greyhound])
        try await Task.sleep(for: .milliseconds(50))
        #expect(vm.displayedRaces.count == 1, "Should display only greyhound race")
        #expect(vm.displayedRaces.first?.category == .greyhound, "Should be greyhound category")
        
        // Try to apply no filters
        vm.setFilter(category: [])
        try await Task.sleep(for: .milliseconds(50))
        #expect(vm.selectedCategory == RaceCategory.allCases, "Should have reset to all categories")
        #expect(vm.displayedRaces.count == 2, "Should have reset to showing all types")
    }

    @Test("Test Expired Races Cleanup")
    func testExpiredRaceCleanup() async throws {
        let vm = MockRacesViewModel()
        
        // Create an expired race that has started for more than 60s
        let expiredRace = RaceSummaryModel(
            raceID: "1",
            raceName: "Expired Race",
            meetingName: "Meeting 1",
            raceNumber: 1,
            raceStart: Int(Date().timeIntervalSince1970 - 200),
            category: .horseRacing
        )
        
        let testRaceData = [expiredRace, RaceViewModelHelpers.firstUpcomingRace]
        
        // Add both races
        vm.updateRaceData(races: testRaceData)
        try await Task.sleep(for: .milliseconds(100))
        
        // Run test cleanup (normally happens in updateDisplayedRaces)
        vm.dummyCleanupExpiredRaces()
        try await Task.sleep(for: .milliseconds(50))

        // Check that only the upcoming race remains
        #expect(vm.objects.count == 1, "Should have removed expired race")
        // And that it's the upcoming race (with ID 2)
        #expect(vm.objects.first?.raceID == "2", "Should only contain the upcoming race")
    }

    @Test("Test Race Ordering")
    func testRaceOrdering() async throws {
        let vm = MockRacesViewModel()
        let testRaces = [
            RaceViewModelHelpers.recentlyStartedRace,
            RaceViewModelHelpers.firstUpcomingRace,
            RaceViewModelHelpers.secondUpcomingRace
        ]
        // Update race data
        vm.updateRaceData(races: testRaces)
        try await Task.sleep(for: .milliseconds(100))

        // Verify display order and count
        #expect(vm.displayedRaces.count == 3, "Should display all races")
            #expect(vm.displayedRaces.first?.raceID == "1", "Started race should be first")
    }
}

// Mock implementation to avoid network calls and provide test hooks
@MainActor
class MockRacesViewModel: RacesViewModel {
    
    // Setup and immediately cancel timer checking.
    override init() {
        super.init()
        raceCheckingTask?.cancel()
    }
    
    override func grabData() async throws {} // Making sure we don't call out for actual data
    
    // Test helper to manually trigger cleanup
    func dummyCleanupExpiredRaces() {
        cleanupExpiredRacesIfNeeded()
        updateDisplayedRaces()
    }
}

// MARK: - Test Helpers
struct RaceViewModelHelpers {
    static let recentlyStartedRace = RaceSummaryModel(
        raceID: "1",
        raceName: "Recently Started Race",
        meetingName: "Meeting 1",
        raceNumber: 1,
        raceStart: Int(Date().timeIntervalSince1970 - 10), // Started 10s ago (within limits)
        category: .horseRacing
    )
    
    static let firstUpcomingRace = RaceSummaryModel(
        raceID: "2",
        raceName: "Upcoming Race 1",
        meetingName: "Meeting 2",
        raceNumber: 2,
        raceStart: Int(Date().timeIntervalSince1970 + 100),
        category: .greyhound
    )
    
    static let secondUpcomingRace = RaceSummaryModel(
        raceID: "3",
        raceName: "Upcoming Race 2",
        meetingName: "Meeting 3",
        raceNumber: 3,
        raceStart: Int(Date().timeIntervalSince1970 + 200),
        category: .horseRacing
    )
}
