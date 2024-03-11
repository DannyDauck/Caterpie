//
//  PrinterSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//
//    appuuid111111111:moduluuid2222222222:useruuid33333333 trial qrc
import SwiftUI

struct PrinterSettingsView: View {
    
    @ObservedObject var pm =  PrinterManager.shared
    @State var selection =  "Bluetooth"
    @State var btPrinter: BluetoothPrinter?
    @State var printer: Printer?
    
    var body: some View {
        GeometryReader{geo in
            VStack(spacing: 0){
                HStack{
                    Text("tt_h1_printer_settings")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 10)
                        .padding(.vertical, 5)
                    Spacer()
                }.background(.black)
                HStack{
                    VStack{
                        HStack{
                            Text("tt_h1_devices")
                                .font(.title2)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        HStack{
                            Picker("", selection: $selection , content: {
                                Text("Bluetooth").tag("Bluetooth")
                                Text("WLAN & Wired").tag("WLAN & Wired")
                            }).pickerStyle(.segmented)
                        }.padding(.top, 4)
                        switch selection{
                        case "Bluetooth" : List(pm.btPrinters, id: \.self.displayName){printer in
                            HStack{
                                BlueToothPrinterRowView(printer: printer, showAppend: false)
                                if printer.service == nil{
                                    HStack{
                                        Text("⚠️ ")
                                        Text("tt_printer_need_to_be_configured")
                                        Text(" ⚠️")
                                    }
                                }
                            }.onTapGesture {
                                btPrinter = printer
                            }
                        }.cornerRadius(3)
                                .frame(height: geo.size.height / 3)
                        case "WLAN & Wired" :
                            List(pm.printers, id: \.self.displayName){printer in
                                Text(printer.displayName)
                            }.cornerRadius(3)
                                .frame(height: geo.size.height / 3)
                        default : List(pm.printers, id: \.self.displayName){printer in
                            Text(printer.displayName)
                        }.cornerRadius(3)
                        }
                        if btPrinter != nil || printer != nil {
                            switch selection{
                            case "Bluetooth" : BluetoothPrinterSettingsView(btPrinter!.identifier)
                                
                            default : Text("tt_no_device_chosen")
                            }
                        }
                        
                        Spacer()
                    }.padding(.leading)
                    Spacer()
                    
                    VStack{
                        BTDeviceChoiceView()
                            .frame(height: geo.size.height/2)
                        VStack{
                            HStack{
                                Text("tt_h1_system_printers")
                                    .font(.title2)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }.padding(.bottom, 5)
                            Divider()
                            ForEach(pm.listPrinters(), id: \.self){name in
                                SystemPrinterRow(name: name)
                                Divider()
                            }.padding(3)
                                .background()
                                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                            
                        }.frame(height: geo.size.height/2)
                            .padding()
                    }.frame(width: geo.size.width/2.5)
                        .background(Color(NSColor.windowBackgroundColor))
                        .padding(.leading, 2)
                        .background(.gray)
                }
            }
        }
    }
}

#Preview {
    PrinterSettingsView()
}
