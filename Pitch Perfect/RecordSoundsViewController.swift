//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Marky Jordan on 3/10/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    func configureUI(isRecording: Bool) {
        if isRecording == true {
            recordingLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        } else {
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    // MARK: Actions
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playsoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playsoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

