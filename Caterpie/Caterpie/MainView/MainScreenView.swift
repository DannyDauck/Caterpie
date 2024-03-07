//
//  MainScreenView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import SwiftUI

struct MainScreenView: View {
    
    let cm = ColorManager.shared
    @ObservedObject var vm: MainScreenViewModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                ZStack{
                    Text("Caterpie")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 12)
                        .padding(.top, 5)
                        .foregroundStyle(.gray)
                    Text("Caterpie")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 10)
                        .padding(.vertical, 3)
                        .foregroundStyle(.white)
                }
                Spacer()
            }.background(.black)
            GeometryReader{geo in
                HStack(spacing: 0){
                    VStack(spacing: 0){
                        ForEach(vm.menueItems, id:\.id){
                            MainMenueItemView(item: $0)
                        }
                        Spacer()
                    }.frame(width: geo.size.width / 4)
                    
                    BTDeviceChoiceView()
                }
            }
        }
    }
}

#Preview {
    MainScreenView(vm: MainScreenViewModel(user: Employee(permissions: Permission.allCases)))
}
