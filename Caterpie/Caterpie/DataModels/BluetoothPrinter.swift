//
//  BluetoothPrinter.swift
//  Caterpie
//
//  Created by Danny Dauck on 03.03.24.
//

import Foundation
import CoreBluetooth
import Cocoa

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
    var width: Int = 0
    var height: Int = 0
    var imagePrinter: Bool = false
    var grayScale: Int = 1
    
    
    var imagePrintCommand: String = "SIZE 60 mm,40 mm\nGAP 2 mm,0 mm\nSPEED 5\nDENSITY 8\nSET TEAR ON\nREFERENCE 16,48\nOFFSET 0 mm\nSET RIBBON OFF\nSET RESPONSE ON\nDIRECTION 0\nCLS\nBITMAP 16,32,27,240,1,"
    var headerData: NSBitmapImageRep? = nil
    var imageUIntArray: [UInt8] = []
    var imageData = Data()
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
        peripheral.writeValue(data, for: char, type: .withResponse)
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
        peripheral.writeValue(data, for: char, type: .withResponse)
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
        peripheral.writeValue(data, for: char, type: .withResponse)
    }
    
    func printImage(){
        var data = Data()
        /*
        let byteArray = imagePrintCommand.data(using: .utf8)
        data.append(byteArray!)
        */
        printImageWithTSPL(imageData: imageData)
        
        //peripheral.writeValue(data , for: characteristic!, type: .withResponse)
    }
    
    func printImageWithTSPL(imageData: Data) {
        // Generieren Sie den TSPL-Befehl zum Drucken des Bildes
        let tsplCommand = "BITMAP 0,0,\(width / 8),\(height),1,".data(using: .utf8)!
        peripheral.writeValue(tsplCommand, for: characteristic!, type: .withoutResponse)
        var printData = Data()
        printData.append(imageData)
        printData.append(Data(",PRINT 1,1\n".utf8))

        // Senden Sie die kombinierten Daten an den Drucker
        peripheral.writeValue(printData , for: characteristic!, type: .withResponse)
    }
    
    mutating func getImageHeaderData(_ nsBitmapRep: NSBitmapImageRep, _ indentationMM: Int = 4, success: @escaping (Bool)->()){
        
        guard let cgImage = nsBitmapRep.cgImage else {
            success(false)
            return
        }
        
        let targetWidth = self.printSizeMM - (2 * indentationMM)
        let targetHeight = Double(nsBitmapRep.pixelsHigh) * (Double(targetWidth) / Double(nsBitmapRep.pixelsWide))
        let pixelWidth = Int(Double(targetWidth) / 25.4 * Double(self.dpi))
        let pixelHeight = Int(targetHeight / 25.4 * Double(self.dpi))
        
        let newRect = NSRect(origin: .zero, size: CGSize(width: pixelWidth, height: pixelHeight))
        let newBitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(pixelWidth), pixelsHigh: Int(pixelHeight), bitsPerSample: 8, samplesPerPixel: 1, hasAlpha: false, isPlanar: false, colorSpaceName: .deviceWhite, bytesPerRow: 0, bitsPerPixel: 0)
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: newBitmap!)
        NSGraphicsContext.current?.imageInterpolation = .high
        
        NSGraphicsContext.current?.cgContext.draw(cgImage, in: newRect, byTiling: false)
        
        NSGraphicsContext.restoreGraphicsState()
        
        self.headerData = newBitmap
        success(true)
    }
    
    mutating func setNormalTextCommand(_ string: String){
        self.normalTextCommand = string
    }
    
    mutating func setHeaderData(_ nsImage: NSImage){
        guard let printerBitmap = ImageConverter().scaleToPrinterSize(dpi: dpi, rollWidthMM: printSizeMM, indentationMM: 4, image: nsImage) else{
            print("Could not scale Image")
            return
        }
        let imageConverter = ImageConverter()
        guard let bwImage = imageConverter.getBlackAndWhiteImage(printerBitmap) else {
            print("Could not get black and white image for printer")
            return
        }
        
        imageUIntArray = imageConverter.array
        imageData.append(bwImage.representation(using: .bmp, properties: [:])!)
        width = bwImage.pixelsWide
        height = bwImage.pixelsHigh
        headerData = bwImage
        
    }
    
    
}
