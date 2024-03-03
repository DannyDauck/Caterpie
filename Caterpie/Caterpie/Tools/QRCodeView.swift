//
//  SwiftUIView.swift
//  Caterpie
//
//  Created by Danny Dauck on 29.02.24.
//
import SwiftUI
import CoreImage.CIFilterBuiltins
import Photos

struct QRCodeView: View {
    @State var inputString: String
    let filter = CIFilter.qrCodeGenerator()
    let pm = PrinterManager.shared
    @State var printerName  = ""

    var body: some View {
        VStack {
            
            TextField("I'd like to have a banana split", text: $inputString)
            
            if let qrCodeImage = generateQRCodeImage() {
                Image(nsImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
            } else {
                Text("Failed to generate QR code")
                    .foregroundColor(.red)
            }
            
            Button(action: {
                guard let image = generateQRCodeImage() else {
                    return
                }
                pm.printString(string: inputString)
                
            }){
                
                Text("print")
            }.buttonStyle(.borderedProminent)
            
            ForEach(pm.listPrinters(), id: \.self){printer in
                Text(printer)
                    .foregroundStyle(printerName == printer ? Color.green : Color.white)
                    .onTapGesture {
                        printerName = printer
                    }
            }
        }
        .padding()
    }

    func generateQRCodeImage() -> NSImage? {
        guard !inputString.isEmpty else { return nil }

        let data = Data(inputString.utf8)
        filter.setValue(data, forKey: "inputMessage")

        guard let outputImage = filter.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: outputImage.extent.width, height: outputImage.extent.height))
        return nsImage
    }

    func saveQRCodeToPhotoLibrary(image: NSImage?) {
        guard let image = image else { return }

        let imageData = image.tiffRepresentation
        guard let imageRep = NSBitmapImageRep(data: imageData!) else { return }
        guard let pngData = imageRep.representation(using: .png, properties: [:]) else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }

            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: pngData, options: nil)
            } completionHandler: { success, error in
                if let error = error {
                    print("Fehler beim Speichern des QR-Codes: \(error)")
                } else {
                    print("QR-Code erfolgreich gespeichert")
                }
            }
        }
    }
    
    
    func convertImageToJPEGData(image: NSImage) -> Data? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let bitmapImageRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapImageRep.representation(using: .jpeg, properties: [:])
        return jpegData
    }
}


#Preview {
    QRCodeView(inputString: "I like to have a bananana split")
}


