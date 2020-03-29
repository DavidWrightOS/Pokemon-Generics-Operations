//
//  PokemonResult.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import Foundation

struct PokemonResults: Codable {
	let results: [PokemonResult]
}

struct PokemonResult: Codable {
	let name: String
	let url: URL
}
