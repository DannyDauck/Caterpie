//
//  RegisterGoneptherixView.swift
//  Caterpie
//
//  Created by Danny Dauck on 18.03.24.
//

import SwiftUI

struct RegisterGonepterixView: View {
    @EnvironmentObject var vm: RegisterFlowViewmodel
    @State var qrcView: QRCodeView? = nil
    @State var remainingSeconds: String = ""
    
    var body: some View {
        VStack{
            Text("tt_register_a_gonepterix_device")
                .font(.title)
                .padding(.bottom, 40)
            Text("tt_reg_gd_info")
            if qrcView != nil{
                qrcView
            }
            Button(action: {
                qrcView = vm.openRegisterChannel()
            }, label: {
                Text("tt_open_register_channel")
            })
        }
    }
    
    private func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            remainingSeconds -= 1
            
            // Überprüfe, ob die Zeit abgelaufen ist
            if remainingSeconds <= 0 {
                // Timer ist abgelaufen, stoppe den Timer und führe die entsprechenden Aktionen aus
                timer?.invalidate()
                print("Timer abgelaufen nach 5 Minuten")
            }
        }
    }
}

struct RegisterGonepterixView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterGonepterixView()
    }
}
