//
//  Permission.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import Foundation

enum Permission: String, Codable, CaseIterable, Hashable{
    
    case settings, peripheralSettings, themeSettings, analyze
    
}
