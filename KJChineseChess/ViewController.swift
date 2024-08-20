//
//  ViewController.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit

class ViewController: UIViewController {

    var titleLabel = UILabel()
    var startGame: UIButton!
    var musicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        installUI()
        
        //读取用户音频设置状态
        if KJUserInfoManager.getAudioState() {
            musicButton.setTitle("音乐:开", for: .normal)
            //进行音频播放
            KJMusicEngine.sharedInstance.playBackgroundMusic()
        } else {
            musicButton.setTitle("音乐:关", for: .normal)
            //停止音频播放
            KJMusicEngine.sharedInstance.stopBackgroundMusic()
        }
    }

    func installUI() {
        
        let bgImage = UIImageView(image: UIImage(named: "bgImage"))
        bgImage.frame = self.view.frame
        self.view.addSubview(bgImage)
        
        titleLabel.frame = CGRect(x: self.view.frame.size.width/2-100, y: 200, width: 200, height: 60)
        titleLabel.text = "🇨🇳中国象棋"
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.textColor = UIColor.red
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        startGame = UIButton(type: .system)
        startGame?.frame = CGRect(x: self.view.frame.size.width/2-50, y: 380, width: 100, height: 30)
        startGame?.backgroundColor = UIColor.green
        startGame?.setTitle("开始游戏", for: .normal)
        startGame?.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(startGame!)
        startGame?.addTarget(self, action: #selector(startGameClick), for:
 .touchUpInside)
    
        musicButton = UIButton(type: .system)
        musicButton?.frame = CGRect(x: self.view.frame.size.width/2-50, y: 430, width: 100, height: 30)
        musicButton?.backgroundColor = UIColor.green
        musicButton?.setTitle("音乐:关", for: .normal)
        musicButton?.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(musicButton!)
        musicButton?.addTarget(self, action: #selector(musicButtonClick), for:
 .touchUpInside)
        
    }
    
    @objc func startGameClick(_ sender: Any) {
        let gameController = KJGameViewController()
        gameController.modalPresentationStyle = .overFullScreen
        self.present(gameController, animated: true, completion: nil)
    }

    @objc func musicButtonClick(_ sender: Any) {
        if KJUserInfoManager.getAudioState() {
            musicButton.setTitle("音乐:关", for: .normal)
            KJUserInfoManager.setAudioState(isOn:false)
            KJMusicEngine.sharedInstance.stopBackgroundMusic()
        } else {
            musicButton.setTitle("音乐:开", for: .normal)
            KJUserInfoManager.setAudioState(isOn:true)
            KJMusicEngine.sharedInstance.playBackgroundMusic()
        }
    }
}

