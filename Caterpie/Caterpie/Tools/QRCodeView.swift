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
    @State var printerName  = ""

    var body: some View {
        VStack {
            
            
            if let qrCodeImage = generateQRCodeImage() {
                Image(nsImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
            } else {
                Text("tt_err_Failed_to_generate_qr_code")
                    .foregroundColor(.red)
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

        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: 400, height: 400))
        return nsImage
    }
}


#Preview {
    QRCodeView(inputString: "I like to have a bananana split")
}


