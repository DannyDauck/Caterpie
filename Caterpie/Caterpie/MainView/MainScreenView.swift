//
//  MainScreenView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import SwiftUI

struct MainScreenView: View {
    
    let cm = ColorManager.shared
    @EnvironmentObject var vm: MainScreenViewModel
    
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
                ZStack{
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 12)
                        .padding(.top, 5)
                        .foregroundStyle(.gray)
                    
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 10)
                        .padding(.vertical, 3)
                        .foregroundStyle(.white)
                }.padding(.trailing, 10)
                    .onTapGesture {
                        vm.logOutFromFirebase()
                        
                    }
            }.background(.black)
            Divider()
            GeometryReader{geo in
                HStack(spacing: 0){
                    VStack(spacing: 0){
                        ForEach(vm.menueItems, id:\.id){
                            MainMenueItemView(item: $0)
                        }
                        Spacer()
                    }.frame(width: geo.size.width / 4)
                    
                    
                    /*
                    The SwitchCase represents the user's selection which is shown in the middle of the screen, similar to a TabView but oriented sideways. For
                    clarity, I have decided to include
                    a Float as a destination in the MainMenuItem, so that a chapter-like structure can be seen in the program code. This means that each whole
                    number represents a menu item that has no subcategories, and each floating-point number represents the subcategory of the selected item. For a
                    more detailed structure, please refer to the createMenu function in the MainScreenViewModel.
                     
                     And since a Float is sometimes misinterpreted by the compiler, the destination is always been asked from the MainMenueItem and selectes per
                     default the OverView,  This eliminates the possibility of potential errors arising from the limited
                     range of Float values.
                     */
                    
                    switch vm.currentViewIndex{
                        
                    case 1 : OverviewView()
                        
                    case 2.1 : PrinterSettingsView()
                    case 2.2 : AppearanceSettingsView()
                    case 2.3 : ReceiptHeaderSettingsView()
                        
                    default:
                        OverviewView()
                    }
                }
            }
        }
    }
}

#Preview {
    MainScreenView()
}
