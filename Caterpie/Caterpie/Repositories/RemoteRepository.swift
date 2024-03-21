//
//  RemoteRepository.swift
//  Caterpie
//
//  Created by Danny Dauck on 15.03.24.
//
//  46871334704-9gpsarhoc8h7ohur122hrvmk43dbuefg.apps.googleusercontent.com


import Foundation
import FirebaseAuth
import FirebaseFirestore

class RemoteRepository{
    
    static let shared = RemoteRepository()
    
    
    var auth = FirebaseAuth.Auth.auth()
    let store = Firestore.firestore()
    
    private init(){}
    
    @discardableResult
    func createUserWithEmail(email: String, password: String) async throws -> String{
        do{
            let user = try await auth.createUser(withEmail: email, password: password)
            print(">>>>>>>>>>>>>>>>>>>")
            print(auth.currentUser?.uid)
        }catch{
            print(">>>>error:\(error)")
        }
        return auth.currentUser!.uid
    }
    
    @discardableResult
    func getUser(email: String, password: String) async throws -> String{
        do{
            let user = try await auth.signIn(withEmail: email, password: password)
        }catch{
            print(error)
        }
        return auth.currentUser!.uid
    }
    
    func writeUser(_ user: User){
        do{
            try store.collection("caterpieUsers").document(user.id).setData(from: user)
        }catch{
            print("something went wrong while writing user")
        }
    }
    
    
    
    func logOutUser() async throws{
        
        if auth.currentUser != nil{
            try auth.signOut()
        }
    }
    
    func openRegisterDeviceChannel(storeID: String) -> QRCodeView{
        let requestID = UUID().uuidString
        guard let userID = auth.currentUser?.uid else {
            return QRCodeView(inputString: "I'd like to have a banana split")
        }
        try store.collection("caterpieUsers").document(userID).collection("deviceRequest").document(requestID).setData(["level":false])
        
        var requestAccept = false
        let ref = store.collection("caterpieUsers").document(userID).collection("deviceRequest").document(requestID)
        let listener = ref.addSnapshotListener{
            snapshot, error in
            
            guard let document = snapshot else {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let level = document.data()?["level"] as? Bool else {
                print("Document data was empty.")
                return
            }
            //delete requestChannel if Gonepterix device recognize
            if level{
                ref.delete()
                requestAccept = true
            }
        }
        //delete channel if no Gonepterix device recognize after 5 minutes
        DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
            if !requestAccept{
                listener.remove()
                ref.delete()
            }
        }
        
        return QRCodeView(inputString: "user:\(userID),request:\(requestID),storeID:\(storeID)")
    }
    
    func upsertUser(_ user: User){
        do{
            try store.collection("caterpieUsers").document(user.id).setData(from: user)
        }catch{
            print("couldn't write user to firestore: \(error)")
        }
        
    }
    
}
