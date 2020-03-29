//
//  NetworkError.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import Foundation

enum NetworkError: Error {
	case invalidURL
	case unableToComplete
	case invalidResponse
	case noData
	case decodeError
	case noImage
}
