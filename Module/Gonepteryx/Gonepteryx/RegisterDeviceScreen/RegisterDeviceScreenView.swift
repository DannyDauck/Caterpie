//
//  RegisterDeviceScreenView.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 23.03.24.
//

import SwiftUI

struct RegisterDeviceScreenView: View {
    var body: some View {
        VStack{
            Text("Scanne den Code auf Caterpie Bildschirm, um dein Gerät bei Caterpie anzumelden und dem laden zuzuweisen:")
            QRCCam()
            
        }
        
    }
}

#Preview {
    RegisterDeviceScreenView()
}
