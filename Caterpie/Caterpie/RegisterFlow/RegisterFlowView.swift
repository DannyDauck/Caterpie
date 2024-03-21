//
//  RegisterFlowView.swift
//  Caterpie
//
//  Created by Danny Dauck on 18.03.24.
//

import SwiftUI

struct RegisterFlowView: View {
    
    @EnvironmentObject var vm: RegisterFlowViewmodel
    
    var body: some View {
        TabView(selection: $vm.registerFlowIndex){
            RegisterInformationView()
                .tag(0)
            GeneralRegisterdataView()
                .tag(1)
            RegisterGonepterixView()
                .tag(2)
        }
    }
}

#Preview {
    RegisterFlowView()
}
