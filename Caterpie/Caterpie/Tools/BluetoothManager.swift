//
//  BluetoothManager.swift
//  Caterpie
//
//  Created by Danny Dauck on 01.03.24.
//



import Cocoa
import Foundation
import CoreBluetooth


class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    
    // MARK: - Var declaration
    
    static let shared = BluetoothManager()
    
    @Published var availableDevices: [CBPeripheral] = []
    @Published var availablePrinters: [BluetoothPrinter] = []
    @Published var isRefreshing: Bool = false
    @Published var connectedDevices: [CBPeripheral] = []
    
    private var manager: CBCentralManager!
    
    private var listOfPrintingStandardCHaracteristicUUIDs: [String] = ["BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F"]
    
    // MARK: - End
    
    
    private override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    
    
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
            //TODO implement what to do for states  instead of integers
        case .poweredOn:1
        case .poweredOff: 0
        case .resetting: 0
        case .unauthorized: 5
        case .unknown: 6
        case .unsupported: 7
        @unknown default:  2
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let name = peripheral.name else {
            return
        }
        
        if !availableDevices.contains(peripheral){
            availableDevices.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func startScan(){
        if !manager.isScanning{
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func stopScan(){
        if manager.isScanning{
            manager.stopScan()
        }
    }
    
    func connectDevice(_ peripheral: CBPeripheral){
        manager.connect(peripheral)
        if !connectedDevices.contains(peripheral){
            connectedDevices.append(peripheral)
        }
    }
    
    func disconnectDevice(_ peripheral: CBPeripheral){
        manager.cancelPeripheralConnection(peripheral)
        if connectedDevices.contains(peripheral){
            connectedDevices.removeAll(where: {
                $0 == peripheral
            })
        }
    }
    
    func refresh(){
        stopScan()
        isRefreshing = true
        availableDevices = []
        availablePrinters = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRefreshing = false
        }
        
    }
    
    func discoverServices(_ peripheral: CBPeripheral){
        peripheral.discoverServices(nil)
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error{
            print("<<<<<<<<<  Discover services failed: \(error)")
            return
        }
        
        guard let services = peripheral.services else {
            print("tt_err_no_service_found")
            print("peripheral: \(peripheral.identifier)")
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics([], for: service)
        }
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error{
            print("<<<<<<<<<<<   Discover characteristics failed: \(error)")
            return
        }
        
        guard let chars = service.characteristics else {
            print("tt_err_no_char_found")
            print("service: \(service.uuid)")
            return
        }
        
        for char in chars{
            if listOfPrintingStandardCHaracteristicUUIDs.contains(where: {$0 == "\(char.uuid)"}){
                createStandardBluetoothPrinter(peripheral, service, char)
            }
            print(chars)
        }
        
    }
    
    private func createStandardBluetoothPrinter(_ peripheral: CBPeripheral, _ service: CBService, _ char: CBCharacteristic){
        let newPrinter = BluetoothPrinter(name: peripheral.name ?? "", service: service.uuid, characteristic: char, identifier: peripheral.identifier, peripheral: peripheral)
        availablePrinters.append(newPrinter)
    }
    
    
    
    //TODO
    
    func updatePrinterStandardCharacteristics(){
        //when the app is connected to firebase and coreData is implemented
        //gotta use this on init to check if new available standards are available
        //and may not just use tha characteristic, better a printer profil
        //or check by the printers peripheral name as more profils are knowing than just my develope
        //printer
    }
    
}



