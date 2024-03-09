//
//  SubItemView.swift
//  Caterpie
//
//  Created by Danny Dauck on 07.03.24.
//

import SwiftUI

struct SubItemView: View {
    
    @State var item: MainMenueItem
    let cm = ColorManager.shared
    var indentation: CGFloat = 20
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
                                .foregroundStyle(selected ? cm.txtImportant : Color.white)
                                .rotationEffect(.degrees(item.expande ? 90 : 0))
                        }
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(selected ? cm.txtImportant : .white)
                    }.padding(.leading, indentation)
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
                            .foregroundStyle(selected ? LinearGradient(colors: [cm.txtImportant, .white, cm.txtImportant, cm.txtImportant], startPoint: .bottomLeading, endPoint: .topTrailing) : cm.menueSubItemBGInversed)
                    }
                }
            }.padding(.leading)
                .padding(.vertical, 4)
                .background(selected ? cm.menueSubItemBG : cm.menueSubItemBGInversed)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                .padding(2)
                .background( ColorManager.shared.menueSubItemBGInversed)
                .cornerRadius(2)
                .onTapGesture {
                    withAnimation(.easeIn){
                        item.expande.toggle()
                        if let destination = item.destination{
                            vm.currentViewIndex = destination
                        }
                        am.play(.click)
                    }
                    
                }.padding(selected ? 1 : 0)
            if item.subItems != nil && item.expande{
                ForEach(item.subItems!, id: \.id){
                    SubItemView(item: $0, indentation: (self.indentation + 20))
                }
                
            }
        }
    }
    
    
    
}

#Preview {
    SubItemView(item: MainMenueItem(name: "Settings", subItems: [
        MainMenueItem(name: "Printer", destination: 1, symbol: "printer.fill")
    ], symbol: "gear"))
}
