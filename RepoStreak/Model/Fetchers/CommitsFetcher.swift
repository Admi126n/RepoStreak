//
//  CommitsFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 28/11/2023.
//

import Foundation

/// Contains methods for fetching list of creation dates of commits from public repositories for specified user.
struct CommitsFetcher {
	
	/// Empty private init to prevent creating instances of this struct
	///
	/// CommitsFetcher contains only static methods so instances are unnecessary.
	private init() { }
	
	
	/// Creates URL for GitHub API request
	/// - Parameter user: String with GitHub username
	/// - Parameter repo: String with GitHub repository name
	/// - Parameter sha: Optional String with sha parameter
	/// - Returns: URL for GitHub API request
	/// 
	/// Method uses GitHub API for fething commits for the specified user and repository.
	///
	/// The `sha` parameter is used to specify branch from which commits should be fetched.
	/// If nil commits are fetched from the main branch
	///
	/// API documentation:
	/// https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-commits
	private static func buildLink(for user: String, _ repo: String, _ sha: String?) throws -> URL {
		var urlString = "https://api.github.com/repos/\(user)/\(repo)/commits?per_page=100"
		
		if let sha = sha {
			urlString += "&sha=\(sha)"
		}
		
		guard let url = URL(string: urlString) else {
			throw(URLError(.badURL))
		}
		
		return url
	}
	
	
	/// Returnes list of creation dates of provided commits
	/// - Parameter commits: Commit data
	/// - Returns: List of dates
	private static func getDates(from commits: [CommitData]) -> [Date] {
		commits.map { $0.commit.author.date }
	}
	
	
	/// Gets first 100 commits for provided `user`, `repo` and `branch`. Returns list of commits data or error if API request fails
	/// - Parameters:
	///   - user: String with GitHub username
	///   - repo: String with GitHub repository name
	///   - branch: Optional string with branch name
	/// - Returns: Commit data if request succeeds, otherwise error
	private static func getCommits(for user: String, _ repo: String, _ branch: String?) async -> Result<[CommitData], Error> {
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		do {
			let url = try buildLink(for: user, repo, branch)
			let fetchedData: [CommitData] = try await url.fetchData(using: decoder)
			
			return .success(fetchedData)
		} catch {
			return .failure(error)
		}
	}
	
	
	/// Returns creation dates of commits for provided user and repository
	/// - Parameters:
	///   - user: String with GitHub username
	///   - repo: String with GitHub repository name
	///   - branch: String with GitHub branch name
	/// - Returns: List of commits creation dates if request succeeds, otherwise error
	static func getCommitsDates(_ user: String, _ repo: String, _ branch: String? = nil) async ->  Result<[Date], Error> {
		let fetchedData = await getCommits(for: user, repo, branch)
		
		switch fetchedData {
		case .success(let success):
			return .success(getDates(from: success))
		case .failure(let failure):
			return .failure(failure)
		}
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
