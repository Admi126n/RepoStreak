//
//  CommitsFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 28/11/2023.
//

import Foundation

struct CommitsFetcher {
	static func getCommitsDates(_ user: String, _ repo: String, _ compleationHandler: (Error) -> ()) async -> [Date] {
		fatalError("Not implemented")
		return []
	}
	
	private static func getDates(from commits: [CommitData]) -> [Date] {
		fatalError("Not implemented")
		return []
	}
}

// MARK: - Structs needed for decoding fetched data

fileprivate struct CommitData: Codable {
	let commit: Commit
}

fileprivate struct Commit: Codable {
	let author: Author
}

fileprivate struct Author: Codable {
	let date: Date
}
