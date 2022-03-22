//
//  NASAViewController.swift
//  WalE
//
//  Created by Bappaditya Dey on 22/03/22.
//

import UIKit

class NASAViewController: UIViewController {
    
    let viewModel: NASAViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDailyImage()
    }
    
    init(viewModel: NASAViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

