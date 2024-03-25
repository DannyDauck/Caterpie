//
//  User.swift
//  Caterpie
//
//  Created by Danny Dauck on 15.03.24.
//

import Foundation

struct User: Codable, Identifiable{
    
    let id: String
    let companyName: String
    var adresse: Adresse
    var owner: Employee
    var stores: [Store]
    
    
    init(_ id: String, companyName: String, companyStreet: String, companyPostalCode: String, companyCity: String, userName: String, userStreet: String, userPostalcode: String, userCity: String, store: Store){
        self.id = id
        self.companyName = companyName
        self.adresse = Adresse(street: companyStreet, postalCode: companyPostalCode, city: companyCity)
        self.owner = Employee(id: id, name: userName, adresse: Adresse(street: userStreet, postalCode: userPostalcode, city: userCity), permissions: [])
        self.stores = [store]
    }
    
    init(_ id: String, companyName: String, companyStreet: String, companyPostalCode: String, companyCity: String, userName: String, userStreet: String, userPostalcode: String, userCity: String){
        self.id = id
        self.companyName = companyName
        self.adresse = Adresse(street: companyStreet, postalCode: companyPostalCode, city: companyCity)
        self.owner = Employee(id: id, name: userName, adresse: Adresse(street: userStreet, postalCode: userPostalcode, city: userCity), permissions: [])
        self.stores = []
    }
}
