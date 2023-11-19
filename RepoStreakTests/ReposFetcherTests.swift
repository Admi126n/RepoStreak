//
//  ReposFetcherTests.swift
//  RepoStreakTests
//
//  Created by Adam Tokarski on 18/11/2023.
//

import XCTest
@testable import RepoStreak

final class ReposFetcherTests: XCTestCase {
	func testReposFetcher_WhenWrongLinkGiven_ShouldThrowError() async {
		do {
			let result: Int = try await ReposFetcher.fetchData(from: "")
			XCTFail("Result should be empty ant method should throw error but result is equal to \(result).")
		} catch {
			XCTAssertEqual(error as! URLError, URLError(.badURL), "Method thrown wrong error.")
		}
	}
	
	// MARK: - Test has to be run with no internet connection
//	func testReposFetcher_WhenNoInternetConnection_ShouldThrowError() async {
//		do {
//			let result: Int = try await ReposFetcher.fetchData(from: "https://api.github.com/users/Admi126n/repos")
//			XCTFail("Result should be empty ant method should throw error but result is equal to \(result).")
//		} catch {
//			XCTAssertEqual(error as! URLError, URLError(.badServerResponse), "Method thrown wrong error.")
//		}
//	}
	
	func testReposFetcher_WhenTypeToDecodeGiven_ShouldThrowError() async {
		do {
			let result: Int = try await ReposFetcher.fetchData(from: "https://api.github.com/users/Admi126n/repos")
			XCTFail("Result should be empty ant method should throw error but result is equal to \(result).")
		} catch {
			XCTAssertEqual(error as! ValidatorErrors, .cannotDecodeData, "Method thrown wrong error.")
		}
	}
	
	func testReposFetcherGetDates_WhenCommitDataGiven_ShouldReturnDate() {
		let now = Date.now
		let commit = [CommitData(commit: Commit(author: Author(date: now)))]
		
		let result = ReposFetcher.getDates(from: commit)
		
		XCTAssertEqual(result.count, 1, "Method should return one velue")
		XCTAssertEqual(result[0], now, "Returned date is wrong")
	}
	
	func testReposFetcherGetNames_WhenArchivedRepositoryDataGiven_ShouldReturnEmptyArray() {
		let repoName = "Example"
		let repoData = Repository(name: repoName, archived: true)
		
		let result = ReposFetcher.getNames(from: [repoData])
		
		XCTAssertTrue(result.isEmpty, "Result should be empty")
	}
	
}
