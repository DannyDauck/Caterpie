//
//  BTDeviceChoiceView.swift
//  Caterpie
//
//  Created by Danny Dauck on 01.03.24.
//

import SwiftUI
import CoreBluetooth

struct BTDeviceChoiceView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        List(bluetoothManager.availableDevices, id: \.self) { device in
            //BlueToothManger already filters devices without name yet, so I can use force unwrapping
            if bluetoothManager.availablePrinters.contains(where: {printer in
                printer.name == device.name }){
                BlueToothPrinterRowView(printer: bluetoothManager.availablePrinters.filter{
                    printer in
                    printer.name == device.name
                }.first!)
            }
            
            Text(device.name!)
                .onTapGesture {
                    self.bluetoothManager.connect(to: device)
                }
                .foregroundStyle(bluetoothManager.connectedDevices.contains(device) ? Color.green: Color.white)
        }
        .padding()
    }
}


#Preview {
    BTDeviceChoiceView(bluetoothManager: BluetoothManager.shared)
}
