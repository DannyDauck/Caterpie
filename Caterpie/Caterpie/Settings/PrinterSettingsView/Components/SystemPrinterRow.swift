//
//  SystemPrinterRow.swift
//  Caterpie
//
//  Created by Danny Dauck on 08.03.24.
//

import SwiftUI
import Cocoa

struct SystemPrinterRow: View {
    
    let name: String
    let cm = ColorManager.shared
    @State private var addPrinterSucceeded: Bool?
    @ObservedObject var pm = PrinterManager.shared
    
    var body: some View {
        HStack{
            VStack{
                HStack{
                    Text(name)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 5)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack{
                    Text(NSPrinter(name: name)!.type.rawValue)
                        .padding(.leading, 6)
                    Spacer()
                }
                if addPrinterSucceeded != nil {
                    if !addPrinterSucceeded!{
                        Text("tt_appending_printer_failed")
                            .font(.caption)
                            .foregroundStyle(cm.exceptionGradient)
                    }
                }
            }
            if !pm.printers.contains(where: {$0.factoryName == name}) && addPrinterSucceeded == nil{
                ZStack{
                    HStack{
                        Image(systemName: "plus")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("tt_append")
                    }.padding([.top, .leading],2)
                    HStack{
                        Image(systemName: "plus")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(cm.txtImportant)
                        Text("tt_append")
                            .foregroundStyle(cm.txtImportant)
                    }
                }.onTapGesture {
                    pm.addPrinter(name){result in
                        if result == false {
                            addPrinterSucceeded = false
                        }else{
                            addPrinterSucceeded = true
                        }
                    }
                }
            }
            Spacer()
            if addPrinterSucceeded != nil{
                if addPrinterSucceeded!{
                    ZStack{
                        Image(systemName: "checkmark")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding([.top, .leading], 2)
                        Image(systemName: "checkmark")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(cm.foregroundActive)
                    }
                }
            }
        }
    }
}

struct SystemPrinterRow_preview: PreviewProvider {
    static var previews: some View {
        let name = PrinterManager.shared.listPrinters().first ?? "hello"
        return SystemPrinterRow(name: name)
    }
}

