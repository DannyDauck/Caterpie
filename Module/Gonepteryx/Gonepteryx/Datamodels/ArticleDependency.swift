//
//  ArticleDependency.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation

struct ArticleDependency: Codable{
    
    let article: Article
    var amount: Float
    var unit: Measurement
    
}
