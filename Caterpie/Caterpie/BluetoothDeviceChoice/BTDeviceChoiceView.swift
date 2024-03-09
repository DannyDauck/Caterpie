//
//  BTDeviceChoiceView.swift
//  Caterpie
//
//  Created by Danny Dauck on 01.03.24.
//

import SwiftUI
import CoreBluetooth

struct BTDeviceChoiceView: View {
    @ObservedObject var bluetoothManager = BluetoothManager.shared
    @ObservedObject var cm = ColorManager.shared
    @State var isScanning = false
    @State var searchText = ""
    @State var currentDevice: CBPeripheral?
    @State var alertIsVisible = false
    private let am = AudioManager()
    
    var body: some View {
        VStack{
            HStack{
                Text("tt_h1_search_for_bluetooth_devices")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack{
                ZStack{
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(cm.shadow)
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(isScanning ? cm.foregroundActive : cm.linearShadow)
                        .padding(1)
                }.padding(5)
                    .background(isScanning ? cm.btnBgActive : cm.btnBgInactive)
                    .cornerRadius(5)
                    .padding(2)
                    .background(cm.btnBgInactive)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                    .onTapGesture {
                        withAnimation{
                            isScanning = true
                            bluetoothManager.startScan()
                            am.play(.click)
                        }
                        
                    }
                ZStack{
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(cm.shadow)
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(!isScanning ? cm.foregroundActive : cm.linearShadow)
                        .padding(1)
                }.padding(5)
                    .background(!isScanning ? cm.btnBgActive : cm.btnBgInactive)
                    .cornerRadius(5)
                    .padding(2)
                    .background(cm.btnBgInactive)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                    .onTapGesture {
                        withAnimation(.smooth){
                            isScanning = false
                            bluetoothManager.stopScan()
                            am.play(.click)
                        }
                    }
                ZStack{
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(cm.shadow)
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(!bluetoothManager.availableDevices.isEmpty ? cm.foregroundActive : cm.linearShadow)
                        .padding(1)
                }.padding(5)
                    .background(bluetoothManager.isRefreshing ? cm.btnBgActive : cm.btnBgInactive)
                    .cornerRadius(5)
                    .padding(2)
                    .background(cm.btnBgInactive)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                    .onTapGesture {
                        bluetoothManager.refresh()
                        isScanning = false
                        am.play(.trash)
                    }
                Spacer()
            }
            List(bluetoothManager.availableDevices.filter({
                //name cannot be null because BluetoothManager filters all devices without name
                if !searchText.isEmpty{
                    $0.name!.lowercased().contains(searchText.lowercased())
                }else{
                    true
                }
            }), id: \.self){
                device in
                if bluetoothManager.availablePrinters.contains(where: {
                    $0.peripheral == device
                }){
                    BlueToothPrinterRowView(printer: bluetoothManager.availablePrinters.filter({
                        $0.peripheral == device
                    }).first!)
                }else{
                    Text(device.name!)
                        .foregroundStyle(currentDevice == device ? cm.txtImportant : Color(NSColor.labelColor))
                        .onTapGesture {
                            bluetoothManager.connectDevice(device)
                            currentDevice = device
                        }
                    if currentDevice == device{
                        HStack{
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundStyle(cm.txtImportant)
                                .padding(.leading, 5)
                            Text("tt_append")
                                .foregroundStyle(cm.txtImportant)
                        }.onTapGesture {
                           alertIsVisible = true
                        }
                    }
                }
            }.cornerRadius(8)
            HStack{
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                TextField("tt_name", text: $searchText)
            }.padding(.top, 5)
        }.padding()
            .alert(isPresented: $alertIsVisible){
                Alert(
                    title: Text("tt_attention"),
                    message: Text("tt_warning_add_device_to_printers"),
                    primaryButton: .default(Text("tt_h1_understood")){
                        //TODO add func to PrinterManager to append BT printer
                    },
                    secondaryButton: .cancel(Text("tt_cancel"))
                )
            }
    }
}


#Preview {
    BTDeviceChoiceView(bluetoothManager: BluetoothManager.shared)
}
