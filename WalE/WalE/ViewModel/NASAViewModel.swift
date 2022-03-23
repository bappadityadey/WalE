//
//  NASAViewModel.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import Foundation
import Network
import Combine

class NASAViewModel {
    
    let service: NASAAPIServiceable = NASAAPIService()
    
    func fetchDailyImage() async -> Result<NASADailyImage, RequestError> {
        let result = await service.getDailyImage()
        switch result {
        case .success(let imageResponse):
            saveResponse(model: imageResponse)
            return .success(imageResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getTitle() -> String {
        return "Daily Image"
    }
    
    private func saveResponse(model: NASADailyImage) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "DailyImage")
        }
    }
    
    func fetchSavedDailyImageModel() -> NASADailyImage? {
        let defaults = UserDefaults.standard
        if let dailyImage = defaults.object(forKey: "DailyImage") as? Data {
            let decoder = JSONDecoder()
            if let loadedImage = try? decoder.decode(NASADailyImage.self, from: dailyImage) {
                return loadedImage
            }
        }
        return nil
    }
}
