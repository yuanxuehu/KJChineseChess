//
//  KJGameViewController.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit

class KJGameViewController: UIViewController, KJGameEngineDelegate {
    //棋盘
    var chessBoard:KJChessBoard?
    //游戏引擎
    var gameEngine:KJGameEngine?
    
    //退出游戏按钮
    var stopGameButton:UIButton?
    //开始游戏按钮
    var startGameButton:UIButton?
    //切换先手方按钮
    var settingButton:UIButton?
    //胜负提示
    var tipLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let bgImage = UIImageView(image: UIImage(named: "gameBg"))
        bgImage.frame = self.view.frame
        self.view.addSubview(bgImage)
        //棋盘绘制
        chessBoard = KJChessBoard(origin: CGPoint(x: 20, y: 180))
        self.view.addSubview(chessBoard!)
        //进行游戏引擎的实例化
        gameEngine = KJGameEngine(board: chessBoard!)
        gameEngine!.delegate = self
       
        stopGameButton = UIButton(type: .system)
        stopGameButton?.frame = CGRect(x: 40, y: self.view.frame.size.height-160, width: self.view.frame.size.width/2-80, height: 30)
        stopGameButton?.backgroundColor = UIColor.green
        stopGameButton?.setTitle("退出游戏", for: .normal)
        stopGameButton?.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(stopGameButton!)
        stopGameButton?.addTarget(self, action: #selector(stopGame), for:
 .touchUpInside)
        
        startGameButton = UIButton(type: .system)
        startGameButton?.frame = CGRect(x: 40, y: self.view.frame.size.height-80, width: self.view.frame.size.width/2-80, height: 30)
        startGameButton?.backgroundColor = UIColor.green
        startGameButton?.setTitle("开始游戏", for: .normal)
        startGameButton?.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(startGameButton!)
        startGameButton?.addTarget(self, action: #selector(startGame), for:
.touchUpInside)
       
        settingButton = UIButton(type: .system)
        settingButton?.frame = CGRect(x: self.view.frame.size.width/2+40, y: self.view.frame.size.height-80, width: self.view.frame.size.width/2-80, height: 30)
        settingButton?.setTitle("红方行棋", for: .normal)
        settingButton?.backgroundColor = UIColor.gray
        settingButton?.isEnabled = false
        settingButton?.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(settingButton!)
        settingButton?.addTarget(self, action: #selector(settingGame), for:
.touchUpInside)
       
        tipLabel.frame = CGRect(x: self.view.frame.size.width/2-100, y: 200, width: 200, height: 60)
        tipLabel.backgroundColor = UIColor.clear
        tipLabel.font = UIFont.systemFont(ofSize: 25)
        tipLabel.textColor = UIColor.red
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        self.view.addSubview(tipLabel)
   }
    
    @objc func stopGame(btn:UIButton) {
        self.dismiss(animated: true)
    }
    @objc func startGame(btn:UIButton) {
        tipLabel.isHidden = true
        gameEngine?.startGame()
        //更新UI状态
        settingButtonEnable(enable: false)
        btn.setTitle("重新开局", for: .normal)
    }
    @objc func settingGame(btn:UIButton){
        if btn.title(for: .normal)=="红方行棋" {
            gameEngine?.setRedFirstMove(red: false)
            btn.setTitle("绿方行棋", for: .normal)
        } else {
            gameEngine?.setRedFirstMove(red: true)
            btn.setTitle("红方行棋", for: .normal)
        }
    }
    
    func gameOver(redWin:Bool){
        if redWin {
            tipLabel.text = "红方胜"
            tipLabel.textColor = UIColor.red
        }else{
            tipLabel.text = "绿方胜"
            tipLabel.textColor = UIColor.green
        }
        tipLabel.isHidden = false
        //更新UI状态
        settingButtonEnable(enable: false)
    }
    
    
    func settingButtonEnable(enable: Bool) {
        if enable {
            settingButton?.backgroundColor = UIColor.green
            settingButton?.isEnabled = true
        } else {
            settingButton?.backgroundColor = UIColor.gray
            settingButton?.isEnabled = false
        }
    }
    
    func couldRedMove(red: Bool) {
        if red {
            settingButton?.setTitle("红方行棋", for: .normal)
        } else {
            settingButton?.setTitle("绿方行棋", for: .normal)
        }
        //更新UI状态
        settingButtonEnable(enable: gameEngine?.isStarting ?? false)
        startGameButton?.setTitle("重新开局", for: .normal)
    }
}
