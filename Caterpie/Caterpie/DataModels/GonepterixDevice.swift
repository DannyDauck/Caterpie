//
//  GoneptherixDevice.swift
//  Caterpie
//
//  Created by Danny Dauck on 15.03.24.
//

import Foundation

struct GonepterixDevice: Codable{
    
    let id: String
    var currentUser: Employee?
    var batteryState: Float
    var isLoading: String
    var isConnected: Bool
    
}
