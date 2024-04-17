//
//  GonepteryxDevice.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation
import UIKit

struct GonepterixDevice: Codable{
    
    let id: String
    var currentUser: Employee?
    var batteryState: Float
    var isLoading: String
    var isConnected: Bool
    
    init(){
        id = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        currentUser = nil
        batteryState = UIDevice.current.batteryLevel
        isLoading = batteryStateString()
        isConnected = true
    }
}


func batteryStateString() -> String {
    switch UIDevice.current.batteryState {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        @unknown default:
            return "Unknown"
        }
    }

