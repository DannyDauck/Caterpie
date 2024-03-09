//
//  ColorManager.swift
//  Caterpie
//
//  Created by Danny Dauck on 06.03.24.
//

import Foundation
import SwiftUI

class ColorManager: ObservableObject{
    
    static let shared = ColorManager()
    
    private init(){}
    
    var foregroundActive = LinearGradient(colors: [.green, .indigo], startPoint: .bottomLeading, endPoint: .topTrailing)
    var symbolActive = Color.green
    
    var btnBgInactive = LinearGradient(colors: [.gray, .black], startPoint: .bottomLeading, endPoint: .topTrailing)
    var btnBgActive = LinearGradient(colors: [.black, .gray], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var txtImportant = Color.yellow
    
    var shadow = Color.white
    var linearShadow = LinearGradient(colors: [.white, .black], startPoint: .leading, endPoint: .trailing)
    
    var menueSubItemBG = LinearGradient(colors: [.white, .gray], startPoint: .bottomLeading, endPoint: .topTrailing)
    var menueSubItemBGInversed = LinearGradient(colors: [.gray, .white], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var exceptionGradient = LinearGradient(colors: [.red, .red, .orange, .white, .red], startPoint: .bottomLeading, endPoint: .topTrailing)
    
}
