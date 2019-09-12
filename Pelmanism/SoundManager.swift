//
//  SoundManager.swift
//  Pelmanism
//
//  Created by JFJ on 12/09/2019.
//  Copyright © 2019 JFJ. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFilename = ""
        
        // Determine which sound effect we want to play
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
        default:
            soundFilename = ""
        }
        //Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav" )
        
        guard bundlePath != nil else {
            print ("Couldn't find the soundfile \(soundFilename) in the bundle")
            return
        }
        
        //Create a URL object from this string path
        
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        //Create audio player object
        do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
        } catch {
            //Couldn't create Audio Player Object
            
            print("Couldn't create audio player object for soundfile \(soundFilename)" )
        }
        
    }
}
