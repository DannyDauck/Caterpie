//
//  File.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import Foundation
import SwiftUI


struct MainMenueItem: Observable{
    
    let id: UUID = UUID()
    let name: LocalizedStringKey
    var subItems: [MainMenueItem]?
    let destination: (any View)?
    var expande: Bool = false
    
    
    mutating func toggleExpande(){
        self.expande.toggle()
    }
    mutating func setExpandeFalse(){
        self.expande = false
    }
}
