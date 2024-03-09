//
//  MainScreenViewModel.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import Foundation
import SwiftUI

class MainScreenViewModel: ObservableObject{
    
    @Published var menueItems: [MainMenueItem] = []
    var currentUser: Employee?
    @Published var currentViewIndex: Float = 0
    
    
    init(user: Employee){
        currentUser = user
        createMenue()
    }
    init(){
        currentUser =  nil
        createMenue()
    }
    
    func createMenue(){
        // because View is not equatable, I got to use the index to compare which view is currently shown
        // To create MainMenueItem entries orientate at the switch case in MainScreenView
        
        
        //Overview -> main destination 1
        var overview = MainMenueItem(name: "tt_h1_overview", destination: 1, symbol: nil)
        menueItems.append(overview)
        
        
        
        //Settings -> main destination 2
        if userHasPermission(.settings){
            var settings = MainMenueItem(name: "tt_settings", subItems: [], symbol: "gear")
            if userHasPermission(.peripheralSettings){
                var item = MainMenueItem(name: "tt_h1_printer", destination: 2.1, symbol: "printer.fill")
                settings.subItems?.append(item)
            }
            if userHasPermission(.themeSettings){
                var item = MainMenueItem(name: "tt_h1_appearance", destination: 2.2, symbol: "paintbrush.fill")
                settings.subItems?.append(item)
            }
            menueItems.append(settings)
        }
    }
    
    func userHasPermission(_ permission: Permission) -> Bool{
        if let user = currentUser{
           return user.permissions.contains(permission)
        }
        else{
            return false
        }
    }
}
