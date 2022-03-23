//
//  NASAViewController.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import UIKit
import Combine

class NASAViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: NASAViewModel?
    var network: Network?
    
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private var anyCancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        navigationItem.title = viewModel?.getTitle()
        viewModel = NASAViewModel()
        network = Network()
        
        /// check for internet connectivity
        network?.$connected.sink(receiveValue: { [weak self] status in
            guard let self = self else { return }
            if status == true {
                self.fetchDailyImage()
            } else if status == false {
                print("No internet connction")
                if let imageModel = self.viewModel?.fetchSavedDailyImageModel() {
                    Task(priority: .background) {
                        let result = await self.isPreviousDailyImage(imageModel: imageModel)
                        if result {
                            self.showAlert(error: "We are not connected to the internet, showing you the last image we have.")
                        }
                        await self.loadDailyImage(imageModel: imageModel)
                    }
                } else {
                    self.showAlert(error: "We are not connected to the internet.")
                }
            }
        }).store(in: &anyCancellables)
    }
    
    // MARK: - Fetch Daily Image
    private func fetchDailyImage() {
        Task(priority: .background) {
            startLoading()
            let result = await viewModel?.fetchDailyImage()
            stopLoading()
            switch result {
            case .success(let imageModel):
                await loadDailyImage(imageModel: imageModel)
            case .failure(let error):
                showAlert(error: error.customMessage)
            case .none:
                break
            }
        }
    }
    
    // MARK: - View Daily Image
    private func loadDailyImage(imageModel: NASADailyImage) async {
        if (imageModel.media_type == Constants.MediaType.image.rawValue) {
            await dailyImageView.loadImage(withUrl: imageModel.url)
        } else {
            dailyImageView.image = UIImage(named: Constants.NoImage)
        }
        titleLabel.text = imageModel.title
        descriptionTextView.text = imageModel.explanation
    }
    
    // Check if the last downloaded image was on today or previous day
    private func isPreviousDailyImage(imageModel: NASADailyImage) async -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
        if let date = dateFormatter.date(from: imageModel.date) {
            let today = Date()
            if date.hasSame(.day, as: today) {
                return false
            }
        }
        return true
    }
    
    private func addActivityIndicator() {
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    deinit {
        anyCancellables.forEach({ $0.cancel() })
        anyCancellables.removeAll()
    }
}

extension NASAViewController {
    // MARK: Show alert in case of error
    func showAlert(error: String?) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
