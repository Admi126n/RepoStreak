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
    @Published var username: String {
        didSet {
            UserDefaults.standard.setValue(username, forKey: UserDefaultsKeys.username.rawValue)
        }
    }
    
    @Published var mainRepository: String {
        didSet {
            UserDefaults.standard.setValue(mainRepository, forKey: UserDefaultsKeys.mainRepository.rawValue)
        }
    }
    
    init() {
        if let safeUsername = UserDefaults.standard.string(forKey: UserDefaultsKeys.username.rawValue) {
            username = safeUsername
        } else {
            username = "Admi126n"
        }
        
        if let safeRepositoryName = UserDefaults.standard.string(forKey: UserDefaultsKeys.mainRepository.rawValue) {
            mainRepository = safeRepositoryName
        } else {
            mainRepository = "100DaysOfSwiftUI"
        }
    }
}
