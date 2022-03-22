//
//  NASAEndpoint.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation

enum NASAEndpoint {
    case dailyImage
}

extension NASAEndpoint: Endpoint {
    var queryItems: [URLQueryItem]? {
        switch self {
        case .dailyImage:
            return [URLQueryItem(name: "api_key", value: "IHzS6YG8xv7bc7q5qbSVn3lErj1ejeJ8fhPP6eNY")]
        }
    }
    
    var path: String {
        switch self {
        case .dailyImage:
            return "?"
        }
    }

    var method: RequestMethod {
        switch self {
        case .dailyImage:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        let accessToken = "IHzS6YG8xv7bc7q5qbSVn3lErj1ejeJ8fhPP6eNY"
        switch self {
        case .dailyImage:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .dailyImage:
            return nil
        }
    }
}
