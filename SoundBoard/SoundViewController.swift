//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by mbtec22 on 4/22/21.
//  Copyright © 2021 Tecsup. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var audioRecorder: AVAudioRecorder?
    
    var audioURL : URL?
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
            print("*******************")
            print(audioURL!)
            print("*******************")
            var settings : [String: AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        }catch let error as NSError {
            print(error)
        }
    }

    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording{
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else {
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    
    
    @IBAction func playTapped(_ sender: Any) {
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }catch{}
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        let context	= (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context:context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
}
