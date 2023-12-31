//
//  RepoStreakTests.swift
//  RepoStreakTests
//
//  Created by Adam Tokarski on 30/09/2023.
//

import XCTest
@testable import RepoStreak

final class StreakCounterTests: XCTestCase {    
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
	
	func testStreakCounter_WhenExtendedFiveDaysStreakWithMoreThanOneCommitPerDayGiven_ShouldReturnFive() {
		let dates: [Date] = [.now,
							 .now,
							 Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!
		]
		
		let (streak, extended) = StreakCounter.countStreak(for: dates)
		
		XCTAssertEqual(streak, 5, "Streak duration should be equal to 2, but is equal to \(streak)")
		XCTAssertTrue(extended)
	}

	func testStreakCounter_WhenNotExtendedTwoDaysStreakWithMoreThanOneCommitPerDayGiven_ShouldReturnTwo() {
		let dates: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -2, to: Date.now)!
		]
		
		let (streak, extended) = StreakCounter.countStreak(for: dates)
		
		XCTAssertEqual(streak, 2, "Streak duration should be equal to 2, but is equal to \(streak)")
		XCTAssertFalse(extended)
	}
	
	func testStreakCounter_WhenNotExtendedRandomDaysGiven_ShouldReturnOne() {
		let dates: [Date] = [.now,
							 Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -4, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -6, to: Date.now)!,
							 Calendar.current.date(byAdding: .day, value: -9, to: Date.now)!
		]
		
		let (streak, extended) = StreakCounter.countStreak(for: dates)
		
		XCTAssertEqual(streak, 1, "Streak duration should be equal to 1, but is equal to \(streak)")
		XCTAssertTrue(extended)
	}
	
}
