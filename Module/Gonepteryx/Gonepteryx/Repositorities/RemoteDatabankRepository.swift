//
//  RemoteDatabankRepository.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation
import FirebaseFirestore

class RemoteDatabankRepository{
    
    let store = Firestore.firestore()
    
    func registerDevice(_ qrcString: String) throws{
        let components = qrcString.components(separatedBy: ",")
        var userID = ""
        var request = ""
        var storeID = ""
        for component in components{
            let keyValue = component.components(separatedBy: ":")
            if keyValue.count == 2 {
                let key = keyValue[0]
                let value = keyValue[1]
                switch key {
                case "user":
                    userID = value
                case "request":
                    request = value
                case "storeID":
                    storeID = value
                default:
                    break
                }
            }
        }
        let gonepteryxDevice = GonepterixDevice()
        getUser(userID){user, error in
            if let error{
                return
            }
            
            if user != nil {
                var caterpieUser = user
                if var userStore = caterpieUser!.stores.first(where: { $0.id.uuidString == storeID }) {
                    userStore.gonepterixDevices.append(gonepteryxDevice)
                    if let index = caterpieUser!.stores.firstIndex(where: { $0.id.uuidString == storeID }) {
                        caterpieUser!.stores[index] = userStore
                        do{
                            try self.store.collection("caterpieUsers").document(userID).setData(from: caterpieUser)
                            try self.store.collection("caterpieUsers").document(userID).collection("deviceRequest").document(request).setData(["level":true])
                        }catch{
                            print("could not update store")
                        }
                    }
                }
            }
        }
    }
    
    func getUser(_ id: String, completion: @escaping (User?, Error?) -> Void) {
        let ref = store.collection("caterpieUsers").document(id)
        
        ref.getDocument { document, error in
            if let error = error {
                print("Fehler beim Abrufen des Benutzers: \(error.localizedDescription)")
                completion(nil, error)
            } else if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    print("Benutzer erfolgreich abgerufen: \(user)")
                    completion(user, nil)
                    
                } catch {
                    print("Fehler beim Decodieren des Benutzers: \(error)")
                    completion(nil, error)
                }
            } else {
                print("Benutzerdokument nicht gefunden oder existiert nicht")
                completion(nil, nil)
            }
        }
    }
    
    
    
}
