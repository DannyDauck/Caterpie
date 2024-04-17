//
//  RegisterDeviceScreenViewmodel.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 23.03.24.
//

import Foundation


class RegisterDeviceScreenViewmodel: ObservableObject{
    
    private let repo = RemoteDatabankRepository()
    
    
    func registerDvice(_ inputString: String){
        do{
            try repo.registerDevice(inputString)
            
        }catch{
            print("Could not write data to FireStore")
        }
        
    }
}
