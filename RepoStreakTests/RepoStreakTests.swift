//
//  RepoStreakTests.swift
//  RepoStreakTests
//
//  Created by Adam Tokarski on 30/09/2023.
//

import XCTest
@testable import RepoStreak

final class RepoStreakTests: XCTestCase {
    
    var sut: NewStreakValidator!
    
    override func setUpWithError() throws {
        sut = NewStreakValidator()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testStreakValidator_WhenValidLinkGiven_ShouldReturnarrayOfCommits() async {
        sut.link = "https://api.github.com/repos/admi126n/100daysofswiftui/commits?per_page=100"
        
        do {
            let commits: [CommitData] = try await sut.getCommits()
            XCTAssertTrue(!commits.isEmpty, "Commits list should not be empty")
        } catch {
            XCTFail("An error ocured during getting commits, error description: \(error)")
        }
        
    }
    
    func testStreakValidator_WhenEmptyLinkGiven_ShouldThrowAnError() async {
        sut.link = ""
        
        do {
            _ = try await sut.getCommits()
        } catch {
            XCTAssertEqual(error as! ValidatorErrors, ValidatorErrors.cannotCreateURL)
        }
    }
    
}
