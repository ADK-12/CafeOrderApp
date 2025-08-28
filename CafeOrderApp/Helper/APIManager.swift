//
//  APIManager.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 27/07/25.
//

import Foundation

enum DataError: Error {
    case invalidURL
    case invalidResponse
}

class APIManager {
    
    private init() {}
    
    static let shared = APIManager()
    
    func request<T: Decodable>(
        modalType: T.Type,
        type: EndPointType
    ) async throws -> T {
        guard let url = type.url else {
            throw DataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        if let body = type.body , let headers = type.headers {
            request.httpBody = try JSONEncoder().encode(body)
            request.allHTTPHeaderFields = headers
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              200 ... 299 ~= response.statusCode else {
            throw DataError.invalidResponse
        }
        
        return try JSONDecoder().decode(modalType, from: data)
    }
    
    /*
    func fetchData() async throws -> [Menu] {
        guard let url = URL(string: menuURL) else {
            throw DataError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        return try JSONDecoder().decode([Menu].self, from: data)
    }
    */
}
