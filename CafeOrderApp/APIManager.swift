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
    func fetchData() async throws -> Menu {
        guard let url = URL(string: "https://adk-12.github.io/Food-Menu_API/menu.json") else {
            throw DataError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        return try JSONDecoder().decode(Menu.self, from: data)
    }
}
