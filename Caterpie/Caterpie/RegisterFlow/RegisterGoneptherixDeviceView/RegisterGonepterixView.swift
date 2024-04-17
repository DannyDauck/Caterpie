//
//  RegisterGoneptherixView.swift
//  Caterpie
//
//  Created by Danny Dauck on 18.03.24.
//

import SwiftUI

struct RegisterGonepterixView: View {
    @EnvironmentObject var vm: RegisterFlowViewmodel
    @State var remainingSeconds = 300
    
    var body: some View {
        VStack{
            Text("tt_register_a_gonepterix_device")
                .font(.title)
                .padding(.bottom, 40)
            Text("tt_reg_gd_info")
            if vm.qrcView != nil{
                vm.qrcView
                Text(vm.timerTxt)
                    .font(.title2)
                    .foregroundStyle(ColorManager.shared.txtImportant)
            }
            Button(action: {
                vm.openRegisterChannel()
            }, label: {
                Text("tt_open_register_channel")
            })
        }
    }
}

struct RegisterGonepterixView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterGonepterixView()
    }
}
