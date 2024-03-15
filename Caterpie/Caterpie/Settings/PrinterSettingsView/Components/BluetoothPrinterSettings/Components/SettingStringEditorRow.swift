//
//  SettingStringEditorRow.swift
//  Caterpie
//
//  Created by Danny Dauck on 13.03.24.
//

import SwiftUI

struct SettingStringEditorRow: View {
    
    var name: LocalizedStringKey
    @Binding var value: String
    @State var isExpanded = false
    
    var body: some View {
        VStack{
            HStack{
                Text(name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.right.2")
                    .font(.title3)
                    .fontWeight(.bold)
                    .rotationEffect(.degrees( isExpanded ?  90 : 0))
            }
            .onTapGesture {
                withAnimation(.easeIn){
                    isExpanded.toggle()
                }
            }
            if isExpanded {
                TextEditor(text: $value)
                    .frame(height: 200)
            }
            Divider()
        }.padding()
    }
}

#Preview {
    SettingStringEditorRow(name: "Image print command", value: .constant("PRINT BITMAP"))
        .frame(height: 400)
}
