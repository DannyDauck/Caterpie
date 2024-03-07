//
//  ContentView.swift
//  Caterpie
//
//  Created by Danny Dauck on 29.02.24.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        VStack{
            
            HStack {
                QRCodeView(inputString: "I'd like to have a banana split")
                BTDeviceChoiceView()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
