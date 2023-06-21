//
//  DebounceViewController.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import Combine

class DebounceViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    
    static let identifier = "DebounceViewController"
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.searchTextField.accessibilityIdentifier = "mySearchBarTextField"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
}

private extension DebounceViewController {
    func configure() {
        navigationItem.title = "디바운스"
        
        setupSearchController()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.isActive = true
    }
    
    func bind() {
        searchController.searchBar.searchTextField
            .myDebounceSearchPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
                guard let self = self else { return }
                print("receivedValue: \(receivedValue)")
                myLabel.text = receivedValue
            }
            .store(in: &subscriptions)
    }
}

extension UISearchTextField {
    var myDebounceSearchPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UISearchTextField }
            .map { $0.text ?? "" }
        
        // delay는 값을 방출하는 시점을 지연시키는 역할, 주로 작업을 일정 시간 동안 지연시키고 타이밍을 조정할 때 사용
//            .delay(for: 2, scheduler: RunLoop.main)
        
        // debounce는  일정 시간 동안 발생하는 중간 값을 제거하여 마지막 값을 방출, 주로 사용자 입력과 같은 빠른 연속적인 이벤트에서 유용하게 사용
            .debounce(for: 1, scheduler: RunLoop.main)
//            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
        
        // 글자가 있을때만 이벤트 전달
            .filter { $0.count > 0 }
            .eraseToAnyPublisher()
    }
}
