//
//  BlueToothPrinterRowView.swift
//  Caterpie
//
//  Created by Danny Dauck on 03.03.24.
//

import SwiftUI
import CoreBluetooth

struct BlueToothPrinterRowView: View {
    
    @State var printer: BluetoothPrinter
    @State var isConnected: Bool = true
    var cm = ColorManager.shared
    
    var body: some View {
        HStack{
            if isConnected {
                ZStack{
                    Image(systemName: "dot.radiowaves.right")
                        .font(.title2)
                        .padding([.top, .leading], 2)
                    Image(systemName: "dot.radiowaves.right")
                        .font(.title2)
                        .foregroundStyle(cm.symbolActive)
                }
            
            }else{
                Image(systemName: "dot.radiowaves.right")
                    .font(.title2)
            }
            Image(systemName: "printer.fill")
                .font(.title2)
            ZStack{
                Text("BT-Printer")
                    .padding([.top,.leading], 2)
                Text("BT-Printer")
                    .foregroundStyle(cm.txtImportant)
            }
            Text(printer.name)
                .fontWeight(printer.state == .connected ? .bold : .regular)
            
            if isConnected{
                Button(action: {
                    BluetoothManager.shared.disconnectDevice(printer.peripheral)
                    isConnected = false
                }){
                    Text("disconnect")
                }.buttonStyle(.borderedProminent)
                    .padding(.leading, 5)
            }else{
                Button(action:{
                    BluetoothManager.shared.connectDevice(printer.peripheral)
                    isConnected = true
                }){
                    Text("connect")
                }.buttonStyle(.borderedProminent)
                    .padding(.leading, 5)
            }
            
        }.padding(.horizontal)
            .padding(.vertical,4)
            .cornerRadius(15)
            .shadow(radius: 4)
    }
}


