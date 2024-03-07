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
    var displayName: String
    let peripheral: CBPeripheral
    var service: CBUUID
    var characteristic: CBCharacteristic
    let identifier: UUID
    
    var printSizeMM: Int = 60
    var hasCutter: Bool = false
    
    var imagePrint: String = ""
    var textPrint: String = ""
    var cutterCommand: String = ""
    
    enum State{
        case connected
        case connecting
        case disconnected
        case disconnecting
    }
    
    init(name: String, service: CBUUID, characteristic: CBCharacteristic, identifier: UUID, peripheral: CBPeripheral) {
            self.name = name
            self.displayName = name
            self.service = service
            self.characteristic = characteristic
            self.identifier = identifier
            self.peripheral = peripheral
        }
    
    func disconnect(){
        BluetoothManager.shared.disconnectDevice(peripheral)
    }
    
    func connect(){
        BluetoothManager.shared.connectDevice(peripheral)
    }
}


