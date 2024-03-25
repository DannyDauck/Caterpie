//
//  GonepteryxApp.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI
import FirebaseCore

@main
struct GonepteryxApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        
        
        WindowGroup {
            SplashScreenView()
        }
    }
}
