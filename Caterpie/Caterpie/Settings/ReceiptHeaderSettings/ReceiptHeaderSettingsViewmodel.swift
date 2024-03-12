//
//  ReceiptHeaderSettingsViewmodel.swift
//  Caterpie
//
//  Created by Danny Dauck on 12.03.24.
//

import Foundation

class ReceiptHeaderSettingsViewmodel: ObservableObject{
    
    enum HeaderType{
        case txtheader, imageHeader
    }
    
    @Published var headerType: HeaderType = .txtheader
    
}
