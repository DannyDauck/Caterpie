//
//  ImageHeaderSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 12.03.24.
//
import SwiftUI
import AppKit

struct ImageHeaderSettingsView: View {
    
    @State var selectedImage: NSImage?
    @State var isImagePickerPresented = false // Neuer Zustand, um den ImagePicker zu präsentieren
    
    var body: some View {
        VStack {
            Button("Bild auswählen") {
                // Setze den Zustand, um den ImagePicker zu präsentieren
                isImagePickerPresented.toggle()
            }
            .sheet(isPresented: $isImagePickerPresented) {
                // Hier wird der ImagePicker als Blattansicht präsentiert
                ImagePicker(image: $selectedImage)
                    .frame(width: 300, height: 300) // Größe des ImagePicker anpassen
            }
            
            if let image = selectedImage {
                HStack{
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    if let blackAndWhite =
                    ImageConverter().getBlackAndWhiteImage(NSBitmapImageRep(data: image.tiffRepresentation!)!) {
                        Image(nsImage: ImageConverter().bitmapImageRepToNSImage(blackAndWhite)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    } else {
                        Text("Fehler beim Erstellen des Schwarz-Weiß-Bildes")
                    }
                }
            } else {
                Text("Kein Bild ausgewählt")
            }
            Spacer()
        }.onChange(of: selectedImage){
            isImagePickerPresented = false
        }
    }
}


#Preview {
    ImageHeaderSettingsView()
}
