//
//  PasswordViewController.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import Combine

class PasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    let viewModel = MyVM()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
}

private extension PasswordViewController {
    func configure() {
        navigationItem.title = "비밀번호 매치"
        let rightBarBtn = UIBarButtonItem(
            title: "디바운스",
            style: .plain,
            target: self,
            action: #selector(didTappedRightBarBtn)
        )
        navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func bind() {
        passwordTextField.myTextPublisher
            .receive(on: DispatchQueue.main)
        // assign 연산자는 View와 ViewModel 사이에서 데이터를 바인딩할 때 유용하게 활용
        // sink 연산자는 데이터의 특정 처리를 위해 사용. 값을 받아와서 클로저에서 원하는 작업을 수행하거나, 값을 변환할 때 사용
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &subscriptions)
        
        passwordConfirmTextField.myTextPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.isMatchPasswordInput
            .print()
            .receive(on: DispatchQueue.main)
            .assign(to: \.isValid, on: confirmBtn)
            .store(in: &subscriptions)
    }
    
    @objc func didTappedRightBarBtn() {
        guard let debounceVC = storyboard?.instantiateViewController(
            withIdentifier: DebounceViewController.identifier
        ) as? DebounceViewController else { return }
        navigationController?.pushViewController(debounceVC, animated: true)
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .systemYellow
        }
        set {
            backgroundColor = newValue ? .systemYellow : .lightGray
            isEnabled = newValue
            let titleColor: UIColor = newValue ? .systemBlue : .white
            setTitleColor(titleColor, for: .normal)
        }
    }
}

extension UITextField {
    var myTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
