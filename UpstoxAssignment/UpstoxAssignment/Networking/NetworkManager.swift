//
//  NetworkManager.swift
//  Upstox-Assignment
//
//  Created by Vinod Kumar Singh on 09/11/24.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    
    private init(){}
    
    func fetchHoldings(completion: @escaping (Result<[Holding], Error>) -> Void) {
        guard let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data error", code: 0, userInfo: nil)))
                return
            }
                        
            do {
                let decodedResponse = try JSONDecoder().decode(Root.self, from: data)
                let userHoldings = decodedResponse.data.userHolding
                completion(.success(userHoldings))
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}
