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
               // do{
               //     try BluetoothManager.shared.printImage(image: generateQRCodeImage()!, printer: BluetoothManager.shared.availablePrinters.first!)
               // }catch{
               //     if error as! BananaSplitError == BananaSplitError.imageConvertFailed{
               //         print(error)
                //    }
                
             //   }
                
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
}


#Preview {
    QRCodeView(inputString: "I like to have a bananana split")
}


