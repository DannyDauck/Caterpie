//
//  ImageSettingsViewViewmodel.swift
//  Caterpie
//
//  Created by Danny Dauck on 13.03.24.
//

import Foundation
import Cocoa

class ImageSettingsViewViewmodel: ObservableObject{
    
    @Published var selectedImage: NSImage?{
        didSet{
            convertImageToBlackAndWhite()
        }
    }
    @Published var blackAndWhiteImage: NSImage?
    @Published var isImagePickerPresented = false
    @Published var threshold: Float = 1.0{
        didSet{
            convertImageToBlackAndWhite()
        }
    }
    @Published var settingsIsVisible = false
    @Published var inverted = false{
        didSet{
            convertImageToBlackAndWhite()
        }
    }
    
    
    func convertImageToBlackAndWhite(){
        guard let selectedImage else{
            return
        }
        if let bwImgData = ImageConverter().getBlackAndWhiteImage(NSBitmapImageRep(data: selectedImage.tiffRepresentation!)!, threshold: threshold, inverted: inverted){
            if let newBwImage = ImageConverter().bitmapImageRepToNSImage(bwImgData){
                blackAndWhiteImage = newBwImage
            }
        }
    }
}
