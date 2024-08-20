//
//  KJChessBoard.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit

protocol KJChessBoardDelegate {
    //当用户点击某个棋子时触发的方法
    func chessItemClick(item:KJChessItem)
    //当棋子移动完成后触发的方法
    func chessMoveEnd()
    //结束游戏回调 参数如果传入true 代表红方胜利
    func gameOver(redWin:Bool)
}

class KJChessBoard: UIView {
    //代理
    var delegate:KJChessBoardDelegate?
    //棋盘上所有可以行棋的位置标记的实例数组
    var tipButtonArray = Array<KJTipButton>()
    //当前行棋的棋子可以前进的矩阵位置
    var currentCanMovePosition = Array<(Int,Int)>()
    //根据屏幕宽度计算网格大小
    let Width = (UIScreen.main.bounds.size.width-40)/9
    //红方所有棋子
    let allRedChessItemsName = ["車","馬","相","士","帥","士","相","馬","車","炮","炮","兵","兵","兵","兵","兵"]
    //绿方所有棋子
    let allGreenChessItemsName = ["车","马","象","仕","将","仕","象","马","车","炮","炮","卒","卒","卒","卒","卒"]
    //棋盘上所剩下的红方棋子对象
    var currentRedItem = Array<KJChessItem>()
    //棋盘上所剩下的绿方棋子对象
    var currentGreenItem = Array<KJChessItem>()
    
    init(origin:CGPoint) {
        //根据屏幕宽度计算棋盘宽度
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: UIScreen.main.bounds.size.width-40, height: Width*10))
        //设置棋盘背景色
        self.backgroundColor = UIColor(red: 1, green: 252/255.0, blue: 234/255.0, alpha: 1)
        //楚河汉界标签
        let label1 = UILabel(frame: CGRect(x: Width, y: Width*9/2, width: Width*3, height: Width))
        label1.backgroundColor = UIColor.clear
        label1.text = "楚河"
        let label2 = UILabel(frame: CGRect(x: Width*5, y: Width*9/2, width: Width*3, height: Width))
        label2.backgroundColor = UIColor.clear
        label2.text = "漢界"
        label2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.addSubview(label1)
        self.addSubview(label2)
        //进行游戏重置
        reStartGame()
    }
    
    func reStartGame() {
        //清理残局
        //清理所有提示点
        tipButtonArray.forEach { (item) in
            item.removeFromSuperview()
        }
        tipButtonArray.removeAll()
        //取消所有棋子的选中
        self.cancelAllSelect()
        
        currentGreenItem.forEach { (item) in
            item.removeFromSuperview()
        }
        currentRedItem.forEach { (item) in
            item.removeFromSuperview()
        }
        currentRedItem.removeAll()
        currentGreenItem.removeAll()
        //棋子布局
        var redItem:KJChessItem?
        var greenItem:KJChessItem?
        //红绿双方各有16个棋子
        for index in 0..<16 {
            if index<9 {    //进行非兵、非炮棋子的布局
                //红方布局
                redItem = KJChessItem(center: CGPoint(x: Width/2+Width * CGFloat(index), y: Width*10-Width/2))
                redItem!.setTitle(title: allRedChessItemsName[index], isOwn: true)
                //绿方布局
                greenItem = KJChessItem(center: CGPoint(x: Width/2+Width * CGFloat(index), y: Width/2))
                greenItem!.setTitle(title: allGreenChessItemsName[index], isOwn: false)
            } else if index<11 {   //进行炮棋子的布局
                if index==9 {
                    redItem = KJChessItem(center: CGPoint(x: Width/2+Width, y: Width*10-Width/2-Width*2))
                    redItem!.setTitle(title: allRedChessItemsName[index], isOwn: true)
                    greenItem = KJChessItem(center: CGPoint(x: Width/2+Width, y: Width/2+Width*2))
                    greenItem!.setTitle(title: allGreenChessItemsName[index], isOwn: false)
                } else {
                    redItem = KJChessItem(center: CGPoint(x: Width*9-Width/2-Width, y: Width*10-Width/2-Width*2))
                    redItem!.setTitle(title: allRedChessItemsName[index], isOwn: true)
                    greenItem = KJChessItem(center: CGPoint(x: Width*9-Width/2-Width, y: Width/2+Width*2))
                    greenItem!.setTitle(title: allGreenChessItemsName[index], isOwn: false)
                }
            } else {    //进行兵棋子的布局
                //红方布局
                redItem = KJChessItem(center: CGPoint(x: Width/2+Width*2 * CGFloat(index-11), y: Width*10-Width/2-Width*3))
                redItem!.setTitle(title: allRedChessItemsName[index], isOwn: true)
                //绿方布局
                greenItem = KJChessItem(center: CGPoint(x: Width/2+Width*2 * CGFloat(index-11), y: Width/2+Width*3))
                greenItem!.setTitle(title: allGreenChessItemsName[index], isOwn: false)
            }
            //将棋子添加到当前视图
            self.addSubview(redItem!)
            self.addSubview(greenItem!)
            //将棋子添加进数组
            currentRedItem.append(redItem!)
            currentGreenItem.append(greenItem!)
            //添加用户交互方法
            redItem?.addTarget(self, action: #selector(itemClick), for:
.touchUpInside)
            greenItem?.addTarget(self, action: #selector(itemClick), for:
.touchUpInside)
        }
    }
    
    @objc func itemClick(item:KJChessItem){
        if delegate != nil {
            delegate?.chessItemClick(item: item)
        }
    }
    
    //取消所有棋子的选中状态
    func cancelAllSelect() {
        currentRedItem.forEach { (item) in
            item.setUnselectedState()
        }
        currentGreenItem.forEach { (item) in
            item.setUnselectedState()
        }
    }
    //将棋子坐标映射为二维矩阵中的点
    func transfromPositionToMatrix(item:KJChessItem) -> (Int,Int) {
        let res = (Int(item.center.x-Width/2)/Int(Width),Int(item.center.y-Width/2)/Int(Width))
        return res
    }
    
    //获取棋盘上所有红方棋子在二维矩阵中位置的数组
    func getAllRedMatrixList()->[(Int,Int)] {
        var list = Array<(Int,Int)>()
        currentRedItem.forEach { (item) in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    //取棋盘上所有绿方棋子在二维矩阵中位置的数组
    func getAllGreenMatrixList()->[(Int,Int)] {
        var list = Array<(Int,Int)>()
        currentGreenItem.forEach { (item) in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    //将可以移动到的位置进行标记
    func wantMoveItem(positions:[(Int,Int)],item:KJChessItem)  {
        //如果是红方 如果在路径上有己方棋子，则不能移动
        var list:Array<(Int,Int)>?
        if item.isRed {
            list = getAllRedMstrixList()
        } else {
            list = getAllGreenMstrixList()
        }
        currentCanMovePosition.removeAll()
        positions.forEach { (position) in
            if list!.contains(where: { (pos) -> Bool in
                if pos == position {
                    return true
                }
                return false
            }) {
                
            } else {
                currentCanMovePosition.append(position)
            }
        }
        //将可以进行前进的位置使用按钮进行标记
        tipButtonArray.forEach { (item) in
            item.removeFromSuperview()
        }
        tipButtonArray.removeAll()
        for index in 0..<currentCanMovePosition.count {
            //将矩阵转换成位置坐标
            let position = currentCanMovePosition[index]
            let center = CGPoint(x: CGFloat(position.0)*Width+Width/2, y: CGFloat(position.1)*Width+Width/2)
            let tip = KJTipButton(center: center)
            tip.addTarget(self, action: #selector(moveItem), for:
.touchUpInside)
            tip.tag = 100+index
            self.addSubview(tip)
            tipButtonArray.append(tip)
        }
    }
    
    @objc func moveItem(tipButton:KJTipButton) {
       //得到要移动到的位置
       let position = currentCanMovePosition[tipButton.tag-100]
       //转换成坐标
       let point = CGPoint(x: CGFloat(position.0)*Width+Width/2, y: CGFloat(position.1)*Width+Width/2)
       //找到被选中的棋子
       var isRed:Bool?
       currentRedItem.forEach { (item) in
           if item.selectedState {
               isRed = true
               //进行动画移动
               UIView.animate(withDuration: 0.3, animations: {
                   item.center = point
               })
           }
       }
       currentGreenItem.forEach { (item) in
           if item.selectedState {
               isRed = false
               //进行动画移动
               UIView.animate(withDuration: 0.3, animations: {
                   item.center = point
               })
           }
       }
       //检查是否有敌方棋子 如果有则吃掉敌方棋子
       var shouldDeleteItem:KJChessItem?
       if isRed! {
           currentGreenItem.forEach({ (item) in
               if transfromPositionToMatrix(item: item) == position {
                   shouldDeleteItem = item
               }
           })
       } else {
           currentRedItem.forEach({ (item) in
               if transfromPositionToMatrix(item: item) == position {
                   shouldDeleteItem = item
               }
           })
       }
       if let it = shouldDeleteItem {
           it.removeFromSuperview()
           if isRed! {
               currentGreenItem.remove(at: currentGreenItem.firstIndex(of: it)!)
           } else {
               currentRedItem.remove(at: currentRedItem.firstIndex(of: it)!)
           }
           //进行胜负判定
           if it.title(for: .normal) == "将"{
               if delegate != nil {
                   delegate!.gameOver(redWin: true)
               }
           }
           if it.title(for: .normal) == "帥"{
               if delegate != nil {
                   delegate!.gameOver(redWin: false)
               }
           }
       }
       tipButtonArray.forEach { (item) in
           item.removeFromSuperview()
       }
       tipButtonArray.removeAll()
       if delegate != nil {
           delegate?.chessMoveEnd()
       }
    }
    
    //获取所有红方棋子的矩阵数组
    func getAllRedMstrixList()->[(Int,Int)] {
        var list = Array<(Int,Int)>()
        currentRedItem.forEach { (item) in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    //获取所有绿方棋子的矩阵数组
    func getAllGreenMstrixList()->[(Int,Int)] {
        var list = Array<(Int,Int)>()
        currentGreenItem.forEach { (item) in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        //获取当前视图的图形上下文
        let context = UIGraphicsGetCurrentContext()
        //设置绘制线条的颜色为黑色
        context?.setStrokeColor(UIColor.black.cgColor)
        //设置绘制线条的宽度为0.5个单位
        context?.setLineWidth(0.5)
        //进行水平线的绘制
        for index in 0...9 {
            //通过移动点来确定每行的起点
            context?.move(to: CGPoint(x: Width/2, y:Width/2+Width * CGFloat(index)))
            //从左向右绘制水平线
            context?.addLine(to: CGPoint(x: rect.size.width-Width/2, y:Width/2+Width*CGFloat(index)))
            context?.drawPath(using: .stroke)
        }
        //进行竖直线的绘制
        for index in 0..<9 {
            if index==0 || index==8 {  //最左边和最右边的线贯穿始终
                context?.move(to: CGPoint(x: Width/2+Width*CGFloat(index), y: Width/2))
                context?.addLine(to: CGPoint(x: Width*CGFloat(index)+Width/2, y: rect.size.height-Width/2))
            } else {     //中间的先以楚河汉界为分隔
                context?.move(to: CGPoint(x: Width/2+Width*CGFloat(index), y: Width/2))
                context?.addLine(to: CGPoint(x: Width*CGFloat(index)+Width/2, y: rect.size.height/2-Width/2))
                context?.move(to: CGPoint(x: Width/2+Width*CGFloat(index), y: rect.size.height/2+Width/2))
                context?.addLine(to: CGPoint(x: Width*CGFloat(index)+Width/2, y: rect.size.height-Width/2))
            }
        }
        //绘制双方主帅田字格
        context?.move(to: CGPoint(x: Width/2+Width*3, y: Width/2))
        context?.addLine(to: CGPoint(x:  Width/2+Width*5, y: Width/2+Width*2))
        context?.move(to: CGPoint(x: Width/2+Width*5, y: Width/2))
        context?.addLine(to: CGPoint(x:  Width/2+Width*3, y: Width/2+Width*2))
        context?.move(to: CGPoint(x: Width/2+Width*3, y: Width*10-Width/2))
        context?.addLine(to: CGPoint(x:  Width/2+Width*5, y: Width*10-Width / 2 - Width * 2))
        context?.move(to: CGPoint(x: Width/2+Width*5, y:Width*10-Width/2))
        context?.addLine(to: CGPoint(x:  Width/2+Width*3, y: Width*10-Width/2-Width*2))
        context?.drawPath(using: .stroke)
    }
}
