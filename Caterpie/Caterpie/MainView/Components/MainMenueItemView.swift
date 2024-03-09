//
//  MainMenueItemView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import SwiftUI

struct MainMenueItemView: View {
    
    @State var item: MainMenueItem
    let cm = ColorManager.shared
    @EnvironmentObject var vm: MainScreenViewModel
    private let am = AudioManager()
    private var selected: Bool{
        
        guard let subItems = item.subItems else{
            if item.destination == vm.currentViewIndex{
                return true
            }else{
                return false
            }
        }
        
        return subItems.contains(where: {
            $0.destination == vm.currentViewIndex
        })
    }
    
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                ZStack{
                    HStack{
                        Image(systemName: "chevron.forward.2")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .rotationEffect(.degrees(item.expande && item.subItems != nil ? 90 : 0))
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.black)
                    }.padding([.top,.leading],3)
                    HStack{
                        Image(systemName: "chevron.forward.2")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(selected ? cm.txtImportant : Color.white)
                            .rotationEffect(.degrees(item.expande && item.subItems != nil ? 90 : 0))
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(selected ? cm.txtImportant : .white)
                    }
                }
                Spacer()
                if let symbole = item.symbol{
                    ZStack{
                        Image(systemName: symbole)
                            .font(.title2)
                            .foregroundStyle(.black)
                            .padding([.top, .leading], 2)
                        Image(systemName: symbole)
                            .font(.title2)
                            .foregroundStyle(selected ? LinearGradient(colors: [cm.txtImportant, .white, cm.txtImportant], startPoint: .bottomLeading, endPoint: .topTrailing) : cm.menueSubItemBGInversed)
                    }
                }
            }.padding(.leading)
                .padding(.vertical, 4)
                .background(item.expande || selected ? cm.btnBgActive : cm.btnBgInactive)
                .cornerRadius(5)
                .padding(2)
                .background( ColorManager.shared.btnBgInactive)
                .cornerRadius(6)
                .onTapGesture {
                    withAnimation(.easeIn){
                        if item.subItems != nil {
                            item.expande.toggle()
                        }else{
                            vm.currentViewIndex = item.destination!
                        }
                    }
                    am.play(.click)
                }.padding(selected ? 1 : 0)
            if item.subItems != nil && item.expande{
                ForEach(item.subItems!, id: \.id){
                    SubItemView(item: $0, indentation: 20)
                }
            }
        }
    }
}

#Preview {
    MainMenueItemView(item: MainMenueItem(name: "Settings", subItems: [
        MainMenueItem(name: "Printer", destination: 1, symbol: "printer.fill")
        
    ], symbol: "gear"))
}
