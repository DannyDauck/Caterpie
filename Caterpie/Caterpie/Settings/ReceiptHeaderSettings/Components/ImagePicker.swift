//
//  ImagePicker.swift
//  Caterpie
//
//  Created by Danny Dauck on 12.03.24.
//

import SwiftUI
import AppKit

struct ImagePicker: NSViewControllerRepresentable {
    @Binding var image: NSImage?

    class Coordinator: NSObject, NSOpenSavePanelDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func panel(_ sender: Any, didChangeToDirectoryURL url: URL?) {}

        func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeNSViewController(context: Context) -> NSViewController {
        let viewController = NSViewController()
        viewController.view = NSView() // Leere Ansicht, da das NSOpenPanel als Modalfenster erscheint
        DispatchQueue.main.async {
            let picker = NSOpenPanel()
            picker.delegate = context.coordinator
            picker.allowsMultipleSelection = false
            picker.canChooseFiles = true
            picker.canChooseDirectories = false
            picker.allowedContentTypes = [.jpeg, .png]
            picker.begin { response in
                if response == .OK {
                    if let url = picker.urls.first {
                        if let image = NSImage(contentsOf: url) {
                            self.image = image
                        }
                    }
                }
            }
        }
        return viewController
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}

    func makeNSView(context: Context) -> NSView {
        return NSView() // Leere Ansicht, da das NSOpenPanel als Modalfenster erscheint
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}








#Preview {
    ImagePicker(image: .constant(NSImage(resource: .minionBanana)))
}
