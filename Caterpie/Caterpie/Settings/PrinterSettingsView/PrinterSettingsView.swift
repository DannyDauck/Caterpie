//
//  PrinterSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import SwiftUI

struct PrinterSettingsView: View {
    
    @ObservedObject var pm =  PrinterManager.shared
    
    var body: some View {
        GeometryReader{geo in
            VStack{
                HStack{
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
                }
            }
        }
    }
}

#Preview {
    PrinterSettingsView()
}
