//
//  RaceSummaryModelTests.swift
//  RaceSummaryModelTests
//
//  Created by Vinh Tran on 8/4/2025.
//

import Testing
import SwiftUI
import Combine
@testable import TechnicalTask

struct RaceSummaryModelTests {
    let dummyRace: RaceSummaryModel = .dummyRace
    
    @Test("Test Race Name Display")
    func testRaceNameDisplay() {
        #expect(dummyRace.raceNameDisplay == "Dummy Meeting R1")
    }
    
    @Test("Test Race Type Icon")
    func testRaceTypeIcon() {
        #expect(dummyRace.raceIconName == "car")
    }
}
