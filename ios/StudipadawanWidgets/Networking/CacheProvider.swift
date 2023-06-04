//
//  CacheService.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import Foundation

class CacheProvider {
    let userDefaults: UserDefaults
    private let scheduleItemsKey = "scheduleItems"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func save(scheduleItems: [ScheduleItem]) {
        guard let encodedScheduleItems = try? JSONEncoder().encode(scheduleItems) else { return }
        
        userDefaults.set(encodedScheduleItems, forKey: scheduleItemsKey)
    }
    
    func scheduleItems() -> [ScheduleItem] {
        guard let rawScheduleItems = userDefaults.data(forKey: scheduleItemsKey) else { return [] }
        
        return (try? JSONDecoder().decode([ScheduleItem].self, from: rawScheduleItems)) ?? []
    }
}
