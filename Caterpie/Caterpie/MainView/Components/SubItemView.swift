//
//  SubItemView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import SwiftUI

struct SubItemView: View {
    
    @State var item: MainMenueItem
    let others: [MainMenueItem]
    let cm = ColorManager.shared
    var indentation: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                ZStack{
                    HStack{
                        if item.subItems != nil {
                            Image(systemName: "chevron.forward.2")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .rotationEffect(.degrees(item.expande && item.subItems != nil ? 90 : 0))
                        }
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.black)
                    }.padding([.top,.leading],3)
                        .padding(.leading, indentation)
                    HStack{
                        if item.subItems != nil {
                            Image(systemName: "chevron.forward.2")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(item.expande ? cm.txtImportant : Color.white)
                                .rotationEffect(.degrees(item.expande ? 90 : 0))
                        }
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(item.expande ? cm.txtImportant : .white)
                    }.padding(.leading, indentation)
                }
                Spacer()
            }.padding(.leading)
             .padding(.vertical, 4)
             .background(item.expande ? cm.menueSubItemBG : cm.menueSubItemBGInversed)
             .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
             .padding(2)
             .background( ColorManager.shared.menueSubItemBGInversed)
             .cornerRadius(2)
             .onTapGesture {
                 ForEach(others, id:\.id){ other in
                     if item.id != other.id{
                         other.setExpandeFalse()
                     }
                 }
                 item.expande.toggle()
             }
            if item.subItems != nil && item.expande{
                ForEach(item.subItems!, id: \.id){
                    SubItemView(item: $0, others: item.subItems!, indentation: (self.indentation + 20))
                }
            }
        }
    }
    
    
    
}

#Preview {
    SubItemView(item: MainMenueItem(name: "Settings", subItems: [
        MainMenueItem(name: "Printer", subItems: nil, destination: BTDeviceChoiceView())
    
    ], destination: nil), others: [])
}
