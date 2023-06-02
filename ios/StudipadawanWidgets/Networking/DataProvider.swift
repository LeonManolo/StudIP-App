//
//  NetworkService.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import Foundation

class DataProvider {
    private let oauthClient: OAuthClient
    private let cacheProvider: CacheProvider
    
    init(oauthClient: OAuthClient, cacheProvider: CacheProvider) {
        self.oauthClient = oauthClient
        self.cacheProvider = cacheProvider
    }
    
    func loadRemoteScheduleItems() async throws -> [ScheduleItem] {
        let currentUser: UserResponse = try await oauthClient.get(rawUrlString: "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/me")
        
        let eventRawUrlString = "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/\(currentUser.data.id)/schedule"
        let scheduleResponse: ScheduleResponse = try await oauthClient.get(rawUrlString: eventRawUrlString)
        
        
        guard let currentDay = Date().weekday else { return [] }
        
        let scheduleItems: [ScheduleItem] = scheduleResponse.data
            .compactMap { scheduleData in
                let attributes = scheduleData.attributes
                guard currentDay == attributes.weekday.rawValue,
                      let startDate = Calendar.german.today(at: attributes.start),
                      let endDate = Calendar.german.today(at: attributes.end),
                      startDate >= Date() else { return nil }
                
                if Calendar.german.isDate(in: attributes.recurrence, date: startDate) ?? true {
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
        scheduleItems.forEach { print($0) }
        print("--")
        return scheduleItems
    }
    
    func fetchLocalScheduleItems() -> [ScheduleItem] {
        cacheProvider.scheduleItems()
    }
    
}
