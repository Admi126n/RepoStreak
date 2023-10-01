//
//  RepoStreakTests.swift
//  RepoStreakTests
//
//  Created by Adam Tokarski on 30/09/2023.
//

import XCTest
@testable import RepoStreak

final class RepoStreakTests: XCTestCase {
    func testStreakValidator_WhenValidLinkGiven_ShouldReturnarrayOfCommitsDates() async {
        do {
            let commits: [Date] = try await NewStreakValidator.getCommitsDates("admi126n", "repostreak")
            XCTAssertTrue(!commits.isEmpty, "Commits list should not be empty")
        } catch {
            XCTFail("An error ocured during getting commits, error description: \(error)")
        }
    }
    
    func testStreakValidator_WhenInvalidRepositoryDataGiven_ShouldThrowAnError() async {
        do {
            _ = try await NewStreakValidator.getCommitsDates("", "")
        } catch {
            XCTAssertEqual(error as! ValidatorErrors, ValidatorErrors.cannotDecodeData, "Wrong error thrown")
        }
    }
    
    func testStreakValidator_WhenEmptyReposirotyGiven_ShouldThrowAnError() async {
        do {
            _ = try await NewStreakValidator.getCommitsDates("admi126n", "test")
        } catch {
            XCTAssertEqual(error as! ValidatorErrors, ValidatorErrors.cannotDecodeData, "Wrong error thrown")
        }
    }
    
    func testStreakValidator_WhenExtendedOneDayStreakGiven_ShouldReturnOne() {
        let dates: [Date] = [Date.now]
        
        let result = NewStreakValidator.countStreak(for: dates)
        
        XCTAssertEqual(result, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(result)")
    }
    
    func testStreakValidator_WhenNotExtendedOneDayStreakGiven_ShouldReturnOne() {
        let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!]
        
        let result = NewStreakValidator.countStreak(for: dates)
        
        XCTAssertEqual(result, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(result)")
    }
    
    func testStreakValidator_WhenExtendedFiveDayStreakGiven_ShouldReturnFive() {
        let dates: [Date] = [Date.now,
                             Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!
        ]
        
        let result = NewStreakValidator.countStreak(for: dates)
        
        XCTAssertEqual(result, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(result)")
    }
    
    func testStreakValidator_WhenNotExtendedFiveDayStreakGiven_ShouldReturnFive() {
        let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -5, to: Date.now)!
        ]
        
        let result = NewStreakValidator.countStreak(for: dates)
        
        XCTAssertEqual(result, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(result)")
    }
    
    func testStreakValidator_WhenNoStreakGiven_ShouldReturnZero() {
        let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -5, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -6, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -8, to: Date.now)!
        ]
        
        let result = NewStreakValidator.countStreak(for: dates)
        
        XCTAssertEqual(result, 0, "Streak duration should be equal to \(dates.count), but is equal to \(result)")
    }
    
}
