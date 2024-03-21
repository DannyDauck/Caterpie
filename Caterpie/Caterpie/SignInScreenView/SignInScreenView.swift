//
//  SignInScreenView.swift
//  Caterpie
//
//  Created by Danny Dauck on 15.03.24.
//

import SwiftUI


struct SignInScreenView: View {
    
    @ObservedObject var signInVm: SignInViewViewModel
    @EnvironmentObject var mainVm: MainScreenViewModel
    let cm = ColorManager.shared
    let am = AudioManager()
    
    var body: some View {
    
        VStack{
            HStack{
                Text("Log in")
                    .font(.title2)
                    .frame(width: 200, height: 50)
                    .background( cm.btnBgInactive)
                    .padding(!signInVm.register ? 2 :0)
                    .background(!signInVm.register ? cm.btnBgActive : cm.btnBgInactive)
                    .foregroundStyle(!signInVm.register ? cm.txtImportant : .white)
                    .onTapGesture {
                        signInVm.register = false
                        am.play(.click)
                    }
                Text("Sign up")
                    .font(.title2)
                    .frame(width: 200, height: 50)
                    .background( cm.btnBgInactive)
                    .padding(signInVm.register ? 2 :0)
                    .background(signInVm.register ? cm.btnBgActive : cm.btnBgInactive)
                    .foregroundStyle(signInVm.register ? cm.txtImportant : .white)
                    .onTapGesture {
                        signInVm.register = true
                        am.play(.click)
                    }
            }
            Spacer()
            HStack{
                Text("Email")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
            }.frame(width: 200)
            TextField("Email", text: $signInVm.email)
                .textFieldStyle(.roundedBorder)
                .frame(width: 192)
                .background(Color.gray.opacity(0.4))
                .padding(4)
                .background(cm.btnBgInactive)
                .cornerRadius(8)
            
            SecureField("tt_password", text: $signInVm.password)
                .textFieldStyle(.roundedBorder)
                .frame(width: 192)
                .foregroundStyle(cm.txtImportant)
                .background(Color.gray.opacity(0.4))
                .padding(4)
                .background(cm.btnBgInactive)
                .cornerRadius(8)
                
            if signInVm.register{
                
                SecureField("tt_repeat_password", text: $signInVm.repeatPassword)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 192)
                    .foregroundStyle(cm.txtImportant)
                    .background(Color.gray.opacity(0.4))
                    .padding(4)
                    .background(cm.btnBgInactive)
                    .cornerRadius(8)
            }
            Button(action:{
                signInVm.signInWithEmail(){success, id in
                    if success{
                        if let userId = id{
                            mainVm.createEmptyFbUser(id!)
                        }
                    }
                }
                
            }){
                Text("tt_sign_in_with_email")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(width: 190, height: 40)
                    .cornerRadius(12)
            }.buttonStyle(.borderedProminent)
            if !signInVm.passwordCheckText.isEmpty{
                Text(signInVm.passwordCheckText)
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(cm.exceptionGradient)
            }
            
            Divider()
            Spacer()
        }
    }
}

#Preview {
    SignInScreenView(signInVm: SignInViewViewModel())
}
