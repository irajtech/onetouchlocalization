//
//  String+Ext.swift
//  OneTouchLocalisation
//
//  Created by Raj. on 27/02/2021.
//  Copyright © 2020 Raj. All rights reserved.

import Foundation

extension String {
    func localized(comment: String = "") -> String {

        guard let bundle = Bundle.main.path(forResource: LocalizableLanguage.currentLanguage(), ofType: "lproj") else {
            return NSLocalizedString(self, comment: comment)
        }

        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: comment)
    }
}
