//
//  ViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var loginWithEmailLabel: UIButton!
    
    var player: AVPlayer?

    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWithEmailLabel.layer.borderColor = UIColor.white.cgColor
        playBackgroundVideo()
        navigationController?.navigationBar.barStyle = .black
        
        
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as? String)
        if (username != nil) {
            if (username! != "") {
                let darkModeOnOff = UserDefaults.standard.bool(forKey: "\(username!)DarkModeSetting")
                let delegate = UIApplication.shared.windows.first
                
                if (darkModeOnOff) {
                    delegate?.overrideUserInterfaceStyle = .dark
                }
                
                else {
                    delegate?.overrideUserInterfaceStyle = .light
                }
                
                performSegue(withIdentifier: "straightToHome", sender: nil)
            }
        }
        
        else {
            print("username is nil")
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layoutIfNeeded()

    }
    
    // MARK: - VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        player!.pause()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        player!.play()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    

    func playBackgroundVideo() {
        let path = Bundle.main.path(forResource: "project", ofType: ".mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}




// MARK: - EXTENSION
extension UIView {
    func addBottomBorderLineWithColor(width: CGFloat) {
        let bottomBorderLine = CALayer()
        bottomBorderLine.backgroundColor = UIColor.label.cgColor
        bottomBorderLine.frame = CGRect(x: 0, y: self.frame.size.height - 2.0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(bottomBorderLine)
    }
}



extension UIViewController {
    func hideKeyboardWHenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}




extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
