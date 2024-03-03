//
//  BluetoothManager.swift
//  Caterpie
//
//  Created by Danny Dauck on 01.03.24.
//
//   https://github.com/KevinGong2013/Printer/blob/refactor/Sources/Printer/Hardware/Bluetooth/BluetoothPeripheralDelegate.swift


import Cocoa
import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    static var shared = BluetoothManager()
    private var centralManager: CBCentralManager!
    private var imageCharacteristic: CBCharacteristic?
    
    @Published var availableDevices: [CBPeripheral] = []
    @Published var connectedDevices: [CBPeripheral] = []
    @Published var availablePrinters: [BluetoothPrinter] = []
    private var supportedPrinterCharacteristics: [String] = ["BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F"]
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Überprüfen und Hinzufügen bereits verbundener Geräte
        // TODO statt ein leeres Array, ein Array mit verfügbaren Services zurückgeben
        let connectedPeripherals = centralManager.retrieveConnectedPeripherals(withServices: [])
        for peripheral in connectedPeripherals {
            connectedDevices.append(peripheral)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Bluetooth ist aktiviert, starte Gerätesuche
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("Bluetooth ist nicht verfügbar.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //checking all BT-Devices if name is not nil and contains a "p" for printer
        if !availableDevices.contains(peripheral) && peripheral.name != nil && peripheral.name!.lowercased().contains("p"){
            availableDevices.append(peripheral)
        }
    }
    
    func connect(to peripheral: CBPeripheral) {
        
        centralManager.connect(peripheral, options: nil)
        connectedDevices.append(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Verbindung erfolgreich hergestellt
        print("Verbindung hergestellt mit \(peripheral.name ?? "Unbekanntes Gerät")")
        
        // Dienste des verbundenen Geräts entdecken
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Fehler beim Herstellen der Verbindung zum Peripheral: \(error?.localizedDescription ?? "Unbekannter Fehler")")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            print("no services found")
            return }
        
        print(services)
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
            print("\(service.uuid):  \(service.description)")
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            print("No characteristics found for service \(service.uuid)")
            return
        }
        
        print("Characteristics found for service \(service.uuid):")
        for characteristic in characteristics {
            print("- \(characteristic.uuid)")
            if supportedPrinterCharacteristics.contains("\(characteristic.uuid)"){
                let foundPrinter = BluetoothPrinter(name: peripheral.name!, service: service.uuid, characteristic: characteristic.uuid, identifier: peripheral.identifier)
                print("identifier:  \(foundPrinter.identifier)")
                availablePrinters.append(foundPrinter)
            }
        }
    }
    
    
    func sendTestCommand(command: String, characteristic: CBCharacteristic){
        
    }
    
    func printImage(image: Data){
        guard let printer = connectedDevices.first else {
            print("No printer connected")
            return
        }
        
        // Hier den Dienst 16F0 verwenden (falls Ihr Drucker diesen Dienst unterstützt)
        let serviceUUID = CBUUID(string: "18F0")
        
        guard let service = printer.services?.first(where: { $0.uuid == serviceUUID }) else {
            print("Service 16F0 not found")
            return
        }
        
        // Hier eine passende Charakteristik für das Schreiben von Daten auswählen
        guard let characteristic = service.characteristics?.first(where: { $0.properties.contains(.write) }) else {
            print("No writable characteristic found in service 18F0")
            return
        }
        
        // Daten an den Drucker senden
        printer.writeValue(image, for: characteristic, type: .withResponse)
    }
    
    func printConnectedPrinterServiceUUIDs() {
        guard let printer = connectedDevices.first else {
            print("No printer connected")
            return
        }
        
        for service in printer.services ?? [] {
            print("Service UUID: \(service.uuid)")
        }
    }
}


