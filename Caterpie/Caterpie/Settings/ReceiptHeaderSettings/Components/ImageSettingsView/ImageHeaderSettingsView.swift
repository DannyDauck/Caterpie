//
//  ImageHeaderSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 12.03.24.
//
import SwiftUI
import AppKit

struct ImageHeaderSettingsView: View {
    
    private let cm = ColorManager.shared
    private var pm = PrinterManager.shared
    @ObservedObject var vm = ImageSettingsViewViewmodel()
    
    
    var body: some View {
        VStack {
            Button("Bild auswählen") {
                vm.isImagePickerPresented.toggle()
            }
            .sheet(isPresented: $vm.isImagePickerPresented) {
                ImagePicker(image: $vm.selectedImage)
                    .frame(width: 300, height: 300)
            }
            
            if let image = vm.selectedImage {
                HStack{
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    if vm.blackAndWhiteImage != nil {
                        VStack{
                            Image(nsImage: vm.blackAndWhiteImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 300)
                            
                        }.padding(.vertical)
                            .onAppear{
                                vm.settingsIsVisible = true
                            }
                    } else {
                        Text("Fehler beim Erstellen des Schwarz-Weiß-Bildes")
                    }
                }
            } else {
                Text("Kein Bild ausgewählt")
            }
            if vm.settingsIsVisible{
                HStack{
                    Text("Threshold")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack{
                    Text("current: \(String(format: "%.1f", vm.threshold - 1))")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack{
                    Text("- 0.5")
                    Slider(value: $vm.threshold, in: 0.5 ... 1.5, step: 0.1)
                        .frame(width: 400)
                    Text("+ 0.5")
                    Spacer()
                }
                
                
                HStack{
                    Text("tt_inverte")
                        .font(.title2)
                        .fontWeight(.bold)
                    ZStack{
                        Image(systemName: "circle")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.top, .leading], 2)
                            .foregroundStyle(cm.shadow)
                        Image(systemName: !vm.inverted ? "circle" : "circle.circle.fill")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(vm.inverted ? cm.foregroundActive : cm.btnBgInactive)
                    }.onTapGesture {
                        withAnimation(.easeIn){
                            vm.inverted.toggle()
                        }
                    }
                    Spacer()
                }
                
                Button(action: {
                    pm.setHeaderData(vm.blackAndWhiteImage!)
                }){
                    Text("apply to printers")
                }
                
            }
            Spacer()
        }.onChange(of: vm.selectedImage){
            vm.isImagePickerPresented = false
        }
    }
}


#Preview {
    ImageHeaderSettingsView()
}
