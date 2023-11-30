//
//  CountOptions.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/11/2023.
//

import Foundation


/// Contains options for fetching commits
@frozen
enum FetchingType: CaseIterable, Codable, CustomStringConvertible {
	case defaultBranch
	case allBranches
	
	var description: String {
		switch self {
		case .defaultBranch:
			I18n.defaultBranch
		case .allBranches:
			I18n.allBranches
		}
	}
}
