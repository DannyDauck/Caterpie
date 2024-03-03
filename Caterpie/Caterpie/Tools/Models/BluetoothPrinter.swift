//
//  BluetoothPrinter.swift
//  Caterpie
//
//  Created by Danny Dauck on 03.03.24.
//

import Foundation
import CoreBluetooth

struct BluetoothPrinter{
    
    let name: String
    let service: CBUUID
    let characteristic: CBUUID
    let identifier: UUID
    
    enum State{
        case connected
        case connecting
        case disconnected
        case disconnecting
    }
    
    var state: State = .disconnected
    
    mutating func setState(_ stateIn: State){
        self.state = stateIn
    }
    
    
}


private extension CBPeripheral {
    var printerState: BluetoothPrinter.State {
        switch state {
        case .disconnected:
            return .disconnected
        case .connected:
            return .connected
        case .connecting:
            return .connecting
        case .disconnecting:
            return .disconnecting
        @unknown default:
            return .disconnected
        }
    }
}
