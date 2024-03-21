//
//  User.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//


import Foundation

struct User: Codable, Identifiable{
    
    let id: String
    let firstName: String
    let lastName: String
    var adresse: Adresse
    let companyName: String
    var stores: [Store]
    
}
