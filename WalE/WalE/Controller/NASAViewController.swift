//
//  NASAViewController.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import UIKit
import Combine

class NASAViewController: UIViewController {
    
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
        
        network?.$connected.sink(receiveValue: { [weak self] status in
            guard let self = self else { return }
            if status == true {
                self.fetchDailyImage()
            } else if status == false {
                print("No internet connction")
                if let imageModel = self.viewModel?.fetchSavedDailyImageModel() {
                    Task(priority: .background) {
                        await self.loadDailyImage(imageModel: imageModel)
                    }
                }
            }
        }).store(in: &anyCancellables)
    }
    
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
    
    private func loadDailyImage(imageModel: NASADailyImage) async {
        if (imageModel.media_type == Constants.MediaType.image.rawValue) {
            await dailyImageView.loadImage(withUrl: imageModel.url)
        } else {
            dailyImageView.image = UIImage(named: Constants.NoImage)
        }
        titleLabel.text = imageModel.title
        descriptionTextView.text = imageModel.explanation
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
    func showAlert(error: String?) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.fetchDailyImage()
        }))
        present(alert, animated: true)
    }
}
