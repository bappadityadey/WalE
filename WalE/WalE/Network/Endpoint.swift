//
//  Endpoint.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.nasa.gov/planetary/apod"
    }
}
