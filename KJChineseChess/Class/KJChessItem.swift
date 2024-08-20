//
//  KJChessItem.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit

class KJChessItem: UIButton {
    //这个属性标记棋子的选中状态
    var selectedState:Bool = false
    //这个属性标记是否为红方棋子
    var isRed = true
    
    //提供一个自定义的构造方法
    init(center:CGPoint) {
        //根据屏幕尺寸决定棋子大小
        let screenSize = UIScreen.main.bounds.size
        let itemSize = CGSize(width: (screenSize.width-40)/9-4, height: (screenSize.width-40)/9-4)
        super.init(frame: CGRect(origin: CGPoint(x: center.x-itemSize.width/2, y: center.y-itemSize.width/2), size: itemSize))
        installUI()
    }
    
    //进行棋子UI的设计
    func installUI()  {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = ((UIScreen.main.bounds.size.width-40) / 9 - 4)/2
        self.layer.borderWidth = 0.5
    }
    //设置棋子标题 isOwn属性决定是己方或敌方
    func setTitle(title:String,isOwn:Bool) {
        self.setTitle(title, for: .normal)
        if isOwn {
            self.layer.borderColor = UIColor.red.cgColor
            self.setTitleColor(UIColor.red, for: .normal)
            self.isRed = true
        } else {
            self.layer.borderColor = UIColor.green.cgColor
            self.setTitleColor(UIColor.green, for: .normal)
            //敌方的棋子要进行180度旋转
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.isRed = false
        }
    }
    //将棋子设置为选中状态
    func setSelectedState() {
        if !selectedState {
            selectedState = true
            self.backgroundColor = UIColor.purple
        }
    }
    //将棋子设置为非选中状态
    func setUnselectedState() {
        if selectedState {
            selectedState = false
            self.backgroundColor = UIColor.white
        }
    }
    
    //必要构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

