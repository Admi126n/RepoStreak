//
//  StreakCounter.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import Foundation

struct RepositoriesData {
	var mainRepoName: String
	var mainDuration: Int
	var mainExtended: Bool
	
	var reposList: [RepoData]?
	
	init() {
		self.mainRepoName = ""
		self.mainDuration = 0
		self.mainExtended = false
	}
}

struct RepoData {
	var name: String
	var duration: Int
	var extended: Bool
}

struct StreakCounter {
	private static func countStreak(for commits: [Date]) -> (streak: Int, extended: Bool) {
		var commitsList = commits
		
		var tempDay = Date.now
		var streakDuration = 0
		var streakExtended = false
		
		if Calendar.current.isDate(commitsList[0], equalTo: tempDay, toGranularity: .day) {
			streakDuration += 1
			streakExtended = true
			commitsList.remove(at: 0)
		} 
		else if Calendar.current.isDate(
			commitsList[0],
			equalTo: Calendar.current.date(byAdding: .day, value: -1, to: tempDay)!,
			toGranularity: .day) {
			
			streakDuration += 1
			tempDay = Calendar.current.date(byAdding: .day, value: -1, to: tempDay)!
			commitsList.remove(at: 0)
		}
		
		guard streakDuration != 0 else {
			return (0, false)
		}
		
		for commit in commitsList {
			if Calendar.current.isDate(
				commit,
				equalTo: tempDay,
				toGranularity: .day) {
				
				continue
				
			} else if Calendar.current.isDate(
				commit,
				equalTo: Calendar.current.date(byAdding: .day, value: -1, to: tempDay)!,
				toGranularity: .day) {
				
				tempDay = Calendar.current.date(byAdding: .day, value: -1, to: tempDay)!
				streakDuration += 1
				
			} else {
				return (streakDuration, streakExtended)
			}
		}
		
		return (streakDuration, streakExtended)
	}
	
	static func checkStreakForReposList(user: String, mainRepo: String, _ compleationHandler: (Error) -> ()) async -> RepositoriesData {
		var reposData = RepositoriesData()
		
		var reposList: [RepoData] = []
		let fetchedRepos = await ReposFetcher.getRepositories(for: user) { error in
			compleationHandler(error)
		}
		
		for repo in fetchedRepos {
			let commitsDates = await ReposFetcher.getCommitsDates(user, repo) { error in
				compleationHandler(error)
			}
			
			let (duration, extended) = countStreak(for: commitsDates)
			
			if repo == mainRepo {
				reposData.mainRepoName = repo
				reposData.mainDuration = duration
				reposData.mainExtended = extended
			} else {
				reposList.append(RepoData(name: repo, duration: duration, extended: extended))
			}
		}
		
		reposData.reposList = reposList
		return reposData
	}
}
