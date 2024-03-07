//
//  CaterpieApp.swift
//  Caterpie
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI

@main
struct CaterpieApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreenView(vm: MainScreenViewModel(user: Employee(permissions: Permission.allCases)))
        }
    }
}
