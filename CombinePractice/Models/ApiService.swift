//
//  ApiService.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation
import Alamofire
import Combine

enum API {
    case fetchTodos // 할 일 가져오기
    case fetchPosts // 포스트 가져오기
    case fetchUsers // 유저 가져오기
    
    var url: URL {
        switch self {
        case .fetchTodos:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")!
        case .fetchPosts:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .fetchUsers:
            return URL(string: "https://jsonplaceholder.typicode.com/users")!
        }
    }
}

enum ApiService {
    static func fetchTodos() -> AnyPublisher<[Todo], Error> {
        print("fetchTodos")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
//            .map { $0.data }
//            .decode(type: [Todo].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        
        // Alamofire 사용
        return AF.request(API.fetchTodos.url)
            .publishDecodable(type: [Todo].self)
            .value()
            .mapError { afError in
                return afError as Error
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchPosts(todosCount: Int = 0) -> AnyPublisher<[Post], Error> {
        print("fetchPosts_todos.count: \(todosCount)")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchPosts.url)
//            .map { $0.data }
//            .decode(type: [Post].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        
        // Alamofire 사용
        return AF.request(API.fetchPosts.url)
            .publishDecodable(type: [Post].self)
            .value()
            .mapError { afError in
                return afError as Error
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchUsers() -> AnyPublisher<[User], Error> {
        print("fetchUsers")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchUsers.url)
//            .map { $0.data }
//            .decode(type: [User].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        
        // Alamofire 사용
        return AF.request(API.fetchUsers.url)
            .publishDecodable(type: [User].self)
            .value()
            .mapError { afError in
                return afError as Error
            }
            .eraseToAnyPublisher()
    }
    
    /// Todos + Posts 동시 호출
    static func fetchTodosAndPostsAtSameTime() -> AnyPublisher<([Todo], [Post]), Error> {
        let fetchedTodos = fetchTodos()
        let fetchedPosts = fetchPosts()
        
        return Publishers.CombineLatest(fetchedTodos, fetchedPosts)
            .eraseToAnyPublisher()
    }
    
    /// Todos 호출 뒤 그 결과로 Posts 호출하기 (연쇄 호출)
    static func fetchTodosAndThenPosts() -> AnyPublisher<[Post], Error> {
        fetchTodos().flatMap { todos in
            return fetchPosts(todosCount: todos.count).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    /// Todos 호출 뒤 그 결과로 특정 조건이 성립되면 Posts 호출하기 (조건 + 연쇄 호출)
    static func fetchTodosAndPostsConditionally() -> AnyPublisher<[Post], Error> {
        return fetchTodos()
            .map { $0.count }
            .filter { $0 >= 200 }
            .flatMap { todosCount in
                return fetchPosts(todosCount: todosCount).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
