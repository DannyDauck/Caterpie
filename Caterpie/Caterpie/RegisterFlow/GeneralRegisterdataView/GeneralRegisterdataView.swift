//
//  GeneralRegisterdataView.swift
//  Caterpie
//
//  Created by Danny Dauck on 20.03.24.
//

import SwiftUI

struct GeneralRegisterdataView: View {
    
    @EnvironmentObject var vm: RegisterFlowViewmodel
    let cm = ColorManager.shared
    let am = AudioManager()
    @State var pressed = false
    
    var body: some View {
        VStack{
            HStack{
                Text("tt_general_settings")
                    .font(.title)
                Spacer()
            }
            
            HStack{
                Text("tt_user_info")
                    .font(.title2)
                Spacer()
            }
            
            HStack{
                Text("tt_name")
                    .fontWeight(.bold)
                    .frame(width: 150)
                TextField("tt_name", text: $vm.name)
                    .background(Color.gray.opacity(0.4))
            }
            
            HStack{
                Text("tt_adresse")
                    .fontWeight(.bold)
                    .frame(width: 150)
                Spacer()
            }
            
            HStack{
                TextField("tt_street", text: $vm.userStreet)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                TextField("tt_postalcode", text: $vm.userPostalCode)
                    .background(Color.gray.opacity(0.4))
                TextField("tt_city", text: $vm.userCity)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                TextField("tt_phone", text: $vm.userPhone)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                Text("tt_company_info")
                    .font(.title2)
                Spacer()
            }
            
            HStack{
                Text("tt_company_name")
                    .fontWeight(.bold)
                    .frame(width: 150)
                TextField("tt_company_name", text: $vm.companyName)
                    .background(Color.gray.opacity(0.4))
            }
            
            HStack{
                Text("tt_adresse")
                    .fontWeight(.bold)
                    .frame(width: 150)
                Spacer()
            }
            
            HStack{
                TextField("tt_street", text: $vm.companyStreet)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                TextField("tt_postalcode", text: $vm.companyPostalCode)
                    .background(Color.gray.opacity(0.4))
                TextField("tt_city", text: $vm.companyCity)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                Text("tt_store_info")
                    .font(.title2)
                Spacer()
            }
            
            HStack{
                Text("tt_store_name")
                    .fontWeight(.bold)
                    .frame(width: 150)
                TextField("tt_store_name", text: $vm.storeName)
                    .background(Color.gray.opacity(0.4))
            }
            
            HStack{
                Text("tt_adresse")
                    .fontWeight(.bold)
                    .frame(width: 150)
                Spacer()
            }
            
            HStack{
                
                TextField("tt_street", text: $vm.storeStreet)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                TextField("tt_postalcode", text: $vm.storePostalCode)
                    .background(Color.gray.opacity(0.4))
                TextField("tt_city", text: $vm.storeCity)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                TextField("tt_phone", text: $vm.phone)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            HStack{
                TextField("tt_tax_id", text: $vm.taxIdentificationNumber)
                    .background(Color.gray.opacity(0.4))
                Spacer()
            }
            
            Button(action: {
                am.play(.click)
                vm.writeUserToFirebase()
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
            
        }.padding()
            .frame(width: 400)
    }
}

#Preview {
    GeneralRegisterdataView()
}
