//
//  RepositoryData.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import Foundation

fileprivate enum UserDefaultsKeys: String {
    case username
    case repositoryName
}

class RepositoryData: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.setValue(username, forKey: UserDefaultsKeys.username.rawValue)
        }
    }
    
    @Published var repositoryName: String {
        didSet {
            UserDefaults.standard.setValue(repositoryName, forKey: UserDefaultsKeys.repositoryName.rawValue)
        }
    }
    
    init() {
        if let safeUsername = UserDefaults.standard.string(forKey: UserDefaultsKeys.username.rawValue) {
            username = safeUsername
        } else {
            username = "Admi126n"
        }
        
        if let safeRepositoryName = UserDefaults.standard.string(forKey: UserDefaultsKeys.repositoryName.rawValue) {
            repositoryName = safeRepositoryName
        } else {
            repositoryName = "100DaysOfSwiftUI"
        }
    }
}
