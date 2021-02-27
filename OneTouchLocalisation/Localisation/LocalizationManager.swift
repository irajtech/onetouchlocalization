import Foundation
import UIKit

/// Resets bundles
public protocol ViewResetable {
    func reset()
}

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
        reset()
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
    
    /// Activates method swizzling for the current bundle in order to pick up the correct localized strings
    /// This is required for changing the language without quitting the app
    open func activate() {
        swizzle(class: Bundle.self, sel: #selector(Bundle.localizedString(forKey:value:table:)), override: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
    }
}

extension Bundle {
    /// Accesses the localized string for the current selected language set in the LocalizableLanguage class
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        
        // Checks first if the language is available, otherwise, falls back to the base version
        let translate =  { (tableName: String?) -> String in
            var localizedBundle = Bundle()

            if let _path = Bundle.main.path(forResource: LocalizableLanguage.currentLanguage(), ofType: "lproj"),
                let bundle = Bundle(path: _path) {
                localizedBundle = bundle
            } else if let _path = Bundle.main.path(forResource: LocalizationManager.shared.fallbackLocale, ofType: "lproj"),
                let bundle = Bundle(path: _path) {
                localizedBundle = bundle
            }
            return (localizedBundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        }

        if self == Bundle.main {
            return translate(tableName)
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}


// MARK: - Utility
/// Exchanges the runtime execution of a method (sel) in a class (cls) with another method (override)
private func swizzle(class cls: AnyClass, sel: Selector, override: Selector) {
    guard let origMethod: Method = class_getInstanceMethod(cls, sel) else { return }
    guard let overrideMethod: Method = class_getInstanceMethod(cls, override) else { return }
    if (class_addMethod(cls, sel, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, override, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

// MARK: - LocalizableLanguage

  class LocalizableLanguage {
    
    static let shared = LocalizableLanguage()

    class func currentLanguage() -> String {
        return preferredLanguages.first ?? ""
    }

    /// Sets the active language by moving it to the first index of the languagesSupported array
    class func setLanguageTo(_ lang: String) {
        UserSettings.shared.languagesSupported = [lang, currentLanguage()]
    }

    private static var preferredLanguages: [String] {
        if let langArray = UserSettings.shared.languagesSupported {
            return langArray
        } else {
            return []
        }
    }
}
