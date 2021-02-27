//
//  UserSettings.swift
//  OneTouchLocalisation
//
//  Created by Raj. on 27/02/2021.
//  Copyright © 2020 Raj. All rights reserved.

import Foundation

class UserSettings {
    
    fileprivate let languages = "languages"
    fileprivate let userSelectedSegment = "segment"

    
    fileprivate var userDefaults = UserDefaults.standard
    static let shared = UserSettings()
    
    var languagesSupported: String? {
        get {
            return self.userDefaults.value(forKey: languages) as? String
        }
        set {
            if let newlanguage = newValue {
                self.userDefaults.set(newlanguage, forKey: languages)
            }
        }
    }
    
    var userSegment: Int? {
        get {
            return self.userDefaults.value(forKey: userSelectedSegment) as? Int
        }
        set {
            if let newSegment = newValue {
                self.userDefaults.set(newSegment, forKey: userSelectedSegment)
            }
        }
    }

    func remove() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
