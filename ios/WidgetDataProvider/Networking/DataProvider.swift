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
    
    /// - Parameter date: The current Date. Injectable for testing purposes
    public func loadRemoteScheduleItems(for date: Date) async throws -> [ScheduleItem] {
        let currentUser: UserResponse = try await oauthClient.get(rawUrlString: "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/me", queryItems: [])
        
        let eventRawUrlString = "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/\(currentUser.data.id)/schedule"
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
    
    public func fetchLocalScheduleItems() -> [ScheduleItem] {
        cacheProvider.scheduleItems()
    }
}
