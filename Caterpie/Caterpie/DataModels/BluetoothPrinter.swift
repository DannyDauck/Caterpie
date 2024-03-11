//
//  BluetoothPrinter.swift
//  Caterpie
//
//  Created by Danny Dauck on 03.03.24.
//

import Foundation
import CoreBluetooth

struct BluetoothPrinter{
    
    enum Alignment{
        case left
        case center
        case right
        case undefined
    }
    
    enum FontWeight{
        case normal
        case bold
    }
    
    let name: String
    var displayName: String
    let peripheral: CBPeripheral
    var service: CBUUID?
    var characteristic: CBCharacteristic?
    let identifier: UUID
    var dpi: Int = 100
    
    var printSizeMM: Int = 60
    var hasCutter: Bool = false
    var imagePrinter: Bool = false
    var grayScale: Int = 1
    
    
    var imagePrintCommand: String = ""
    var normalTextCommand: String = "\u{1B}\u{21}\u{00}" //is also the reset to default for standard CLCP und ESC/POS
    var boldTextCommand: String = "\u{1B}\u{21}\u{08}"
    var smallTextCommand: String = "\u{1B}\u{4D}\u{01}"
    var smallTextOffCommand: String = "\u{1B}\u{4D}\u{00}"
    var largeTextCommand: String = "\u{1B}\u{21}\u{30}"
    var leftAlignmentCommand: String = "\u{1B}a0"
    var centerAlignmentCommand: String = "\u{1B}a1"
    var rightAlignmentCommand: String = "\u{1B}a2"
    
    var cutterCommand: String = ""
    var encodingType: String.Encoding = .utf8
    
    
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
    init(name: String, identifier: UUID, peripheral: CBPeripheral){
        self.name = name
        self.displayName = name
        self.service = nil
        self.characteristic = nil
        self.identifier = identifier
        self.peripheral = peripheral
    }
    
    func disconnect(){
        BluetoothManager.shared.disconnectDevice(peripheral)
    }
    
    func connect(){
        BluetoothManager.shared.connectDevice(peripheral)
    }
    
    //I could have handle the text size in one func, but I think it will be better later to have three seperated funcs for
    //small, normal and large
    
    func smallText(_ string: String, _ alignment: Alignment = .undefined, _ fontWeight: FontWeight = .normal){
        guard let char = characteristic else {
            return
        }
        
        var data = Data()
        switch alignment{
        case .left : data.append(leftAlignmentCommand.data(using: encodingType)!)
        case .center : data.append(centerAlignmentCommand.data(using: encodingType)!)
        case .right : data.append(rightAlignmentCommand.data(using: encodingType)!)
        default : data.append(Data())  //appending notihng if undefined, so the preused will be keep
        }
        switch fontWeight{
        case .bold : data.append(boldTextCommand.data(using: encodingType)!)
        default : data.append(Data())
        }
        data.append(smallTextCommand.data(using: encodingType)!)
        data.append(string.data(using: encodingType)!)
        data.append(smallTextOffCommand.data(using: encodingType)!)
        data.append(normalTextCommand.data(using: encodingType)!)
        peripheral.writeValue(data, for: characteristic!, type: .withResponse)
    }
    
    func text(_ string: String, _ alignment: Alignment = .undefined, _ fontWeight: FontWeight = .normal){
        guard let char = characteristic else {
            return
        }
        
        var data = Data()
        switch alignment{
        case .left : data.append(leftAlignmentCommand.data(using: encodingType)!)
        case .center : data.append(centerAlignmentCommand.data(using: encodingType)!)
        case .right : data.append(rightAlignmentCommand.data(using: encodingType)!)
        default : data.append(Data())  //appending notihng if undefined, so the preused will be keep
        }
        switch fontWeight{
        case .bold : data.append(boldTextCommand.data(using: encodingType)!)
        default : data.append(normalTextCommand.data(using: encodingType)!)
        }
        data.append(string.data(using: encodingType)!)
        data.append(normalTextCommand.data(using: encodingType)!)
        peripheral.writeValue(data, for: characteristic!, type: .withResponse)
    }
    
    func largeText(_ string: String, _ alignment: Alignment = .undefined, _ fontWeight: FontWeight = .normal){
        guard let char = characteristic else {
            return
        }
        
        var data = Data()
        switch alignment{
        case .left : data.append(leftAlignmentCommand.data(using: encodingType)!)
        case .center : data.append(centerAlignmentCommand.data(using: encodingType)!)
        case .right : data.append(rightAlignmentCommand.data(using: encodingType)!)
        default : data.append(Data())  //appending notihng if undefined, so the preused will be keep
        }
        switch fontWeight{
        case .bold : data.append(boldTextCommand.data(using: encodingType)!)
        default : data.append(Data())
        }
        data.append(largeTextCommand.data(using: encodingType)!)
        data.append(string.data(using: encodingType)!)
        data.append(normalTextCommand.data(using: encodingType)!)
        peripheral.writeValue(data, for: characteristic!, type: .withResponse)
    }
    
}
