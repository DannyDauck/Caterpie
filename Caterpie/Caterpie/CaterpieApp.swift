//
//  CaterpieApp.swift
//  Caterpie
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI
import FirebaseCore

@main
struct CaterpieApp: App {
    @State var vm = MainScreenViewModel()
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(vm)
             
        }
    }
}


