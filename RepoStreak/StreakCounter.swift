//
//  StreakCounter.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import Foundation

struct StreakCounter {
	static func countStreak(for commits: [Date]) -> (streak: Int, extended: Bool) {
		var commitsList = commits
		
		let today = Date.now
		var subtractingDays = 0
		var streakDuration = 0
		var streakExtended = false
		
		if Calendar.current.isDate(commitsList[0], equalTo: today, toGranularity: .day) {
			streakDuration += 1
			subtractingDays -= 1
			streakExtended = true
			commitsList.remove(at: 0)
		} else if Calendar.current.isDate(
			commitsList[0],
			equalTo: Calendar.current.date(byAdding: .day, value: -1, to: today)!,
			toGranularity: .day) {
			
			streakDuration += 1
			subtractingDays -= 2
			commitsList.remove(at: 0)
		}
		
		guard streakDuration != 0 else {
			return (0, false)
		}
		
		for commit in commitsList {
			if Calendar.current.isDate(
				commit,
				equalTo: Calendar.current.date(byAdding: .day, value: subtractingDays, to: today)!,
				toGranularity: .day) {
				
				subtractingDays -= 1
				streakDuration += 1
				
			} else {
				return (streakDuration, streakExtended)
			}
		}
		
		return (streakDuration, streakExtended)
	}
	
	static func checkStreak(user: String, repo: String) async -> (streak: Int, extended: Bool) {
		
		let commitsDates = await ReposFetcher.getCommitsDates(user, repo) { 
			fatalError("Compleation handler not implememnted")
		}
			
		return countStreak(for: commitsDates)
	}
	
	static func checkStreakForReposList(user: String, mainRepo: String) async -> [(name: String, duration: Int, pushedToday: Bool)] {
		var result: [(name: String, duration: Int, pushedToday: Bool)] = []
		var reposList = await ReposFetcher.getRepositories(for: user) { 
			fatalError("Compleation handler not implememnted")
		}
		
		if let index = reposList.firstIndex(of: mainRepo) {
			reposList.remove(at: index)
		}
		
		for repo in reposList {
			let commitsDates = await ReposFetcher.getCommitsDates(user, repo) { 
				fatalError("Compleation handler not implememnted")
			}
			let (duration, extended) = countStreak(for: commitsDates)
			result.append((name: repo, duration: duration, pushedToday: extended))
		}
		
		return result
	}
	
}
