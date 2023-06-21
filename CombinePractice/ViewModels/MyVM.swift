//
//  MyVM.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation
import Combine

final class MyVM {
    @Published var passwordInput: String = "" {
        didSet {
//            print("MyVM / passwordInput: \(passwordInput)")
        }
    }
    @Published var passwordConfirmInput: String = "" {
        didSet {
//            print("MyVM / passwordConfirmInput: \(passwordInput)")
        }
    }
    
    lazy var isMatchPasswordInput: AnyPublisher<Bool, Never> = Publishers.CombineLatest($passwordInput, $passwordConfirmInput)
        .map { password, passwordConfirm in
            if password == "" || passwordConfirm == "" {
                return false
            }
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
        }
//        .print()
        .eraseToAnyPublisher()
}
