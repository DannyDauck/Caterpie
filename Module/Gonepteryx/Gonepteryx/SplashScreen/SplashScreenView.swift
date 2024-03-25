//
//  SplashScreenView.swift
//  Gonepteryx
//
//  Created by Danny Dauck on 20.03.24.
//

import SwiftUI
import AVKit

struct SplashScreenView: View {
    @State private var isVideoFinished = false
    
    init(){
        
    }
    let player = AVPlayer(url: Bundle.main.url(forResource: "SplashScreenVideo", withExtension: "mp4")!)
        
        var body: some View {
            ZStack {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
                            isVideoFinished = true
                        }
                    }
                    .onDisappear {
                        NotificationCenter.default.removeObserver(self)
                    }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                    }.frame(height: 50)
                        .foregroundStyle(.black)
                        .background(.black)
                }
                
                if isVideoFinished {
                   RegisterDeviceScreenView()
                }
            }
            .onAppear {
                player.play()
            }
            .edgesIgnoringSafeArea(.all)
        }
}

#Preview {
    SplashScreenView()
}

