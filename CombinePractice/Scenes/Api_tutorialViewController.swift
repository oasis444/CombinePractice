//
//  Api_tutorialViewController.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit
import Combine

class Api_tutorialViewController: UIViewController {
    
    static let identifier: String = "Api_tutorialViewController"
    let viewModel = ApiViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func fetchTodos(_ sender: UIButton) {
        viewModel.fetchTodos()
    }
    
    @IBAction func fetchPosts(_ sender: UIButton) {
        viewModel.fetchPosts()
    }
    
    @IBAction func fetchTodosAndPosts(_ sender: UIButton) {
        viewModel.fetchTodosAndPostsAtSameTime()
    }
    
    @IBAction func fetchTodosAndThenPost(_ sender: UIButton) {
        viewModel.fetchTodosAndThenPost()
    }
    
    @IBAction func fetchTodosAndPostConditionally(_ sender: UIButton) {
        viewModel.fetchTodosAndPostsConditionally()
    }
    
    @IBAction func fetchTodosAndApiCallConditionally(_ sender: UIButton) {
        viewModel.fetchTodosAndApiCallConditionally()
    }
}

private extension Api_tutorialViewController {
    func configure() {
        navigationItem.title = "연쇄 호출"
    }
}
