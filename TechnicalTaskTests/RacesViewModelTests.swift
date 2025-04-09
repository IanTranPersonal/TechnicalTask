//
//  RacesViewModelTests.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 9/4/2025.
//

import Testing
import Combine
import SwiftUI
@testable import TechnicalTask

struct RacesViewModelTests {
    
    // MARK: - Test Cases
    @Test("First Load Tests")
    func testInitialState() async {
        let vm = await RacesViewModel()
        await #expect(vm.objects.isEmpty)
        await #expect(vm.displayedRaces.isEmpty)
        await #expect(vm.selectedCategory == nil)
        await #expect(vm.errorString.isEmpty)
    }
    
    @Test("Test Displayed Races")
    func testDisplayedRaces() async {
        // Started 10s ago (within 60s cutoff)
        let recentlyStartedRace = RaceSummaryModel(
            raceID: "1",
            raceName: "Past Race",
            meetingName: "Meeting 1",
            raceNumber: 1,
            raceStart: Int(Date().timeIntervalSince1970 - 10),
            category: .horseRacing
        )
        // Current races
        let firstCurrentRace = RaceSummaryModel(
            raceID: "2",
            raceName: "Upcoming Race 1",
            meetingName: "Meeting 2",
            raceNumber: 2,
            raceStart: Int(Date().timeIntervalSince1970 + 100),
            category: .greyhound
        )
        let secondCurrentRace = RaceSummaryModel(
            raceID: "3",
            raceName: "Upcoming Race 2",
            meetingName: "Meeting 3",
            raceNumber: 3,
            raceStart: Int(Date().timeIntervalSince1970 + 200),
            category: .harness
        )
        
        let vm = await RacesViewModel()
        await vm.updateRaceData(races: [recentlyStartedRace, firstCurrentRace, secondCurrentRace])
        
        // Check all 3 races are showing
        await #expect(vm.displayedRaces.count == 3)
        // Check the first race is the one already started
        await #expect(vm.displayedRaces.first?.raceID == "1")
    }

    @Test("Test Filtering Race Types")
    func testRaceFilter() async throws {
        let vm = await RacesViewModel()
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
        await vm.updateRaceData(races: [horseRace, greyhoundRace])

        // Test no filter
        #expect(await vm.displayedRaces.count == 2)

        // Test horse racing filter
        await vm.setFilter(category: .horseRacing)
        #expect(await vm.displayedRaces.count == 1)
        #expect(await vm.displayedRaces.first?.category == .horseRacing)

        // Test greyhound filter
        await vm.setFilter(category: .greyhound)
        #expect(await vm.displayedRaces.count == 1)
        #expect(await vm.displayedRaces.first?.category == .greyhound)
    }

    @Test("Test Removed races after expiration")
    func testExpiredRaceCleanup() async throws {
        let vm = await RacesViewModel()
        let expiredRace = RaceSummaryModel(
            raceID: "1",
            raceName: "Expired Race",
            meetingName: "Meeting 1",
            raceNumber: 1,
            raceStart: Int(Date().timeIntervalSince1970 - 100), // Started 100s ago
            category: .horseRacing
        )
        let validRace = RaceSummaryModel(
            raceID: "2",
            raceName: "Valid Race",
            meetingName: "Meeting 2",
            raceNumber: 2,
            raceStart: Int(Date().timeIntervalSince1970 + 100), // Starts in 100s
            category: .greyhound
        )
        await vm.updateRaceData(races: [expiredRace, validRace])

        // Expired race should be removed
        #expect(await vm.objects.count == 1)
        #expect(await vm.objects.first?.raceID == "2")
    }

    @Test func testDisplayLogic() async throws {
        let vm = await RacesViewModel()
        let pastRace = RaceSummaryModel(
            raceID: "1",
            raceName: "Past Race",
            meetingName: "Meeting 1",
            raceNumber: 1,
            raceStart: Int(Date().timeIntervalSince1970 - 10), // Started 10s ago (within 60s cutoff)
            category: .horseRacing
        )
        let upcomingRace1 = RaceSummaryModel(
            raceID: "2",
            raceName: "Upcoming Race 1",
            meetingName: "Meeting 2",
            raceNumber: 2,
            raceStart: Int(Date().timeIntervalSince1970 + 100),
            category: .greyhound
        )
        let upcomingRace2 = RaceSummaryModel(
            raceID: "3",
            raceName: "Upcoming Race 2",
            meetingName: "Meeting 3",
            raceNumber: 3,
            raceStart: Int(Date().timeIntervalSince1970 + 200),
            category: .horseRacing
        )
        await vm.updateRaceData(races: [pastRace, upcomingRace1, upcomingRace2])

        // Should show past race + up to 5 upcoming races
        #expect(await vm.displayedRaces.count == 3)
        #expect(await vm.displayedRaces.first?.raceID == "1") // Past race first
    }
}

