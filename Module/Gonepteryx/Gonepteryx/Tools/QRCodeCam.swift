//
//  QRCCam.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI
import UIKit
import AVFoundation
import CoreImage.CIFilterBuiltins

//Verwendung zusammen mit QRC ScannerView!!!!

struct QRCCam: View {
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var qrCodeContent: String?
    @State var vm = RegisterDeviceScreenViewmodel()

    var body: some View {
        VStack {
            if let image = image {
                    
                    Button(action: {
                        qrCodeContent = readQRCode(from: image) ?? "I'd like to have a bananasplit"
                        vm.registerDvice(qrCodeContent!)
                    }){
                        Text("Jetzt Gerät hinzufügen")
                            .background(Capsule()
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Capsule()
                                .foregroundStyle(LinearGradient(colors: [.white, .gray], startPoint: .bottomLeading, endPoint: .topTrailing)))
                            .shadow(radius: 4)
                    }.buttonStyle(.borderedProminent)
            } else {
                Button("Kamera öffnen") {
                    showingImagePicker.toggle()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            qrCodeContent = readQRCode(from: image!)
        }) {
            ImagePicker(image: $image)
        }
        .padding()
    }

    func readQRCode(from image: UIImage) -> String? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options) else { return nil }
        let features = detector.features(in: ciImage)

        for feature in features {
            if let qrCodeFeature = feature as? CIQRCodeFeature {
                return qrCodeFeature.messageString
                
                
            }
        }
        return nil
    }
    
    func generateQRCodeImage(_ qrCodeString: String) -> UIImage? {

        let data = Data(qrCodeString.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        guard let outputImage = filter.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
    
    func saveToLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?

        init(image: Binding<UIImage?>) {
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        
        //hier kann in .photoLibrary geändert werden um auf die Galerie statt die Kamera zuzugreifen
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct QRCCam_Previews: PreviewProvider {
    static var previews: some View {
        QRCCam()
    }
}
