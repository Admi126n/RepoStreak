//
//  ValidatorErrors.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import Foundation

enum ValidatorErrors: Error {
    case cannotCreateURLSession
    case cannotDecodeData
    case cannotGetURL
}
