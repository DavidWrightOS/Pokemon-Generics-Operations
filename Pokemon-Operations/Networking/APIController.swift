//
//  APIController.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class APIController {
	
    // MARK: - Public API
    
    func fetchAllPokemon(completion: @escaping (Result<[PokemonResult], NetworkError>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2")?.appendingPathComponent("pokemon") else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetch(from: url) { (result: Result<PokemonResults, NetworkError>) in
            switch result {
            case .success(let pokemonResults):
                let results = pokemonResults.results
                DispatchQueue.main.async { completion(.success(results)) }
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func fetchPokemon(for url: URL, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        fetch(from: url) { (result: Result<Pokemon, NetworkError>) in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    func fetchImage(for url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        fetch(from: url) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {
                    DispatchQueue.main.async { completion(.failure(.noImage)) }
                    return
                }
                DispatchQueue.main.async { completion(.success(image)) }
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetch<T: Decodable>(from url: URL,
                                     using jsonDecoder: JSONDecoder = JSONDecoder(),
                                     completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard T.self != Data.self else {
                completion(.success(data as! T))
                return
            }
            
            do {
                let decodedObject = try jsonDecoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
