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
    
    init() {
        if let safeUsername = UserDefaults(suiteName: suiteName)?.string(forKey: UserDefaultsKeys.username.rawValue) {
            username = safeUsername
        } else {
            username = "Admi126n"
        }
        
        if let safeRepositoryName = UserDefaults(suiteName: suiteName)?.string(forKey: UserDefaultsKeys.mainRepository.rawValue) {
            mainRepository = safeRepositoryName
        } else {
            mainRepository = "100DaysOfSwiftUI"
        }
    }
}
