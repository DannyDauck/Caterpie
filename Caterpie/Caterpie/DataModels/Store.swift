//
//  Store.swift
//  Caterpie
//
//  Created by Danny Dauck on 15.03.24.
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
    
    init(id: UUID, name: String, adresse: Adresse, phone: String, taxIdentificationNumber: String, btPrinters: [String], employees: Employee) {
        self.id = id
        self.name = name
        self.adresse = adresse
        self.phone = phone
        self.taxIdentificationNumber = taxIdentificationNumber
        self.btPrinters = []
        self.employees = [employees]
        self.stock = []
        self.products = []
        self.gonepterixDevices = []
    }

}
