//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Nihal Erdal on 9/28/20.
//  Copyright © 2020 Nihal Erdal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordbutton: UIButton!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        
        stopButton.isEnabled = false
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordbutton.isEnabled = false
        stopButton.isEnabled = true
        recordingLabel.text = "Recording in Progress"
        
        //AVAudioRecorder icin
        //dosya olusturuyoruz
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
      
        
        
        //creating session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        stopButton.isEnabled = false
        recordbutton.isEnabled = true
        recordingLabel.text = "Tap to Record"
        
        //to stop the audio
        audioRecorder.stop()
        
        //session i durdurmak icin yeni session yaratip inactive yapiyorum.
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier:"stopRecording"  , sender: audioRecorder.url)
        }else {
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "stopRecording"  {
               let playSoundsVC = segue.destination as! PlaySoundsViewController
               let recordedAudioURL = sender as! URL 
               playSoundsVC.recordedAudioURL = recordedAudioURL
           }
       }

}
