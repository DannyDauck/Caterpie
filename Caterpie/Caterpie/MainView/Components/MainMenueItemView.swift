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
                            .foregroundStyle(item.expande ? cm.txtImportant : Color.white)
                            .rotationEffect(.degrees(item.expande ? 90 : 0))
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(item.expande ? cm.txtImportant : .white)
                    }
                }
                Spacer()
            }.padding(.leading)
             .padding(.vertical, 4)
             .background(item.expande ? cm.btnBgActive : cm.btnBgInactive)
             .cornerRadius(5)
             .padding(2)
             .background( ColorManager.shared.btnBgInactive)
             .cornerRadius(6)
             .onTapGesture {
                if item.subItems != nil {
                    item.expande.toggle()
                }
            }
            if item.subItems != nil && item.expande{
                ForEach(item.subItems!, id: \.id){item in
                    SubItemView(item: item, others: item.subItems!)
                }
            }
        }
    }
    
}

#Preview {
    MainMenueItemView(item: MainMenueItem(name: "Settings", subItems: [
        MainMenueItem(name: "Printer", subItems: nil, destination: BTDeviceChoiceView())
    
    ], destination: nil))
}
