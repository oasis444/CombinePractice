//
//  ApiViewModel.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation
import Combine

final class ApiViewModel {
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchTodos() {
        ApiService.fetchTodos()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { todos in
                print("todos.count: \(todos.count)")
            }
            .store(in: &subscriptions)
    }
    
    func fetchPosts() {
        ApiService.fetchPosts()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { posts in
                print("posts.count: \(posts.count)")
            }
            .store(in: &subscriptions)
    }
    
    func fetchTodosAndPostsAtSameTime() {
        ApiService.fetchTodosAndPostsAtSameTime()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { todos, posts in
                print("todos.count: \(todos.count), posts.count: \(posts.count)")
            }
            .store(in: &subscriptions)
    }
    
    // todos 호출 후 응답으로 posts 호출
    func fetchTodosAndThenPost() {
        ApiService.fetchTodosAndThenPosts()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { posts in
                print("posts.count: \(posts.count)")
            }
            .store(in: &subscriptions)
    }
    
    // todos 호출 후 응답에 따른 조건으로 posts 호출
    func fetchTodosAndPostsConditionally() {
        ApiService.fetchTodosAndPostsConditionally()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { posts in
                print("posts.count: \(posts.count)")
            }
            .store(in: &subscriptions)
    }
    
    // todos 호출 후 응답에 따른 조건으로 다음 api 호출 결정
    func fetchTodosAndApiCallConditionally() {
        let shouldFetchPosts: AnyPublisher<Bool, Error> =
        ApiService.fetchTodos().map { $0.count < 200 }
            .eraseToAnyPublisher()
        
        shouldFetchPosts
            .filter { $0 == true }
            .flatMap { _ in
                return ApiService.fetchPosts()
            }.sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { posts in
                print("posts.count: \(posts.count)")
            }
            .store(in: &subscriptions)
        
        shouldFetchPosts
            .filter { $0 == false }
            .flatMap { _ in
                return ApiService.fetchUsers()
            }.sink { completion in
                switch completion {
                case .failure(let error):
                    print("ApiViewModel_error: \(error.localizedDescription)")
                case .finished:
                    print("finish")
                }
            } receiveValue: { users in
                print("users.count: \(users.count)")
            }
            .store(in: &subscriptions)
    }
}
