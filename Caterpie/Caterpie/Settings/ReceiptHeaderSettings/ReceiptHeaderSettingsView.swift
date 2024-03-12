//
//  ReceiptHeaderSettingsView.swift
//  Caterpie
//
//  Created by Danny Dauck on 12.03.24.
//

import SwiftUI

struct ReceiptHeaderSettingsView: View {
    
    @ObservedObject var vm = ReceiptHeaderSettingsViewmodel()
    @State var type : ReceiptHeaderSettingsViewmodel.HeaderType = .txtheader
    
    
    var body: some View {
        VStack{
            HStack{
                Text("tt_h1_receipt_header_settings")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.leading, 10)
                    .padding(.vertical, 5)
                Spacer()
            }.background(.black)
            
            Picker("", selection: $type){
                Text("tt_text_header")
                    .tag(ReceiptHeaderSettingsViewmodel.HeaderType.txtheader)
                Text("tt_image_header")
                    .tag(ReceiptHeaderSettingsViewmodel.HeaderType.imageHeader)
            }.pickerStyle(.segmented)
            
            switch type {
            case .txtheader:
                TextHeaderSettingsView()
            case .imageHeader:
                ImageHeaderSettingsView()
            }
            Spacer()
        }
    }
}

#Preview {
    ReceiptHeaderSettingsView()
}
