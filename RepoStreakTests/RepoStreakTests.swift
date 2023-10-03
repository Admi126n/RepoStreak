//
//  RepoStreakTests.swift
//  RepoStreakTests
//
//  Created by Adam Tokarski on 30/09/2023.
//

import XCTest
@testable import RepoStreak

final class RepoStreakTests: XCTestCase {
    func testStreakCounter_WhenValidLinkGiven_ShouldReturnarrayOfCommitsDates() async {
        do {
            let commits: [Date] = try await StreakCounter.getCommitsDates("admi126n", "repostreak")
            XCTAssertTrue(!commits.isEmpty, "Commits list should not be empty")
        } catch {
            XCTFail("An error ocured during getting commits, error description: \(error)")
        }
    }
    
    func testStreakCounter_WhenInvalidRepositoryDataGiven_ShouldThrowAnError() async {
        do {
            _ = try await StreakCounter.getCommitsDates("", "")
            XCTFail("StreakCounter.getCommitsDates should have failed throw an cannotDecodeData error")
        } catch {
            XCTAssertEqual(error as! ValidatorErrors, ValidatorErrors.cannotDecodeData, "Wrong error thrown")
        }
    }
    
    func testStreakCounter_WhenEmptyReposirotyGiven_ShouldThrowAnError() async {
        do {
            _ = try await StreakCounter.getCommitsDates("admi126n", "test")
            XCTFail("StreakCounter.getCommitsDates should have failed throw an cannotDecodeData error")
        } catch {
            XCTAssertEqual(error as! ValidatorErrors, ValidatorErrors.cannotDecodeData, "Wrong error thrown")
        }
    }
    
    func testStreakCounter_WhenExtendedOneDayStreakGiven_ShouldReturnOne() {
        let dates: [Date] = [Date.now]
        
        let (streak, extended) = StreakCounter.countStreak(for: dates)
        
        XCTAssertEqual(streak, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(streak)")
        XCTAssertTrue(extended)
    }
    
    func testStreakCounter_WhenNotExtendedOneDayStreakGiven_ShouldReturnOne() {
        let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!]
        
        let (streak, extended) = StreakCounter.countStreak(for: dates)
        
        XCTAssertEqual(streak, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(streak)")
        XCTAssertFalse(extended)
    }
    
    func testStreakCounter_WhenExtendedFiveDayStreakGiven_ShouldReturnFive() {
        let dates: [Date] = [Date.now,
                             Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!
        ]
        
        let (streak, extended) = StreakCounter.countStreak(for: dates)
        
        XCTAssertEqual(streak, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(streak)")
        XCTAssertTrue(extended)
    }
    
    func testStreakCounter_WhenNotExtendedFiveDayStreakGiven_ShouldReturnFive() {
        let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -5, to: Date.now)!
        ]
        
        let (streak, extended) = StreakCounter.countStreak(for: dates)
        
        XCTAssertEqual(streak, dates.count, "Streak duration should be equal to \(dates.count), but is equal to \(streak)")
        XCTAssertFalse(extended)
    }
    
    func testStreakCounter_WhenNoStreakGiven_ShouldReturnZero() {
        let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -5, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -6, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!,
                             Calendar.current.date(byAdding: .day, value: -8, to: Date.now)!
        ]
        
        let (streak, extended) = StreakCounter.countStreak(for: dates)
        
        XCTAssertEqual(streak, 0, "Streak duration should be equal to \(dates.count), but is equal to \(streak)")
        XCTAssertFalse(extended)
    }
    
}
