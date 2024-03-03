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
    
    var body: some View {
        HStack{
            switch printer.state {
            case .connected:
                ZStack{
                    Image(systemName: "dot.radiowaves.right")
                        .font(.title2)
                        .padding([.top, .leading], 2)
                    Image(systemName: "dot.radiowaves.right")
                        .font(.title2)
                        .foregroundStyle(.green)
                }
            case .connecting:
                ProgressView()
                    .frame(width: 48, height: 48)
            case .disconnected:
                Image(systemName: "dot.radiowaves.right")
                    .font(.title2)
            case .disconnecting:
                ProgressView()
                    .frame(width: 48, height: 48)
            }
            Image(systemName: "printer.fill")
                .font(.title2)
            ZStack{
                Text("BT-Printer")
                    .padding([.top,.leading], 2)
                Text("BT-Printer")
                    .foregroundStyle(.yellow)
            }
            Text(printer.name)
                .fontWeight(printer.state == .connected ? .bold : .regular)
            
        }.padding(.horizontal)
            .padding(.vertical,4)
            .cornerRadius(15)
            .shadow(radius: 4)
    }
}

struct BlueToothPrinterRowView_Previews: PreviewProvider {
    static var previews: some View {
        var printer = BluetoothPrinter(name: "Goojptr MTP-3b", service: CBUUID(string: "9FA480E0-4967-4542-9390-D343DC5D04AE"), characteristic: CBUUID(string: "9FA480E0-4967-4542-9390-D343DC5D04AE"), identifier: UUID())
        printer.setState(.connected)
        
        return BlueToothPrinterRowView(printer: printer)
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
