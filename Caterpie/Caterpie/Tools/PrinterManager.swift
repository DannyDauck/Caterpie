//
//  AirprintTrial.swift
//  Caterpie
//
//  Created by Danny Dauck on 01.03.24.
//

import Foundation
import Cocoa
import CoreBluetooth


class PrinterManager: ObservableObject {
    
    //building a singleton
    static let shared = PrinterManager()
    @Published var printers: [Printer] = []
    @Published var btPrinters: [BluetoothPrinter] = []
    
    
    private init(){}
    
    
    
    func listPrinters() -> [String]{
        return NSPrinter.printerNames
    }
    
    func addPrinter(_ name: String, completion: @escaping (Bool)->()){
        DispatchQueue.main.async {
            guard let newPrinter = NSPrinter(name: name) else {
                completion(false)
                return
            }
            self.printers.append(Printer(newPrinter))
            completion(true)
        }
    }
    
    func addBTprinter(_ btPrinter: BluetoothPrinter){
        btPrinters.append(btPrinter)
    }
    
    func forceAppendBTprinter(_ peripheral: CBPeripheral){
        let printer = BluetoothPrinter(name: peripheral.name ?? "n.a.", identifier: peripheral.identifier, peripheral: peripheral)
        btPrinters.append(printer)
    }
    
}
