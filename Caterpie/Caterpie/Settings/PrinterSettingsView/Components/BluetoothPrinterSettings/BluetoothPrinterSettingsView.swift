//
//  BlueToothPrinterSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 10.03.24.
//

import SwiftUI

struct BluetoothPrinterSettingsView: View {
    
    @State var printerID: UUID
    private let pm = PrinterManager.shared
    
    private var printer: BluetoothPrinter{
        pm.btPrinters.filter({
            printerID == $0.identifier
        }).first!
    }
    
    @ObservedObject var vm: BluetoothPrinterSettingsViewmodel
    
    init(_ id: UUID){
        _printerID = State(initialValue: id)
        vm = BluetoothPrinterSettingsViewmodel(printerID: id)
        if printer.service == nil {
            vm.setUpPrinterWithDefaults()
            vm.loadPrinterSettings()
        }else{
            vm.loadPrinterSettings()
        }
    }
    
    
    var body: some View {
        VStack{
            HStack{
                TextField("tt_name", text: $vm.displayName)
            }
            
            Button(action: {
                vm.testTxtPrint()
            }){
                Text("test")
            }
            Button(action: {
                vm.testImagePrint()
            }, label: {
                Text("try image print")
            })
        }
    }
}

#Preview {
    BluetoothPrinterSettingsView(UUID())
}
