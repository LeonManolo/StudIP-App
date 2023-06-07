//
//  DataProviderTests.swift
//  WidgetDataProviderTests
//
//  Created by Finn Ebeling on 06.06.23.
//

import XCTest
@testable import WidgetDataProvider

final class DataProviderTests: XCTestCase {
    private var oauthClient: MockedOAuthClient!
    private var cacheProvider: MockedCacheProvider!
    private var sut: DataProvider!
    
    private func setupSut() {
        oauthClient = MockedOAuthClient()
        cacheProvider = MockedCacheProvider()
        sut = DataProvider(oauthClient: oauthClient, cacheProvider: cacheProvider)
    }
    
    // MARK: - loadRemoteScheduleItems
    
    func test_loadRemoteScheduleItems_returnScheduleEntry() async throws {
        setupSut()

        let date = try XCTUnwrap(Calendar.german.date(from: DateComponents(year: 2023, month: 5, day: 15, hour: 14, minute: 0)))
        let scheduleItems = try await sut.loadRemoteScheduleItems(for: date)

        XCTAssertEqual(scheduleItems[0].title, "Vorlesung 1")
        XCTAssertEqual(scheduleItems[1].title, "Eintrag 2")
    }
    
    func test_loadRemoteScheduleItems_returnNoScheduleEntry_tooLate() async throws {
        setupSut()

        let date = try XCTUnwrap(Calendar.german.date(from: DateComponents(year: 2023, month: 5, day: 15, hour: 14, minute: 1)))
        let scheduleItems = try await sut.loadRemoteScheduleItems(for: date)

        XCTAssertTrue(scheduleItems.isEmpty)
    }
    
    func test_loadRemoteScheduleItems_returnNoScheduleEntry_excludedDate() async throws {
        setupSut()

        let date = try XCTUnwrap(Calendar.german.date(from: DateComponents(year: 2023, month: 5, day: 1, hour: 14, minute: 0)))
        let scheduleItems = try await sut.loadRemoteScheduleItems(for: date)

        XCTAssertTrue(scheduleItems.isEmpty)
    }
    
    func test_loadRemoteScheduleItems_returnNoScheduleEntry_2WeekInterval() async throws {
        setupSut()

        let date = try XCTUnwrap(Calendar.german.date(from: DateComponents(year: 2023, month: 6, day: 19, hour: 14, minute: 0)))
        let scheduleItems = try await sut.loadRemoteScheduleItems(for: date)

        XCTAssertTrue(scheduleItems.isEmpty)
    }
}

