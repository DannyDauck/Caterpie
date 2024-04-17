//
//  RemoteDatabankRepository.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class RemoteDatabankRepository{
    
    static let shared = RemoteDatabankRepository()
    private var auth = FirebaseAuth.Auth.auth()
    var userName = ""
    var userPassword = ""
    var storeID = ""
    
    let store = Firestore.firestore()
    
    func signIn(email: String, password: String) async throws{
        do{
            try await auth.signIn(withEmail: email, password: password)
        }catch{
            print(error)
        }
    }
    
    
    
    
    
}
