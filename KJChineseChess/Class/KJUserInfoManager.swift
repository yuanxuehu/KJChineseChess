//
//  KJUserInfoManager.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit

class KJUserInfoManager: NSObject {
    //获取用户音频设置状态
    class func getAudioState() -> Bool {
        let isOn = UserDefaults.standard.string(forKey: "audioKey")
        if let on = isOn {
            if on == "on" {
                return true
            }
        }
        return false
    }
    
    //进行用户音频设置状态的存储
    class func setAudioState(isOn:Bool) {
        if isOn {
            UserDefaults.standard.set("on", forKey: "audioKey")
        } else {
            UserDefaults.standard.set("off", forKey: "audioKey")
        }
        UserDefaults.standard.synchronize()
    }
}

