//
//  RegisterInformationView.swift
//  Caterpie
//
//  Created by Danny Dauck on 20.03.24.
//

import SwiftUI

struct RegisterInformationView: View {
    
    let cm = ColorManager.shared
    @EnvironmentObject var vm: RegisterFlowViewmodel
    @State var pressed  = false
    let am = AudioManager()
    
    var body: some View {
        VStack{
            Text("tt_register_info")
            Button(action: {
                am.play(.click)
                vm.registerFlowIndex += 1
            }){
                Text("tt_weiter")
                    .font(.title2)
                    .background(cm.btnBgInactive)
                    .padding(2)
                    .background(pressed ? cm.btnBgActive : cm.btnBgInactive)
                    .foregroundStyle(pressed ? .white : cm.txtImportant)
                    .onTapGesture {
                        pressed = true
                    }
            }
        }
    }
}

#Preview {
    RegisterInformationView()
}
