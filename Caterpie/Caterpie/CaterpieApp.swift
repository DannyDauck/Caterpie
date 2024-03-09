//
//  CaterpieApp.swift
//  Caterpie
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI

@main
struct CaterpieApp: App {
    
    @State var vm = MainScreenViewModel(user: Employee(permissions: Permission.allCases))
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environmentObject(vm)
        }
    }
}
