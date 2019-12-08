//
//  ViewController.swift
//  FinalExam
//
//  Created by Mohammad Salamat on 2019-12-06.
//  Copyright © 2019 Mohammad Salamat. All rights reserved.
//

// This app was developed in two hours (our final exam). To me, this was an exercise on Google-fu and adapting
// mostly non-working code (Swift and XCode changes a lot, and fast) into working code in a short amount of time.
// Tested on 13.2 iPhone 11 Pro Max. Not constrained for most other devices.

// Slider code taken from: https://www.ioscreator.com/tutorials/slider-ios-tutorial
// Sound code taken from: https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
//                   and  https://codewithchris.com/avaudioplayer-tutorial/
// Vibrating code taken from: https://www.hackingwithswift.com/example-code/system/how-to-make-the-device-vibrate

// Can't really test the vibration since I only have the simulator, but I can see there are two ways being done (the one liner and doing extension and calling it with UIDevice.vibrate() as in link 4, so if what I did wouldn't work, I would just extend and do UIDevice.vibrate()

// Timer: https://learnappmaking.com/timer-swift-how-to/

// For infinite rotations (cause it's funny) https://stackoverflow.com/a/36684182
// But for the 360 rotation once, the code is taken from: https://stackoverflow.com/a/34102630

// Had a great time! It was my favourite course out of them all this term.

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var soundBtn: UIButton!
    @IBOutlet weak var vibrateBtn: UIButton!
    @IBOutlet weak var spinBtn: UIButton!
    
    @IBOutlet weak var startBtn: UIButton!
    
    var buttonsSet: [String: Bool] = [:]
    
    var pokerSound: AVAudioPlayer?
    
    var timer: Timer?
    
    var timeLeft: Int = 59
    var setTime: Int = 59
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        buttonsSet = [
                        "sound": false,
                        "vibrate": false,
                        "spin": false
                    ]
        
        soundBtn.backgroundColor = .gray
        vibrateBtn.backgroundColor = .gray
        spinBtn.backgroundColor = .gray
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        timeRemainingLabel.text = "\(currentValue)"
        setTime = currentValue
    }
    
    // MARK: Game feature buttons
    
    @IBAction func soundBtnTapped(_ sender: UIButton) {
        if buttonsSet["sound"] == false {
            buttonsSet["sound"] = true
            setButtonColour(btn: sender)
        } else {
            buttonsSet["sound"] = false
            unsetButtonColour(btn: sender)
        }
    }
    
    @IBAction func vibrateBtnTapped(_ sender: UIButton) {
        if buttonsSet["vibrate"] == false {
            buttonsSet["vibrate"] = true
            setButtonColour(btn: sender)
        } else {
            buttonsSet["vibrate"] = false
            unsetButtonColour(btn: sender)
        }
    }
    
    @IBAction func spinBtnTapped(_ sender: UIButton) {
        if buttonsSet["spin"] == false {
            buttonsSet["spin"] = true
            setButtonColour(btn: sender)
        } else {
            buttonsSet["spin"] = false
            unsetButtonColour(btn: sender)
        }
    }
    
    @IBAction func startBtnTapped(_ sender: UIButton) {
        disableClickables()
        
        timeLeft = Int(timeRemainingLabel.text!)!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    // MARK: Game features
    
    func spinPhone() {
        // (for infinite, if you want to laugh)
        // rotateView(targetView: view, duration: 3.0)
        
        // For (sanity) just once:
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }

        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
            self.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
    }
    
    func playSound() {
        let path = Bundle.main.path(forResource: "pokersound.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            pokerSound = try AVAudioPlayer(contentsOf: url)
            pokerSound?.play()
        } catch {
            print("sound error: \(error)")
        }
    }
    
    func vibratePhone() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    @objc func onTimerFires() {
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
        }
        
        if timeLeft == 0 {
            if buttonsSet["sound"] == true {
                playSound()
            }
            
            if buttonsSet["vibrate"] == true {
                vibratePhone()
            }
            
            if buttonsSet["spin"] == true {
                spinPhone()
            }
            
            enableClickables()
            timeRemainingLabel.text = "\(setTime)"
        } else {
            timeLeft -= 1
            timeRemainingLabel.text = "\(timeLeft)"
        }
    }
    
    // MARK: Helpers
    
    func setButtonColour(btn: UIButton) {
        btn.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    }
    
    func unsetButtonColour(btn: UIButton) {
        btn.backgroundColor = UIColor.gray
    }
    
    func disableClickables() {
        slider.isEnabled = false
        startBtn.isEnabled = false
        spinBtn.isEnabled = false
        vibrateBtn.isEnabled = false
        soundBtn.isEnabled = false
    }
    
    func enableClickables() {
        slider.isEnabled = true
        startBtn.isEnabled = true
        spinBtn.isEnabled = true
        vibrateBtn.isEnabled = true
        soundBtn.isEnabled = true
    }
    
    // MARK: - Funny function
    
    // This function is ONLY if you want infinite rotations
    func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
}
