//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Hariom Palkar on 28/04/20.
//  Copyright © 2020 Hariom Palkar. All rights reserved.

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    // Adding links to connect to main.storyboard
    
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionLabel.text = "Tap to start recording"
    }
    // Disabling the stop button when view loads and the nav bar
    override func viewWillAppear(_ animated: Bool) {
        //hide nav bar on recording controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        stopRecording.isEnabled = false
    }
    //Showing the nav bar item when when next view appear's
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    // Recording Button Tapped
    @IBAction func recordingButtonTapped(_ sender: Any) {
       configureUI(RecordingState.recording)
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
    // Stop Recording Button Tapped
    @IBAction func stopButtonTapped(_ sender: Any) {
        configureUI(RecordingState.notRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    enum RecordingState {
       case  recording
      case notRecording
    }

    func  configureUI(_ recordingState: RecordingState) {
         switch recordingState {
               case .recording:
          stopRecording.isEnabled = true
          recordingButton.isEnabled = false
            instructionLabel.text = "Recording your audio...."
            
               case .notRecording:
         stopRecording.isEnabled = false
          recordingButton.isEnabled = true
         instructionLabel.text = "Tap to start recording"
    }
    }

    // Performing the navigation after the audio is recorded successfully
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "goToSecondVC", sender: audioRecorder.url)
        }
        else{
            print("Failed to record and send!")
        }
    }
    // Passing the file URL to the next viewController
      override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondVC" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}


