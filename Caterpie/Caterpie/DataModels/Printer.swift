//
//  Printer.swift
//  Caterpie
//
//  Created by Danny Dauck on 08.03.24.
//

import Foundation
import Cocoa

struct Printer{
    
    let nsPrinter: NSPrinter
    var displayName: String
    var factoryName: String{
        nsPrinter.name
    }
    var type: String{
        nsPrinter.type.rawValue
    }
    
    init(nsPrinter: NSPrinter, displayName: String) {
        self.nsPrinter = nsPrinter
        self.displayName = displayName
    }
    
    init(_ printer: NSPrinter){
        nsPrinter = printer
        displayName = nsPrinter.name
    }
}
