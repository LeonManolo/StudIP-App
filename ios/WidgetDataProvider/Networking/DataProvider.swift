//
//  NetworkService.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import Foundation

public class DataProvider {
    private let oauthClient: OAuthClient
    private let cacheProvider: CacheProvider
    
    public init(oauthClient: OAuthClient, cacheProvider: CacheProvider) {
        self.oauthClient = oauthClient
        self.cacheProvider = cacheProvider
    }
    
    /// This method can be used to load all `ScheduleItem`s for a given `date` from Stud.IP. The result is filtered based on interval and excluded dates.
    /// Only schedule entries which have a later `startDate` compared to the injected `date` are returned.
    /// - Parameter date: The current Date. Injectable for testing purposes
    /// - Returns: Loaded `ScheduleItem`s sorted ascending based on `startDate`
    public func loadRemoteScheduleItems(for date: Date) async throws -> [ScheduleItem] {
        let currentUser: UserResponse = try await oauthClient.get(rawUrlString: "http://miezhaus.feste-ip.net:32555/jsonapi.php/v1/users/me", queryItems: [])
        
        let eventRawUrlString = "http://miezhaus.feste-ip.net:32555/jsonapi.php/v1/users/\(currentUser.data.id)/schedule"
        let scheduleResponse: ScheduleResponse = try await oauthClient.get(rawUrlString: eventRawUrlString, queryItems: [])
        
        
        guard let currentDay = date.weekday else { return [] }
        
        let scheduleItems: [ScheduleItem] = scheduleResponse.data
            .compactMap { scheduleData in
                let attributes = scheduleData.attributes
                guard currentDay == attributes.weekday.rawValue,
                      let startDate = Calendar.german.set(hourMinuteFrom: attributes.start, for: date),
                      let endDate = Calendar.german.set(hourMinuteFrom: attributes.end, for: date),
                      startDate >= date else { return nil }
                
                if Calendar.german.is(date: startDate, in: attributes.recurrence) ?? true {
                    return ScheduleItem(
                        startDate: startDate,
                        endDate: endDate,
                        title: attributes.title,
                        locations: attributes.locations
                    )
                } else {
                    return nil
                }
            }
            .sorted { $0.startDate < $1.startDate }
        
        cacheProvider.save(scheduleItems: scheduleItems)
        return scheduleItems
    }
    
    /// Fetches the current cached `ScheduleItem`s
    public func fetchLocalScheduleItems() -> [ScheduleItem] {
        cacheProvider.scheduleItems()
    }
}
