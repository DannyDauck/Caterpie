//
//  AudioManager.swift
//  Caterpie
//
//  Created by Danny Dauck on 08.03.24.
//

import Foundation
import AudioToolbox


class AudioManager{
    enum Sound: String{
        case click = "button_click"
        case trash = "clear_trash"
    }
    
    
    func play(_ sound: Sound){
        guard let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else { return }
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}
