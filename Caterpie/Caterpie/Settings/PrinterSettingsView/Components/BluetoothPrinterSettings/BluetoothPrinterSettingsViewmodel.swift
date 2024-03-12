//
//  BluetoothPrinterSettingsViewmodel.swift
//  Caterpie
//
//  Created by Danny Dauck on 10.03.24.
//

import Foundation
import SwiftUI

class BluetoothPrinterSettingsViewmodel: ObservableObject{
    
    let printerID: UUID
    let pm = PrinterManager.shared
    let bt = BluetoothManager.shared
    var printer: BluetoothPrinter
    
    init(printerID: UUID) {
        self.printerID = printerID
        self.printer = pm.btPrinters.filter({
            $0.identifier == printerID
        }).first!
    }
    
    @Published var displayName = ""
    @Published var rollSize: Int = 0
    @Published var dpi: Int = 100
    @Published var hasCutter: Bool = false
    @Published var serviceUUID: String = ""
    @Published var characteric: String = ""
    @Published var canPrintImages: Bool = false
    @Published var imageCommand: String = ""
    @Published var smallTextOn = ""
    
    
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
        let image = NSImage(resource: .minionBanana)
        
        guard let printerImage = ImageConverter().getPrinterImage(image, dpi: printer.dpi, rollSizeMM: printer.printSizeMM, indentationMM: 4) else {
            return
        }
        
        guard let data = printerImage.representation(using: .bmp, properties: [:]) else {
            return
        }
        
        guard let char = printer.characteristic else {
            print("tt_no_characteristic_found")
            return
        }
        
        var printCommand = Data()
        
        printCommand.append("PRINT BITMAP".data(using: .utf8)!)
        printCommand.append(data)
        
        printer.peripheral.writeValue(printCommand, for: char, type: .withoutResponse)
    }
    
}
