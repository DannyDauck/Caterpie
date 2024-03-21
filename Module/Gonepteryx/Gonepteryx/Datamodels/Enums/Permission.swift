//
//  Permission.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation

enum Permission: String, Codable, CaseIterable, Hashable{
    
    case settings, peripheralSettings, themeSettings, analyze
    
}
