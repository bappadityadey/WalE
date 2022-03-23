//
//  NASAViewModel.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation

struct NASAViewModel {
    let service: NASAAPIServiceable = NASAAPIService()
    
    func fetchDailyImage() async -> Result<NASADailyImage, RequestError> {
        let result = await service.getDailyImage()
        switch result {
        case .success(let imageResponse):
            return .success(imageResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getTitle() -> String {
        return "Daily Image"
    }
}
