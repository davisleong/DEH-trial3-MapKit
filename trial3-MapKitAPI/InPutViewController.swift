//
//  InPutViewController.swift
//  trial3-MapKitAPI
//
//  Created by DavisLeong on 2016/4/23.
//  Copyright © 2016年 DavisLeong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class InPutViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var playSound: UIButton!
    @IBOutlet weak var stopRecording: UIButton!

    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var newLongitude : String = ""
    var newLatitude : String = ""
    var playing = 1
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    override func viewDidLoad() {
        longitudeLabel.text = newLongitude
        latitudeLabel.text = newLatitude
        stopRecording.enabled = false
        playSound.enabled = false
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))){
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let fullPathUrl = NSURL(fileURLWithPath: documentsDirectory).URLByAppendingPathComponent("voiceRecording.caf")
                    
                    let settings : [String :AnyObject] = [
                        AVFormatIDKey:Int(kAudioFormatAppleIMA4),
                        AVSampleRateKey:44100.0,
                        AVNumberOfChannelsKey:2,
                        AVEncoderBitRateKey:12800,
                        AVLinearPCMBitDepthKey:16,
                        AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
                    ]
                    
                    try! self.audioRecorder = AVAudioRecorder(URL: fullPathUrl, settings: settings)
                    self.audioRecorder.prepareToRecord()
                    
                }
            })
        }

    }
    @IBAction func recording(sender: AnyObject) {
        if (self.audioRecorder.recording == true){
            self.audioRecorder.pause()
            self.record.setTitle("Resume", forState: .Normal)
            self.playSound.setTitle("Play", forState: .Normal)
        }
        else if(self.audioRecorder.recording == false){
            self.playSound.enabled = false
            self.stopRecording.enabled = true
            self.record.setTitle("Pause", forState: .Normal)
            self.playSound.setTitle("Play", forState: .Normal)
            self.playSound.enabled = false
            self.audioRecorder.record()
            
        }
    }
    @IBAction func stopRecording(sender: AnyObject) {
        self.stopRecording.enabled = false
        self.playSound.enabled = true
        self.record.setTitle("Record", forState: .Normal)
        self.audioRecorder.stop()
        
        
    }
    @IBAction func playSound(sender: AnyObject) {
        
        if(audioRecorder.recording == false && playing == 1){
            try! audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
            self.record.setTitle("Record", forState: .Normal)
            self.playSound.setTitle("Stop", forState: .Normal)
            self.stopRecording.enabled = false
            self.playing = 0
            self.record.enabled = false
            audioPlayer?.delegate = self
            audioPlayer.play()
            
        }
        else if(audioPlayer.playing == true){
            audioPlayer.stop()
            self.playing = 1
            self.record.enabled = true
            self.playSound.setTitle("Play", forState: .Normal)
        }

    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.record.enabled = true
        self.playSound.setTitle("Play", forState: .Normal)
        self.playing = 1
    }
    
    @IBAction func goBackMainView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
}
