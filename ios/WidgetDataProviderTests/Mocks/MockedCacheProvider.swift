//
//  MockedCacheProvider.swift
//  WidgetDataProviderTests
//
//  Created by Finn Ebeling on 06.06.23.
//

import Foundation
@testable import WidgetDataProvider

struct MockedCacheProvider: CacheProvider {
    func save(scheduleItems: [ScheduleItem]) {}
    func scheduleItems() -> [ScheduleItem] { [] }
}
