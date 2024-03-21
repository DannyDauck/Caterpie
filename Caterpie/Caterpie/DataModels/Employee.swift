//
//  Employee.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import Foundation

struct Employee: Codable{
    
    
    var id: String
    var permissions: [Permission] = []
    var name: String
    var adresse: Adresse
    
    init(id: String, name: String, adresse: Adresse, permissions: [Permission]){
        self.id = id
        self.name = name
        self.adresse = adresse
        self.permissions = permissions
    }
    
    init(id: String, name: String, adresse: Adresse){
        self.id = id
        self.name = name
        self.adresse = adresse
        self.permissions = []
    }
}
