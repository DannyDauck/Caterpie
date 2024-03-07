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
    let characteristic: CBCharacteristic
    let identifier: UUID
    
    enum State{
        case connected
        case connecting
        case disconnected
        case disconnecting
    }
    
    let peripheral: CBPeripheral
    
    var state: State{
        BluetoothManager.shared.connectedDevices.contains(peripheral) ? .connected : .disconnected
    }
    
    init(name: String, service: CBUUID, characteristic: CBCharacteristic, identifier: UUID, peripheral: CBPeripheral) {
            self.name = name
            self.service = service
            self.characteristic = characteristic
            self.identifier = identifier
            self.peripheral = peripheral
        }
    
    func disconnect(){
        BluetoothManager.shared.disconnectDevice(peripheral)
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



