//
//  MainScreenViewModel.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import Foundation

class MainScreenViewModel: ObservableObject{
    
    @Published var menueItems: [MainMenueItem] = []
    var currentUser: Employee?
    
    init(user: Employee){
        currentUser = user
        createMenue()
    }
    init(){
        currentUser =  nil
        createMenue()
    }
    
    func createMenue(){
        //Settings
        if userHasPermission(.settings){
            var settings = MainMenueItem(name: "tt_settings", subItems: [], destination: nil)
            if userHasPermission(.peripheralSettings){
                var item = MainMenueItem(name: "tt_h1_printer", subItems: nil, destination: PrinterSettingsView())
                settings.subItems?.append(item)
            }
            if userHasPermission(.themeSettings){
                var item = MainMenueItem(name: "tt_h1_appearance", subItems: nil, destination: AppearanceSettingsView())
                settings.subItems?.append(item)
            }
            
            menueItems.append(settings)
            
        }
    }
    
    func userHasPermission(_ permission: Permission) -> Bool{
        if let user = currentUser{
           return currentUser!.permissions.contains(permission)
        }
        else{
            return false
        }
    }
}
