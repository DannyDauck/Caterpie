//
//  RegisterFlowViewmodel.swift
//  Caterpie
//
//  Created by Danny Dauck on 20.03.24.
//

import Foundation


class RegisterFlowViewmodel: ObservableObject{
    
    let id: String //firebase user id
    @Published var storeID: String = ""
    @Published var name: String = ""
    @Published var userStreet: String = ""
    @Published var userPostalCode: String = ""
    @Published var userCity: String = ""
    @Published var userPhone: String = ""
    @Published var companyName: String = ""
    @Published var companyStreet: String = ""
    @Published var companyPostalCode: String = ""
    @Published var companyCity: String = ""
    @Published var storeName: String = ""
    @Published var storeStreet: String = ""
    @Published var storePostalCode: String = ""
    @Published var storeCity: String = ""
    @Published var storePhone: String = ""
    @Published var phone: String = ""
    @Published var taxIdentificationNumber: String = ""
    @Published var btPrinters: [String] = []
    @Published var registerFlowIndex = 0
    @Published var registerDeviceChannelIsOpen = false
    @Published var qrcView: QRCodeView? = nil
    @Published var timer = 300
    @Published var timerTxt = ""
    @Published var firstStoreID = UUID().uuidString
    var schedule: Timer? = nil
    private var user: User?
    let repo = RemoteRepository.shared
    
    
    var employees: [Employee] = []
    var stock: [Article] = []
    var products: [Product] = []

    var gonepterixDevices: [GonepterixDevice] = []
    
    init(id: String) {
        self.id = id
    }
    
    func writeUserToFirebase(){
        let owner  = Employee(id: id, name: name, adresse: Adresse(street: userStreet, postalCode: userPostalCode, city: userCity))
        let store = Store(id: UUID(), name: storeName, adresse: Adresse(street: storeStreet, postalCode: storePostalCode, city: storeCity), phone: storePhone, taxIdentificationNumber: taxIdentificationNumber, btPrinters: [], employees: owner)
        let newUser = User(id, companyName: companyName, companyStreet: companyStreet, companyPostalCode: companyPostalCode, companyCity: companyCity, userName: name, userStreet: userStreet, userPostalcode: userPostalCode, userCity: userCity, store: store)
        repo.upsertUser(newUser)
        user = newUser
    }
    
    func openRegisterChannel(){
        registerDeviceChannelIsOpen = true
        qrcView =  repo.openRegisterDeviceChannel(storeID: firstStoreID)
        
        schedule = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            self.timer -= 1
            self.timerTxt = self.timer%60<10  ? "\(self.timer/60):0\(self.timer % 60)" : "\(self.timer/60):\(self.timer % 60)"
            if self.timer == 0{
                self.qrcView = nil
                self.schedule?.invalidate()
                self.timer = 300
            }
        }
        
        
    }
}
