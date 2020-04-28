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
    override func viewWillAppear(_ animated: Bool) {
        //hide nav bar on tecording controller
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
        stopRecording.isEnabled = false
    }
   override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func recordingButtonTapped(_ sender: Any) {
        recordButoonTapped()
        
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopButtonTapped()
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "goToSecond", sender: audioRecorder.url)
        }
        else{
            print("Failed to record and send!")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecond" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    // function to enable and decable buttons when tapped.
    func recordButoonTapped() {
        stopRecording.isEnabled = true
        instructionLabel.text = "Recording your audio...."
        recordingButton.isEnabled = false
    }
    func stopButtonTapped() {
        recordingButton.isEnabled = true
        instructionLabel.text = "Tap to start recording"
        stopRecording.isEnabled = false
    }
    
}
