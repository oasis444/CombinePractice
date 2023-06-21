//
//  DebounceViewController.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class DebounceViewController: UIViewController {
    
    static let identifier = "DebounceViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

private extension DebounceViewController {
    func configure() {
        navigationItem.title = "디바운스"
    }
}
