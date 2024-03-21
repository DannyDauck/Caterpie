//
//  Store.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation

struct Store: Codable{
    
    let id: UUID
    var name: String
    let adresse: Adresse
    var phone: String = ""
    let taxIdentificationNumber: String
    var btPrinters: [String] = []
    
    var employees: [Employee] = []
    var stock: [Article] = []
    var products: [Product] = []

    var gonepterixDevices: [GonepterixDevice]

}
