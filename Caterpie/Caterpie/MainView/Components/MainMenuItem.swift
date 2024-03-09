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
    let destination: Float?
    let symbol: String?
    var expande: Bool = false
    
    
    //locks the initializer to make sure that only items with whether subItems or a destination are instantiated
    private init(name: LocalizedStringKey, subItems: [MainMenueItem]? = nil, destination: Float?, symbol: String?, expande: Bool) {
        self.name = name
        self.subItems = subItems
        self.destination = destination
        self.symbol = symbol
        self.expande = expande
    }
    
    init(name: LocalizedStringKey, destination: Float, symbol: String?) {
        self.name = name
        self.subItems = nil
        self.destination = destination
        self.symbol = symbol
        self.expande = false
    }
    
    init(name: LocalizedStringKey, subItems: [MainMenueItem], symbol: String?) {
        self.name = name
        self.subItems = subItems
        self.destination = nil
        self.symbol = symbol
        self.expande = false
    }
    
    
    
    
    mutating func toggleExpande(){
        self.expande.toggle()
    }
    mutating func setExpandeFalse(){
        self.expande = false
    }
}
