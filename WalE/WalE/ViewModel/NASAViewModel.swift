//
//  NASAViewModel.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation

struct NASAViewModel {
    let service: NASAAPIServiceable = NASAAPIService()
    
    func fetchDailyImage() {
        Task(priority: .background) {
            let result = await service.getDailyImage()
            switch result {
            case .success(let imageResponse):
                print(imageResponse.url)
            case .failure(let error):
                print(error.customMessage)
            }
        }
    }
}
