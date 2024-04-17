//
//  AnalyzeView.swift
//  Caterpie
//
//  Created by Danny Dauck on 08.03.24.
//

import SwiftUI

struct OverviewView: View {
    var body: some View {
        VStack{
            HStack{
                GonepteryxChip()
                Spacer()
            }
            Spacer()
        }.background(.black.opacity(0.4))
    }
}

#Preview {
    OverviewView()
}
