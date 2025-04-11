//
//  RaceSummaryModelTests.swift
//  RaceSummaryModelTests
//
//  Created by Vinh Tran on 8/4/2025.
//

import Testing
import SwiftUI

@testable import TechnicalTask

struct RaceSummaryModelTests {
    let dummyRace: RaceSummaryModel = .dummyRace
    
    @Test("Test Race Name Display")
    func testRaceNameDisplay() {
        var testRace = dummyRace
        #expect(dummyRace.raceNameDisplay == "Dummy Meeting R1")
    }
    
    // MARK: - Race Category Test
    @Test("Test Race Category Image")
    func testCategoryImageName() {
        var category = dummyRace.category
        #expect(category.imageName == "car")
        category = .harness
        #expect(category.imageName == "figure.seated.seatbelt")
        category = .greyhound
        #expect(category.imageName == "dog")
    }

}
