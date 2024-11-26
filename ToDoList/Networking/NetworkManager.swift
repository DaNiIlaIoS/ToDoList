//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getTodos(completion: @escaping (Result<[ApiTask], Error>) -> ())
}

final class NetworkManager: NetworkManagerProtocol {
    func getTodos(completion: @escaping (Result<[ApiTask], Error>) -> ()) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        components.path = "/todos"
        
        guard let url = components.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let model = try JSONDecoder().decode(Todos.self, from: data)
                    completion(.success(model.todos))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
