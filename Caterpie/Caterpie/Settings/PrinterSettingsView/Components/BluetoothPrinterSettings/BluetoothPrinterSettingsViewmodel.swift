//
//  BluetoothPrinterSettingsViewmodel.swift
//  Caterpie
//
//  Created by Danny Dauck on 10.03.24.
//

import Foundation
import SwiftUI
import CoreBluetooth

class BluetoothPrinterSettingsViewmodel: ObservableObject{
    
    let pm = PrinterManager.shared
    let bt = BluetoothManager.shared
    @Published var printer: BluetoothPrinter
    
    init(printer: BluetoothPrinter) {
        self.printer = printer
    }
    
    @Published var displayName = ""
    private var rollSize: Int = 60
    private var dpi: Int = 100
    @Published var hasCutter: Bool = false
    @Published var serviceUUID: String = ""
    @Published var characteric: String = ""
    @Published var canPrintImages: Bool = false
    @Published var imageCommand: String = ""
    @Published var txtCommand: String = ""
    @Published var bigTxtCommand: String = ""
    @Published var boldTextCommand: String = ""
    @Published var smallTextOn = ""
    @Published var smallTxtOff = ""
    @Published var cutterCommand = ""
    
    
    
    @Published var dpiTxt: String = "100"{
        didSet{
            if let newValue = Int(dpiTxt){
                dpi = newValue
            }
        }
    }
    
    @Published var rollSizeTxt: String = "60"{
        didSet{
            if let newValue = Int(rollSizeTxt){
                rollSize = newValue
            }
        }
    }
    
    func setUpPrinterWithDefaults(){
        
        rollSize  = 60
        printer.printSizeMM = rollSize
        
    }
    
    func loadPrinterSettings(){
        
        displayName = printer.displayName
        rollSize = printer.printSizeMM
        dpi = printer.dpi
        
        hasCutter = printer.hasCutter
        serviceUUID = printer.service?.uuidString ?? ""
        characteric = printer.characteristic?.uuid.uuidString ?? ""
        canPrintImages = printer.imagePrinter
        

        imageCommand = printer.imagePrintCommand
        txtCommand = printer.normalTextCommand
        bigTxtCommand = printer.largeTextCommand
        boldTextCommand = printer.boldTextCommand
        smallTextOn = printer.smallTextCommand
        smallTxtOff = printer.smallTextOffCommand
        cutterCommand = printer.cutterCommand
        rollSizeTxt = String(rollSize)
        dpiTxt = String(dpi)
        
        
    }
    
    func testTxtPrint(){
        
        guard let char = printer.peripheral.services?.filter({
            $0.uuid.uuidString == serviceUUID
        }).first?.characteristics?.filter({char in
            char.uuid.uuidString == characteric
        }).first! else{
            print("Characteristic not found")
            return
        }
        
        printer.smallText("small text left\n", .left)
        printer.text("normal left\n")
        printer.text("bold normal text center\n", .center, .bold)
        printer.largeText("large center\n")
        printer.smallText("small center bold\n", .center, .bold)
        printer.text("right normal\n", .right)
        printer.largeText("large left bold\n", .left, .bold)
        
    }
    
    func testImagePrint(){
        
        printer.printImage()
        
    }
    
    func savePrinter(){
        
        var newBT = BluetoothPrinter(name: printer.name, identifier: printer.identifier, peripheral: printer.peripheral)
        newBT.displayName = displayName
        newBT.printSizeMM = rollSize
        newBT.dpi = dpi

        newBT.hasCutter = hasCutter
        newBT.service = CBUUID(string: serviceUUID)
        BluetoothManager.shared.connectDevice(newBT.peripheral)
        newBT.characteristic = newBT.peripheral.services?.first(where: {$0.uuid.uuidString == serviceUUID})?.characteristics?.first(where: {$0.uuid.uuidString == characteric})
        newBT.imagePrinter = canPrintImages

        newBT.imagePrintCommand = imageCommand
        newBT.normalTextCommand = txtCommand
        newBT.largeTextCommand = bigTxtCommand
        newBT.boldTextCommand = boldTextCommand
        newBT.smallTextCommand = smallTextOn
        newBT.smallTextOffCommand = smallTxtOff
        newBT.cutterCommand = cutterCommand
        
        

        if let index = pm.btPrinters.firstIndex(where: { $0.identifier == newBT.identifier }) {
            pm.btPrinters[index] = newBT
            printer = pm.btPrinters[index]
            loadPrinterSettings()
            print("change printer succeed")
        } else {
            pm.btPrinters.append(newBT)
        }
    }
    
}
