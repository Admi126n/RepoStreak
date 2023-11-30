//
//  URL+fetchData.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 28/11/2023.
//

import Foundation

extension URL {
	
	/// Fetches data from self URL
	/// - Parameter decoder: Custom JSONDecoder
	/// - Returns: Decoded data of given type fetched from self URL
	func fetchData<T: Codable>(using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
		guard let (data, _) = try? await URLSession.shared.data(from: self) else {
			throw URLError(.badServerResponse)
		}
		
		guard let decodedData = try? decoder.decode(T.self, from: data) else {
			throw ValidatorErrors.cannotDecodeData
		}
		
		return decodedData
	}
}
