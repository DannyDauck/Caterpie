//
//  PrinterManager.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 01.03.24.
//

import UIKit

class PrinterManager {
    static let shared = PrinterManager()
    
    private init() {}
    
    func printImage(_ image: UIImage) {
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.jobName = "MyPrintJob"
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printFormatter = ImageViewPrintFormatter(image: image)
        
        printController.present(animated: true, completionHandler: nil)
    }
}

class ImageViewPrintFormatter: UIPrintFormatter {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    override func draw(in printableRect: CGRect, forPageAt pageIndex: Int) {
        image.draw(in: printableRect)
    }
}






