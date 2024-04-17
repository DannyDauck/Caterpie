//
//  GonepteryxChip.swift
//  Caterpie
//
//  Created by Danny Dauck on 16.04.24.
//

import SwiftUI

struct GonepteryxChip: View {
    var body: some View {
        VStack{
            HStack{
                Text("Device 1")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }.frame(width: 300)
                .background(.black)
            HStack{
                Text("Benutzer")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                Spacer()
            }
            HStack{
                Text("Danny")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                Spacer()
            }
            Divider()
            HStack{
                Text("Umsazt")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.black)
                Spacer()
            }
            HStack{
                Text("Bar")
                    .foregroundStyle(.black)
                Spacer()
                Text("918,30€")
                    .foregroundStyle(.black)
                
            }
            HStack{
                Text("EC")
                    .foregroundStyle(.black)
                Spacer()
                Text("350,-€")
                    .foregroundStyle(.black)
            }
            HStack{
                Text("sonsitge")
                    .foregroundStyle(.black)
                Spacer()
                Text("25,-€")
                    .foregroundStyle(.black)
            }
            Divider()
                .foregroundStyle(.black)
            HStack{
                Spacer()
                Text("1288,30€")
                    .foregroundStyle(.black)
            }
            Divider()
                .foregroundStyle(.black)
            HStack{
                Text("offene Tische")
                    .foregroundStyle(.black)
                Spacer()
            }
            HStack{
                Spacer()
                Text("218,70€")
                    .foregroundStyle(.black)
            }
            
        }.frame(width: 300)
            .background(LinearGradient(colors: [.gray, .white], startPoint: .bottomTrailing, endPoint: .topLeading))
            .cornerRadius(8.0)
            .padding()
    }
}

#Preview {
    GonepteryxChip()
}
