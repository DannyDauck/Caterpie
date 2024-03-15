//
//  ImageConverter.swift
//  Caterpie
//
//  Created by Danny Dauck on 11.03.24.
//

import Foundation
import Cocoa

class ImageConverter{
    
    @Published var array: [UInt8] = []
    func getPrinterImage(_ image: NSImage, dpi: Int, rollSizeMM: Int, indentationMM: Int) -> NSBitmapImageRep?{
        
        guard let sizedBitmap = scaleToPrinterSize(dpi: dpi, rollWidthMM: rollSizeMM, indentationMM: indentationMM, image: image) else {
            print("tt_war_could_not_scale_img")
            return nil
        }
        
        guard getBlackAndWhiteImage(sizedBitmap) != nil else {
            print("tt_could_not_convert_black_and_white")
            return nil
        }
        
        return sizedBitmap
    }
    
    func getDarkestValue(_ image: NSBitmapImageRep) -> UInt8?{
        guard let bitmapData = image.bitmapData else {
            return nil
        }
        
        var darkestValue: UInt8 = 0 //first set it to absolut white
        
        // Iterate trough each
        for j in 0..<image.pixelsHigh {
            for i in 0..<image.pixelsWide {
                let pixelOffset = (j * image.bytesPerRow) + (i * image.samplesPerPixel)
                
                let r = bitmapData[pixelOffset]
                let g = bitmapData[pixelOffset + 1]
                let b = bitmapData[pixelOffset + 2]
                
                let darkestPixelValue = min(r, g, b)
                
                if darkestPixelValue > darkestValue {
                    darkestValue = darkestPixelValue
                }
            }
        }
        
        return darkestValue
    }
    
    func getBlackAndWhiteImage(_ image: NSBitmapImageRep, threshold: Float = 1.0, inverted: Bool = false) -> NSBitmapImageRep? {
        guard let darkestPixValue = getDarkestValue(image) else {
            print("get darkest value failed")
            return nil
        }
        

        // Erstelle ein Data-Objekt, um die Bilddaten für das Schwarz-Weiß-Bild zu speichern
        var imageData : [[UInt8]] = []
        array = []

        // Iteriere durch jeden Pixel im Originalbild und berechne die Helligkeit
        for i in 0..<image.pixelsHigh {
            var row: [UInt8] = []
            for j in 0..<image.pixelsWide {
                let pixelOffset = (i * image.bytesPerRow) + (j * image.samplesPerPixel)

                let r = Int(image.bitmapData?[pixelOffset] ?? 0)
                let g = Int(image.bitmapData?[pixelOffset + 1] ?? 0)
                let b = Int(image.bitmapData?[pixelOffset + 2] ?? 0)

                let sum = r + b + g
                let black: UInt8 = inverted ? 0xFF : 0x00
                let white: UInt8 = inverted ? 0x00 : 0xFF
                if let brightness = UInt8(exactly: sum/3){
                    row.append(brightness < UInt8(Int(Float(darkestPixValue) * threshold/2)) ? black : white)
                } else {
                    print("tt_err_failed_to_calculate_brighness")
                    continue
                }
                
            }
            imageData.append(row)
        }
        
        var newPrintCommand = [UInt8]("BITMAP 0,0,76,\(imageData.count),1,".utf8)
        array = newPrintCommand
        
        
        guard let newImage = createBitmapFromUInt8Array(imageData) else {
           print("failed to get image from data")
            return nil
        }
        
        
        return newImage
    }


    
    func scaleToPrinterSize(dpi: Int, rollWidthMM: Int, indentationMM: Int, image: NSImage) -> NSBitmapImageRep?{
        
        //25.4 for inch to millimeters
        let rollWidth = CGFloat(rollWidthMM) * CGFloat(dpi) / 25.4
        let maxWidth = rollWidth - CGFloat(indentationMM) * CGFloat(dpi) / 25.4
        
        
        let scale = maxWidth / image.size.width
        let newWidth = image.size.width * scale
        let newHeight = image.size.height * scale
        
        // target size
        let targetRect = NSRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("tt_err_could_not_create_cg_image")
            return nil
        }
        
        let rep = NSBitmapImageRep(cgImage: cgImage)
        
        guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                      pixelsWide: Int(newWidth),
                                      pixelsHigh: Int(newHeight),
                                      bitsPerSample: rep.bitsPerSample,
                                      samplesPerPixel: rep.samplesPerPixel,
                                      hasAlpha: rep.hasAlpha,
                                      isPlanar: rep.isPlanar,
                                      colorSpaceName: rep.colorSpaceName,
                                      bytesPerRow: 0,
                                      bitsPerPixel: 0)
        else{
            print("bitmap is nil")
            return nil
        }
        
        bitmap.size = targetRect.size
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        
        // Zeichne das Bild in den skalierten Kontext
        let rect = NSRect(x: 0, y: 0, width: newWidth, height: newHeight)
        image.draw(in: rect)
        
        NSGraphicsContext.restoreGraphicsState()
        
        return bitmap
    }
    
    func bitmapImageRepToNSImage(_ bitmapImageRep: NSBitmapImageRep) -> NSImage? {
        let image = NSImage(size: NSSize(width: bitmapImageRep.pixelsWide, height: bitmapImageRep.pixelsHigh))
        image.addRepresentation(bitmapImageRep)
        
        return image
    }
    
    
    func createBitmapFromUInt8Array(_ data: [[UInt8]]) -> NSBitmapImageRep? {
        
        guard !data.isEmpty, !data[0].isEmpty else { return nil }
        
        let width = data[0].count //width anhand der Größe des ersten Arrays in data bestimmen
        let height = data.count  // Höhe anhand der rows, also der Anzahl an Arrays bestimmen die in getBlackAndWhiteImage hinzugefügt werden bestimmen
        
        
        
        guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                            pixelsWide: width,
                                            pixelsHigh: height,
                                            bitsPerSample: 8,
                                            samplesPerPixel: 1,
                                            hasAlpha: false,
                                            isPlanar: false,
                                            colorSpaceName: .deviceWhite,
                                            bytesPerRow: width,
                                            bitsPerPixel: 8) else {
            return nil
        }
        
        for row in 0..<height {
                for pixel in 0..<width {
                    let pixelValue = data[row][pixel]
                    bitmap.bitmapData?[row * width + pixel] = pixelValue
                }
            }
        print(bitmap.size.width)
        print(bitmap.size.height)
        return bitmap
    }

    
}

    
