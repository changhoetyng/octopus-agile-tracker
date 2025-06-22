//
//  RateService.swift
//  OctopusTracker
//
//  Created by Hoe Tyng Chang on 20/06/2025.
//

import Foundation

class RateService {
    static let shared = RateService()
    
    func fetchAgileRates(completion: @escaping (Result<UnitRatesResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.octopus.energy/v1/products/AGILE-24-10-01/electricity-tariffs/E-1R-AGILE-24-10-01-A/standard-unit-rates") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
         request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let rates = try decoder.decode(UnitRatesResponse.self, from: data)
                completion(.success(rates))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}

