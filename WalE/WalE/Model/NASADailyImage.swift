//
//  NASADailyImage.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation

struct NASADailyImage: Codable {
    let date: String
    let explanation: String
    let title: String
    let url: String
    let hdurl: String
    let media_type: String
    let service_version: String
}
