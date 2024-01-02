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
	
	private init(name: String, duration: Int, extended: Bool, reposList: [RepoData]) {
		self.mainRepoName = name
		self.mainDuration = duration
		self.mainExtended = extended
		self.reposList = reposList
	}
	
	static let example = RepositoriesData(name: "Example",
										  duration: 10,
										  extended: true,
										  reposList: [RepoData(name: "Example 1", duration: 1, extended: true),
													  RepoData(name: "Example 2", duration: 4, extended: false),
													  RepoData(name: "Example 3", duration: 4, extended: false),
													  RepoData(name: "Example 4", duration: 4, extended: true),
													  RepoData(name: "Example 5", duration: 4, extended: false),
													  RepoData(name: "Example 6", duration: 4, extended: true)]
	)
}

struct RepoData {
	var name: String
	var duration: Int
	var extended: Bool
}

/// Contains methods for counting commits streak for specified user.
struct StreakCounter {
	
	/// Empty private init to prevent creating instances of this struct
	///
	/// StreakCounter contains only static methods so instances are unnecessary.
	private init() { }
	
	
	/// Reduces given `array` so that result contains one element per day
	/// - Parameter array: Array of dates
	/// - Returns: Reduced array of dates with unique days, sorted from oldest to newest
	///
	/// Example:
	/// Given array contains values:
	/// ```swift
	/// [2023-11-27, 2023-11-27, 2023-11-28, 2023-11-29]
	/// ```
	/// Returned value will contain only values: 
	/// ```swift
	/// [2023-11-27, 2023-11-28, 2023-11-29]
	/// ```
	private static func reduce(dates array: [Date]) -> [Date] {
		guard array.count > 1 else { return array }
		
		var copy = Array(array.sorted().reversed())
		var result: [Date] = [copy.remove(at: 0)]
		
		for date in copy {
			guard !Calendar.current.isDate(result.last!, equalTo: date, toGranularity: .day) else { continue }
			
			result.append(date)
		}
		
		return result
	}
	
	/// Checks if two dates are from the same day
	/// - Parameters:
	///   - arg1: First date
	///   - arg2: Second date
	///   - days: Int with number of days which should be added to the `arg2` before comprasion. Default set to `0`
	/// - Returns: True if provided dates are from the same day
	private static func isDate(_ arg1: Date, theSameDayAs arg2: Date, withMargin days: Int = 0) -> Bool {
		return Calendar.current.isDate(arg1, inSameDayAs: Calendar.current.date(byAdding: .day, value: days, to: arg2)!)
	}
	
	
	/// Counts streak for provided dates array
	/// - Parameter commits: Array of dates
	/// - Returns: Int with streak duration and Bool value with info if streak is extended already
	///
	/// If the newest date from `commits` array is from today streak is extended, otherwise is not
	///
	/// If there are no commits returns `(0, false)`
	static func countStreak(for commits: [Date]) -> (streak: Int, extended: Bool) {
		var commitsDates = reduce(dates: commits)
		
		guard commitsDates.count > 0 else { return (0, false) }
		
		var tempDay = Date.now
		var streakDuration = 0
		var streakExtended = false
		
		// Check first day
		if isDate(commitsDates[0], theSameDayAs: tempDay) {
			streakDuration += 1
			commitsDates.remove(at: 0)
			streakExtended = true
			
		} else if isDate(commitsDates[0], theSameDayAs: tempDay, withMargin: -1) {
			streakDuration += 1
			commitsDates.remove(at: 0)
			tempDay = Calendar.current.date(byAdding: .day, value: -1, to: tempDay)!
		}
		
		guard streakDuration != 0 else { return (0, false) }
		
		// Check rest of the days
		for commit in commitsDates {
			if isDate(commit, theSameDayAs: tempDay, withMargin: -1) {
				streakDuration += 1
				tempDay = Calendar.current.date(byAdding: .day, value: -1, to: tempDay)!
				
			} else { break }
		}
		
		return (streakDuration, streakExtended)
	}
	
	
	/// Gets array of commits creation dates for all available branches from specified repository
	/// - Parameters:
	///   - user: String with GitHub username
	///   - repo: String with GitHub repository name
	/// - Returns: Array of commits creation dates
	private static func getCommitsForAllBranches(for user: String, _ repo: String) async -> [Date] {
		let fetchedBranches = await BranchesFetcher.getBranchesNames(for: user, repo)
		var datesFromAllBranches: [Date] = []
		
		guard let branchesNames = try? fetchedBranches.get() else { return [] }
		
		for branch in branchesNames {
			let fetchedCommitsDates = await CommitsFetcher.getCommitsDates(user, repo, branch)
			guard let commitsDates = try? fetchedCommitsDates.get() else { continue }
			
			datesFromAllBranches += commitsDates
		}
		
		return datesFromAllBranches.sorted().reversed()
	}
	
	
	/// Checks commits streaks for all public repositories for provided user
	/// - Parameters:
	///   - user: String with GitHub username
	/// - Returns: Information about streak for all repositories
	///
	/// Returned value contains information about main repository and list of information about remaining repositories
	static func checkStreak(for user: String) async -> RepositoriesData {
		var reposData = RepositoriesData()
		var reposList: [RepoData] = []
		let fetchedRepos = await ReposFetcher.getPublicActiveRepositoriesNames(for: user)
		guard let reposNames = try? fetchedRepos.get() else { return reposData }
		
		for repo in reposNames {
			var commitsDates: [Date] = []
			
			switch UserSettings().fetchingType {
			case .defaultBranch:
				let fetchedData = await CommitsFetcher.getCommitsDates(user, repo)
				
				switch fetchedData {
				case .success(let success):
					commitsDates = success
				case .failure(_):
					continue
				}
			case .allBranches:
				commitsDates = await getCommitsForAllBranches(for: user, repo)
			}
			
			let (duration, extended) = countStreak(for: commitsDates)
			
			if repo == UserSettings().mainRepository {
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
