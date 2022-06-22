//
//  UserData.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 22.06.2022.
//

import Foundation

class UserData {
    
    private var userDefaults = UserDefaults.standard
 
    private let isSavedCamersDataKey = "savedCamersDataKey"
    private let isSavedDoorsDataKey = "savedDoorsDataKey"
        
    var isSavedCamersData: Bool {
        userDefaults.value(forKey: isSavedCamersDataKey) as? Bool ?? false
    }
    
    var isSavedDoorsData: Bool {
        userDefaults.value(forKey: isSavedDoorsDataKey) as? Bool ?? false
    }
    
    func setSavedCamersData(_ isSaved: Bool) {
        userDefaults.setValue(isSaved, forKey: isSavedCamersDataKey)
    }
    
    func setSavedDoorsData(_ isSaved: Bool) {
        userDefaults.setValue(isSaved, forKey: isSavedDoorsDataKey)
    }
}
