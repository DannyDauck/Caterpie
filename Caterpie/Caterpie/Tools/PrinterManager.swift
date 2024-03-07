//
//  AirprintTrial.swift
//  Caterpie
//
//  Created by Danny Dauck on 01.03.24.
//

import Foundation
import AppKit
import IOKit.usb


class PrinterManager {
    
    //building a singleton
    static let shared = PrinterManager()
    
    private init(){
        listOccupiedUSBPorts()
    }
    
    
    func printQRCodeToNamedPrinter(string: String, printerName: String) {
        // Generiere den CPCL-Druckbefehl für den QR-Code
        let cpclCommand = generateCPCLQRCode(text: string)
        
        // Sende den CPCL-Befehl an den Drucker
        sendCommandToNamedPrinter(command: cpclCommand, printerName: printerName)
    }
    
    private func generateCPCLQRCode(text: String) -> String {
        return "! 0 200 200 230 1\n" +
        "B QR 10 10 M 2 U 6\n" +
        "MA,\(text)\n" +
        "ENDQR\n" +
        "PRINT\n"
    }
    
    private func sendCommandToNamedPrinter(command: String, printerName: String) {
        guard let printerURL = NSURL(string: "ipp://\(printerName)") else {
            print("Ungültige Drucker-URL.")
            return
        }
        
        do {
            try command.write(to: URL(string: "/dev/rdisk1s2")! as URL, atomically: true, encoding: .utf8)
            print("Druckbefehl erfolgreich an \(printerName) gesendet.")
        } catch {
            print("Fehler beim Senden des Druckbefehls an \(printerName): \(error)")
        }
    }
    
    func listPrinters() -> [String]{
        return NSPrinter.printerNames
    }
    
    func listOccupiedUSBPorts() {
        // Suche nach allen USB-Geräten
        
        let matchingDict = IOServiceMatching(kIOUSBDeviceClassName)
        var iterator: io_iterator_t = 0
        let result = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iterator)
        
        guard result == KERN_SUCCESS else {
            print("Failed to get matching services")
            return
        }
        
        var device: io_object_t = 0
        while true {
            //Geräteinformationen abfragen
            device = IOIteratorNext(iterator)
            if device == 0 {
                print("device is 0")
                break
            }
            if let deviceName = IORegistryEntryCreateCFProperty(device, kIOBSDNameKey as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? String,
                let devicePath = IORegistryEntryCreateCFProperty(device, kIOPathKey as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue() as? String {
                print("Device: \(deviceName), Path: \(devicePath)")
            }else{
                print("device is empty")
                print(device)
            }
            IOObjectRelease(device)
        }
        IOObjectRelease(iterator)
    }
}
