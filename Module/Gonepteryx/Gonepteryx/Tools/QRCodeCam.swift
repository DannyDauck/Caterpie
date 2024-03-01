//
//  QRCCam.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI
import UIKit
import AVFoundation

//Verwendung zusammen mit QRC ScannerView!!!!

struct QRCCam: View {
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var qrCodeContent: String?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                Button("QR Code auslesen") {
                    qrCodeContent = readQRCode(from: image)
                }
                if let qrCodeContent = qrCodeContent {
                    Text("QR Code Inhalt: \(qrCodeContent)")
                }
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
