//
//  LocalizationManager.swift
//  OneTouchLocalisation
//
//  Created by Raj. on 27/02/2021.
//  Copyright © 2020 Raj. All rights reserved.


import Foundation
import UIKit

/// Resets bundles
public protocol ViewResetable {
    func reset()
}

// MARK: - LocalizationManager
open class LocalizationManager {
    public static let shared = LocalizationManager()
    
    /// Which bundle to fallback to if the current language has no bundle
    open var fallbackLocale = "Base"
    
    fileprivate init() {}
    
    /// Sets the language with the provided two letter language identifier e.x. en, nl, fr ...
    ///
    /// User must call the reset function after this in order for changes to take effect
    open class func setLanguageTo(_ language: String) {
        guard LocalizableLanguage.currentLanguage() != language else { return }
        
        LocalizableLanguage.setLanguageTo(language)
        self.reset()
    }
    
    /// Calls reset on AppDelegate or SceneDelegate to trigger the reset of the app with a custom
    /// transition and duration if provided
    open class func reset(transition: UIView.AnimationOptions = .transitionFlipFromRight, duration: Float = 0.5) {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                (scene.delegate as? ViewResetable)?.reset()
            }
        } else {
            if let delegate = UIApplication.shared.delegate,
                let _ = delegate.window,
                let localizableDelegate = delegate as? ViewResetable {
                localizableDelegate.reset()
            }
        }
    }

}

// MARK: - LocalizableLanguage

 internal class LocalizableLanguage {
    
    static let shared = LocalizableLanguage()

    class func currentLanguage() -> String {
        return UserSettings.shared.languagesSupported ?? "en"
    }

    /// Sets the active language by moving it to the first index of the languagesSupported array
    class func setLanguageTo(_ language: String) {
        UserSettings.shared.languagesSupported = language
    }

}
