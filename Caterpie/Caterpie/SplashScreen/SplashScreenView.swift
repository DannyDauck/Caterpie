//
//  SplashScreenView.swift
//  Caterpie
//
//  Created by Danny Dauck on 15.03.24.
//

import SwiftUI
import AVKit

struct SplashScreenView: View {
    @State private var isVideoFinished = false
    @State var vm = SignInViewViewModel()
    @EnvironmentObject var mainVm: MainScreenViewModel
    
    init(){
        
    }
    let player = AVPlayer(url: Bundle.main.url(forResource: "SplashScreenCaterpie", withExtension: "mp4")!)
        
        var body: some View {
            ZStack {
                
                
                if isVideoFinished {
                    
                    /*  Logik zum überprüfen ob register, login oder mainScreen
                    switch mainVm.logState {
                    case .logged:
                        MainScreenView()
                    case .unregisterd:
                        SignInScreenView(signInVm: vm)
                    case .loggedWithoutFinishingRegistration:
                        RegisterFlowView()
                            .environmentObject(RegisterFlowViewmodel(id: mainVm.fbUser!.id))
                        
                        
                        //    */        MainScreenView()
                        
                    }else{
                    
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
                        }.frame(height: 200)
                            .foregroundStyle(.black)
                            .background(.black)
                    }
                    
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
