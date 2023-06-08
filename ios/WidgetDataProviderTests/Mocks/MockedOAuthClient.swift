//
//  MockedOAuthClient.swift
//  WidgetDataProviderTests
//
//  Created by Finn Ebeling on 06.06.23.
//

import Foundation
@testable import WidgetDataProvider

enum MockedOAuthClientException: Error {
    case invalidData
    case missingMock
}

class MockedOAuthClient: OAuthClient {
    func get<T>(rawUrlString: String, queryItems: [URLQueryItem]) async throws -> T where T : Decodable, T : Encodable {
        
        if let userResponse = userResponse() as? T {
            return userResponse
        } else if let scheduleResponse = try? scheduleResponse() as? T {
            return scheduleResponse
        } else {
            throw MockedOAuthClientException.missingMock
        }
    }
    
    private func userResponse() -> UserResponse {
        UserResponse(data: .init(id: "f6e5879dd84fe0f21eae9f0627d4f807"))
    }
    
    private func scheduleResponse() throws -> ScheduleResponse {
        let rawScheduleResponse = """
            {
                "meta": {
                    "semester": "/jsonapi.php/v1/semesters/322f640f3f4643ebe514df65f1163eb1"
                },
                "links": {
                    "self": "/jsonapi.php/v1/users/f6e5879dd84fe0f21eae9f0627d4f807/schedule?filter%5Btimestamp%5D=1680300000"
                },
                "data": [
                            {
                                "type": "schedule-entries",
                                "id": "7",
                                "attributes": {
                                    "title": "Eintrag 2",
                                    "description": null,
                                    "start": "16:00",
                                    "end": "17:00",
                                    "weekday": 1,
                                    "color": "3"
                                },
                                "relationships": {
                                    "owner": {
                                        "links": {
                                            "related": "/jsonapi.php/v1/users/f6e5879dd84fe0f21eae9f0627d4f807"
                                        },
                                        "data": {
                                            "type": "users",
                                            "id": "f6e5879dd84fe0f21eae9f0627d4f807"
                                        }
                                    }
                                },
                                "links": {
                                    "self": "/jsonapi.php/v1/schedule-entries/7"
                                }
                            },
                            {
                                "type": "seminar-cycle-dates",
                                "id": "26540cfa2dfa122a34f161168db1e685",
                                "attributes": {
                                    "title": "Vorlesung 1",
                                    "description": null,
                                    "start": "14:00",
                                    "end": "14:30",
                                    "weekday": 1,
                                    "recurrence": {
                                        "FREQ": "WEEKLY",
                                        "INTERVAL": 2,
                                        "DTSTART": "2023-04-17T14:00:00+02:00",
                                        "UNTIL": "2023-07-10T14:00:00+02:00",
                                        "EXDATES": [
                                            "2023-05-01T14:00:00+02:00",
                                            "2023-05-29T14:00:00+02:00"
                                        ]
                                    },
                                    "locations": []
                                },
                                "relationships": {
                                    "owner": {
                                        "links": {
                                            "related": "/jsonapi.php/v1/courses/659293838e125e2fbf889210672a100f"
                                        },
                                        "data": {
                                            "type": "courses",
                                            "id": "659293838e125e2fbf889210672a100f"
                                        }
                                    }
                                },
                                "links": {
                                    "self": "/jsonapi.php/v1/seminar-cycle-dates/26540cfa2dfa122a34f161168db1e685"
                                }
                              }
                    ]
                }
        """
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        guard let scheduleData = rawScheduleResponse.data(using: .utf8) else { throw MockedOAuthClientException.invalidData }
        
        return try decoder.decode(ScheduleResponse.self, from: scheduleData)
    }
}
