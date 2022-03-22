//
//  NASAAPIService.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation

protocol NASAAPIServiceable {
    func getDailyImage() async -> Result<NASADailyImage, RequestError>
}

struct NASAAPIService: HTTPClient, NASAAPIServiceable {
    func getDailyImage() async -> Result<NASADailyImage, RequestError> {
        return await sendRequest(endpoint: NASAEndpoint.dailyImage, responseModel: NASADailyImage.self)
    }
}
