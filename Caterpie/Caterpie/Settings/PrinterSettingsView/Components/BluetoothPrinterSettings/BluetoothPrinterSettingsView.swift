//
//  BlueToothPrinterSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 10.03.24.
//

import SwiftUI

struct BluetoothPrinterSettingsView: View {
    
    
    @ObservedObject var vm: BluetoothPrinterSettingsViewmodel
    private let pm = PrinterManager.shared
    private let cm = ColorManager.shared
    
    
    
    
    
    @State var madeChanges = false
    
    
    
    var body: some View {
        ScrollView{
            HStack{
                Text(vm.printer.displayName)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action:{
                    vm.savePrinter()
                }){
                    Text("tt_apply_changes")
                }.buttonStyle(.borderedProminent)
                    .padding(.trailing, 5)
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
            HStack{
                Text("tt_display_name")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 150)
                    .multilineTextAlignment(.leading)
                Spacer()
                TextField("Display name", text: $vm.displayName)
                Spacer()
            }
            
            HStack{
                Text("tt_service")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 150)
                    .multilineTextAlignment(.leading)
                TextField("Service", text: $vm.serviceUUID)
                Spacer()
            }
            
            HStack{
                Text("tt_characteristic")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 150)
                    .multilineTextAlignment(.leading)
                TextField("Characteristic", text: $vm.characteric)
                Spacer()
            }
            
            HStack{
                Text("tt_dpi")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 150)
                    .multilineTextAlignment(.leading)
                TextField("DPI", text: $vm.dpiTxt)
                Spacer()
                
            }
            
            HStack{
                Text("tt_rollSize")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 150)
                    .multilineTextAlignment(.leading)
                TextField("Rollsize", text: $vm.rollSizeTxt)
                Spacer()
                
            }
            
            SettingStringEditorRow(name: "tt_text_command", value: $vm.txtCommand)
            SettingStringEditorRow(name: "tt_bold_txt_command", value: $vm.boldTextCommand)
            SettingStringEditorRow(name: "tt_small_txt_on_command", value: $vm.smallTextOn)
            SettingStringEditorRow(name: "tt_small_txt_off_command", value: $vm.smallTxtOff)
            SettingStringEditorRow(name: "tt_large_txt_command", value: $vm.bigTxtCommand)

            
            HStack{
                Text("tt_can_print_image")
                    .font(.title2)
                    .fontWeight(.bold)
                ZStack{
                    Image(systemName: "circle")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding([.top, .leading], 2)
                        .foregroundStyle(cm.shadow)
                    Image(systemName: !vm.canPrintImages ? "circle" : "circle.circle.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(vm.canPrintImages ? cm.foregroundActive : cm.btnBgInactive)
                }.onTapGesture {
                    withAnimation(.easeIn){
                        vm.canPrintImages.toggle()
                    }
                }
                Spacer()
            }
            
            SettingStringEditorRow(name: "tt_image_print_command", value: $vm.imageCommand)
            
            HStack{
                Text("tt_has_cutter")
                    .font(.title2)
                    .fontWeight(.bold)
                ZStack{
                    Image(systemName: "circle")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding([.top, .leading], 2)
                        .foregroundStyle(cm.shadow)
                    Image(systemName: !vm.hasCutter ? "circle" : "circle.circle.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(vm.hasCutter ? cm.foregroundActive : cm.btnBgInactive)
                }.onTapGesture {
                    withAnimation(.easeIn){
                        vm.hasCutter.toggle()
                    }
                }
                Spacer()
            }
            
            SettingStringEditorRow(name: "tt_cutter_command", value: $vm.cutterCommand)
            
        }.onAppear{
            vm.loadPrinterSettings()
        }
    }
}


/*
 #Preview {
 BluetoothPrinterSettingsView()
 }
 */
