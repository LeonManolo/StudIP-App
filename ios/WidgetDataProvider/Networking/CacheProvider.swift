//
//  CacheService.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import Foundation

public protocol CacheProvider {
    func save(scheduleItems: [ScheduleItem])
    func scheduleItems() -> [ScheduleItem]
    func isTokenRefreshEnabled() -> Bool
    func removeIsTokenRefreshEnabledToggle()
}

public class DefaultCacheProvider: CacheProvider {
    let userDefaults: UserDefaults
    private let scheduleItemsKey = "scheduleItems"
    private let isTokenRefreshEnabledKey = "isTokenRefreshEnabled"
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func save(scheduleItems: [ScheduleItem]) {
        guard let encodedScheduleItems = try? JSONEncoder().encode(scheduleItems) else { return }
        
        userDefaults.set(encodedScheduleItems, forKey: scheduleItemsKey)
    }
    
    public func scheduleItems() -> [ScheduleItem] {
        guard let rawScheduleItems = userDefaults.data(forKey: scheduleItemsKey) else { return [] }
        
        return (try? JSONDecoder().decode([ScheduleItem].self, from: rawScheduleItems)) ?? []
    }
    
    public func isTokenRefreshEnabled() -> Bool {
        // if no value is stored, then token refresh should be enabled by default
        userDefaults.object(forKey: isTokenRefreshEnabledKey) as? Bool ?? true
    }
    
    public func removeIsTokenRefreshEnabledToggle() {
        userDefaults.removeObject(forKey: isTokenRefreshEnabledKey)
    }
}
