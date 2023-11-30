//
//  UserSettings.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import Foundation

fileprivate enum UserDefaultsKeys: String {
    case username
    case mainRepository
	case fetchingType
}

class UserSettings: ObservableObject {
	private let suiteName = "group.com.admi126n.RepoStreak"
	
    @Published var username: String {
        didSet {
			UserDefaults(suiteName: suiteName)?.setValue(username, forKey: UserDefaultsKeys.username.rawValue)
        }
    }
    
    @Published var mainRepository: String {
        didSet {
			UserDefaults(suiteName: suiteName)?.setValue(mainRepository, forKey: UserDefaultsKeys.mainRepository.rawValue)
        }
    }
    
	@Published var fetchingType: FetchingType {
		didSet {
			if let encoded = try? JSONEncoder().encode(fetchingType) {
				UserDefaults(suiteName: suiteName)?.setValue(encoded, forKey: UserDefaultsKeys.fetchingType.rawValue)
			}
		}
	}
	
    init() {
        if let safeUsername = UserDefaults(suiteName: suiteName)?.string(forKey: UserDefaultsKeys.username.rawValue) {
            username = safeUsername
        } else {
            username = "Admi126n"
        }
        
        if let safeRepositoryName = UserDefaults(suiteName: suiteName)?.string(forKey: UserDefaultsKeys.mainRepository.rawValue) {
            mainRepository = safeRepositoryName
        } else {
            mainRepository = "RepoStreak"
        }
		
		if let data = UserDefaults(suiteName: suiteName)?.data(forKey: UserDefaultsKeys.fetchingType.rawValue) {
			if let safeFetchingType = try? JSONDecoder().decode(FetchingType.self, from: data) {
				fetchingType = safeFetchingType
				
				return
			}
		}
		
		fetchingType = .defaultBranch
    }
}
