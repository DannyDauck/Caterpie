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
        /*
        var data = Data()
        
        
        let txtCom = "Normal text\n".data(using: .utf8)!
        let boldTxt = boldText("This text should be bold\n")
        let largeTxt = "\u{1B}\u{21}\u{30}Your large text here\n\u{1B}\u{21}\u{00}".data(using: .utf8)!
        let smallText = "\u{1B}\u{4D}\u{01}Your small text here\n\u{1B}\u{4D}\u{00}".data(using: .utf8)!

        // Daten zum Druckdatenstrom hinzufügen
        data.append(txtCom)
        data.append(smallText)
        data.append(boldTxt)
        data.append(largeTxt)
        
        data.append("\u{1B}\u{4D}\u{01}This is text size 1\n\u{1B}\u{4D}\u{00}\u{1B}".data(using: .utf8)!)
        data.append("\u{21}\u{00}\u{1B}\u{21}\u{30}\u{1B}\u{21}\u{08}Your large bold text here\n\u{1B}\u{21}\u{00}".data(using: .utf8)!)
        
      //  let centeredAlignmentCommand = Data([0x1B, 0x61, 0x01])
        let centeredAlignmentCommand = "\u{1B}a1".data(using: .utf8)!
        data.append(centeredAlignmentCommand)
        data.append("\u{1B}\u{21}\u{30}centered large text\n\u{1B}\u{21}\u{00}".data(using: .utf8)!)
        
        let rightAlignmentCommand = "\u{1B}a2".data(using: .utf8)!
        data.append(rightAlignmentCommand)
        data.append("\u{1B}\u{21}\u{00}right aligment normal text\n\u{1B}\u{21}\u{00}".data(using: .utf8)!)
        
        let leftAlignmentCommand = "\u{1B}a0".data(using: .utf8)!
        data.append(leftAlignmentCommand)
        data.append("\u{1B}\u{21}\u{00}left aligment normal text\n\u{1B}\u{21}\u{00}".data(using: .utf8)!)

        printer.peripheral.writeValue(data, for: char, type: .withoutResponse)
         */
        printer.smallText("small text left\n", .left)
        printer.text("normal left\n")
        printer.text("bold normal text center\n", .center, .bold)
        printer.largeText("large center\n")
        printer.smallText("small center bold\n", .center, .bold)
        printer.text("right normal\n", .right)
        printer.largeText("large left bold\n", .left, .bold)
    }
    
    
    func boldText(_ string: String) -> Data{
        let boldOn = "\u{1B}\u{21}\u{08}"
        let boldOff = "\u{1B}\u{21}\u{00}"
        
        let data = "\(boldOn)\(string)\(boldOff)".data(using: .utf8)!
        return data
    }
    
}
