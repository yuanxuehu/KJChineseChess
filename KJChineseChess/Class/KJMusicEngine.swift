//
//  KJMusicEngine.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit
import AVFoundation

class KJMusicEngine: NSObject {
    //音频引擎单例
    static let sharedInstance = KJMusicEngine()
    //音频播放器
    var player:AVAudioPlayer?
    
    private override init() {
        //获取音频文件 forResource参数为工程中的音频文件名 需要为mp3格式
        let path = Bundle.main.path(forResource: "bgMusic", ofType: "mp3")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        player = try! AVAudioPlayer(data: data)
        //进行音频的预加载
        player?.prepareToPlay()
        //设置音频循环播放次数
        player?.numberOfLoops = -1
    }
    
    //提供一个开始播放背景音频的方法
    func playBackgroundMusic() {
        //如果音频没有在播放 再进行播放
        if !player!.isPlaying {
            player?.play()
        }
        
    }
    
    //提供一个停止播放背景音频的方法
    func stopBackgroundMusic() {
        //如果音频正在播放 再进行停止
        if player!.isPlaying {
             player?.stop()
        }
    }
}

