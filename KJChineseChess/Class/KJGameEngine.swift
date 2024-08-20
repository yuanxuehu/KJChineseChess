//
//  KJGameEngine.swift
//  KJChineseChess
//
//  Created by TigerHu on 2024/8/20.
//

import UIKit

protocol KJGameEngineDelegate {
    func gameOver(redWin:Bool)
    //当前行棋的一方改变时调用
    func couldRedMove(red:Bool)
}

//需要遵守KJChessBoardDelegate协议
class KJGameEngine: NSObject,KJChessBoardDelegate {
    //当前游戏棋盘
    var gameBoard:KJChessBoard?
    //设置是否红方先走 默认红方先走
    var redFirstMove = true
    //标记当前需要行棋的一方
    var shouldRedMove = true
    var delegate:KJGameEngineDelegate?
    //开始游戏的标记
    var isStarting = false
    
    init(board:KJChessBoard) {
        gameBoard = board
        super.init()
        gameBoard?.delegate = self
    }
    
    //开始游戏的方法
    func startGame() {
        isStarting = true
        gameBoard?.reStartGame()
        shouldRedMove = redFirstMove
        if delegate != nil {
            delegate?.couldRedMove(red: shouldRedMove)
        }
    }
    func gameOver(redWin: Bool) {
        //将游戏结束
        isStarting = false
        //将胜负状态传递给界面
        if delegate != nil {
            delegate?.gameOver(redWin: redWin)
        }
    }
    //设置先行棋的一方
    func setRedFirstMove(red:Bool) {
        redFirstMove = red
        shouldRedMove = red
    }
    //用户点击某个棋子后的回调
    func chessItemClick(item: KJChessItem) {
        
        if isStarting == false {
            //游戏还没开始 || 游戏结束
            print("游戏还没开始 || 游戏结束请重新开局")
            return
        }
        
        //判断所点击的棋子是否属于应该行棋的一方
        if shouldRedMove {
            if !item.isRed {
               return
            }
        } else {
            if item.isRed {
                return
            }
        }
        
        gameBoard?.cancelAllSelect()
        item.setSelectedState()
        //进行行棋算法
        checkCanMove(item: item)
    }
    //检测可以移动的位置
    func checkCanMove(item:KJChessItem) {
        //进行“兵”行棋算法
        if item.title(for: .normal) == "兵" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //如果没过界 “兵”只能前进
            var wantMove = Array<(Int,Int)>()
            if position.1>4 {
                wantMove = [(position.0,position.1-1)]
            } else {
                //左右前
                if position.0>0 {
                    wantMove.append((position.0-1,position.1))
                }
                if position.0<8 {
                    wantMove.append((position.0+1,position.1))
                }
                if position.1>0 {
                    wantMove.append((position.0,position.1-1))
                }
            }
            //交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "卒" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //如果没过界 “卒”只能前进
            var wantMove = Array<(Int,Int)>()
            if position.1<5 {
                wantMove = [(position.0,position.1+1)]
            } else {
                //左右前
                if position.0>0 {
                    wantMove.append((position.0-1,position.1))
                }
                if position.0<8 {
                    wantMove.append((position.0+1,position.1))
                }
                if position.1<9 {
                    wantMove.append((position.0,position.1+1))
                }
            }
            //交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "士" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //士在将格内沿对角线行棋
            var wantMove = Array<(Int,Int)>()
            //左上 右上 左下 右下 四个方向行棋
            if position.0<5 && position.1>7 {
                wantMove.append((position.0+1,position.1-1))
            }
            if position.0>3 && position.1<9 {
                wantMove.append((position.0-1,position.1+1))
            }
            if position.0>3 && position.1>7 {
                wantMove.append((position.0-1,position.1-1))
            }
            if position.0<5 && position.1<9 {
                wantMove.append((position.0+1,position.1+1))
            }
            //交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "仕" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //士在将格内沿对角线行棋
            var wantMove = Array<(Int,Int)>()
            //左上 右上 左下 右下 四个方向行棋
            if position.0<5 && position.1<2 {
                wantMove.append((position.0+1,position.1+1))
            }
            if position.0>3 && position.1>0 {
                wantMove.append((position.0-1,position.1-1))
            }
            if position.0>3 && position.1<2 {
                wantMove.append((position.0-1,position.1+1))
            }
            if position.0<5 && position.1>0 {
                wantMove.append((position.0+1,position.1-1))
            }
            //交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "帥" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //在将格内移动 上下左右移动
            var wantMove = Array<(Int,Int)>()
            if position.1<9 {
                wantMove.append((position.0,position.1+1))
            }
            if position.1>7 {
                wantMove.append((position.0,position.1-1))
            }
            if position.0<5 {
                wantMove.append((position.0+1,position.1))
            }
            if position.0>3 {
                wantMove.append((position.0-1,position.1))
            }
            //交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "将" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //在将格内移动 上下左右移动
            var wantMove = Array<(Int,Int)>()
            if position.1<2 {
                wantMove.append((position.0,position.1+1))
            }
            if position.1>0 {
                wantMove.append((position.0,position.1-1))
            }
            if position.0<5 {
                wantMove.append((position.0+1,position.1))
            }
            if position.0>3 {
                wantMove.append((position.0-1,position.1))
            }
            //交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "相" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMstrixList()
            let greenList = gameBoard!.getAllGreenMstrixList()
            //左上 右上 左下 右下
            if position.0-2>=0 && position.1-2>4 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1-1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1-1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0-2,position.1-2))
                }
            }
            if position.0+2<=8 && position.1+2<=9 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1+1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1+1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0+2,position.1+2))
                }
            }
            if position.0+2<=8 && position.1-2>4 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1-1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1-1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0+2,position.1-2))
                }
            }
            if position.0-2>=0 && position.1+2<=9 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1+1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1+1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0-2,position.1+2))
                }
            }
            //交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "象" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMstrixList()
            let greenList = gameBoard!.getAllGreenMstrixList()
            //左上 右上 左下 右下
            if position.0-2>=0 && position.1-2>=0 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1-1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1-1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0-2,position.1-2))
                }
            }
            if position.0+2<=8 && position.1+2<=4 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1+1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1+1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0+2,position.1+2))
                }
            }
            if position.0+2<=8 && position.1-2>=0 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1-1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1-1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0+2,position.1-2))
                }
            }
            if position.0-2>=0 && position.1+2<=4 {
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1+1)
                }) || greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1+1)
                }) {
                    //塞象眼 不添加此位置
                } else {
                    wantMove.append((position.0-2,position.1+2))
                }
            }
            //交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "马" || item.title(for: .normal) == "馬" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMstrixList()
            let greenList = gameBoard!.getAllGreenMstrixList()
            // 以日字行走 八个方向 上 下 左 右各两个方向
            if position.0-1>=0 && position.1-2>=0 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1-1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1-1)
                })) {
                    
                } else {
                    wantMove.append((position.0-1,position.1-2))
                }
            }
            if position.0+1<=8 && position.1-2>=0 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1-1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1-1)
                })) {
                    
                } else {
                    wantMove.append((position.0+1,position.1-2))
                }
            }
            if position.0+2<=8 && position.1-1>=0 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1)
                })) {
                    
                } else {
                    wantMove.append((position.0+2,position.1-1))
                }
            }
            if position.0+2<=8 && position.1+1<=9 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0+1,position.1)
                })) {
                    
                } else {
                    wantMove.append((position.0+2,position.1+1))
                }
            }
            if position.0+1<=8 && position.1+2<=9 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1+1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1+1)
                })) {
                    
                } else {
                   wantMove.append((position.0+1,position.1+2))
                }
            }
            if position.0-1>=0 && position.1+2<=9 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1+1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0,position.1+1)
                })) {
                    
                } else {
                    wantMove.append((position.0-1,position.1+2))
                }
            }
            if position.0-2>=0 && position.1+1<=9 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1)
                })) {
                    
                } else {
                    wantMove.append((position.0-2,position.1+1))
                }
            }
            if position.0-2>=0 && position.1-1>=0 {
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (position.0-1,position.1)
                })) {
                    
                } else {
                    wantMove.append((position.0-2,position.1-1))
                }
            }
            //交换给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "车" || item.title(for: .normal) == "車" {
            //获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMstrixList()
            let greenList = gameBoard!.getAllGreenMstrixList()
            //车可以沿水平和竖直两个方向行棋
            //水平方向分为左和右
            var temP = position
            while temP.0-1>=0 {
                //如果有棋子则退出循环
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0-1,temP.1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0-1,temP.1)
                })) {
                    wantMove.append((temP.0-1,temP.1))
                    break
                } else {
                    wantMove.append((temP.0-1,temP.1))
                }
                temP.0 -= 1
            }
            temP = position
            while temP.0+1<=8 {
                //如果有棋子则退出循环
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0+1,temP.1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0+1,temP.1)
                })) {
                    wantMove.append((temP.0+1,temP.1))
                    break
                } else {
                    wantMove.append((temP.0+1,temP.1))
                }
                temP.0 += 1
            }
            temP = position
            while temP.1+1<=9 {
                //如果有棋子则退出循环
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0,temP.1+1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0,temP.1+1)
                })) {
                    wantMove.append((temP.0,temP.1+1))
                    break
                } else {
                    wantMove.append((temP.0,temP.1+1))
                }
                temP.1 += 1
            }
            temP = position
            while temP.1-1>=0 {
                //如果有棋子则退出循环
                if (redList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0,temP.1-1)
                })) || (greenList.contains(where: { (pos) -> Bool in
                    return pos == (temP.0,temP.1-1)
                })) {
                    wantMove.append((temP.0,temP.1-1))
                    break
                } else {
                    wantMove.append((temP.0,temP.1-1))
                }
                temP.1 -= 1
            }
            //交给棋盘类进行移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        if item.title(for: .normal) == "炮" {
           //获取棋子在二维矩阵中的位置
           let position = gameBoard!.transfromPositionToMatrix(item: item)
           var wantMove = Array<(Int,Int)>()
           let redList = gameBoard!.getAllRedMstrixList()
           let greenList = gameBoard!.getAllGreenMstrixList()
           //炮可以沿水平和竖直两个方向行棋
           //水平方向分为左和右
           var temP = position
           var isFirst = true
           while temP.0-1>=0 {
               //如果有棋子则找出其后面的最近一颗棋子 之后退出循环
               if (redList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0-1,temP.1)
               })) || (greenList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0-1,temP.1)
               })) {
                   if !isFirst {
                       wantMove.append((temP.0-1,temP.1))
                       break
                   }
                   isFirst = false
               } else {
                   if isFirst {
                        wantMove.append((temP.0-1,temP.1))
                   }
               }
               temP.0 -= 1
           }
           temP = position
           isFirst = true
           while temP.0+1<=8 {
               //如果有棋子则退出循环
               if (redList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0+1,temP.1)
               })) || (greenList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0+1,temP.1)
               })) {
                   if !isFirst {
                       wantMove.append((temP.0+1,temP.1))
                       break
                   }
                   isFirst = false
               } else {
                   if isFirst {
                        wantMove.append((temP.0+1,temP.1))
                   }
               }
               temP.0 += 1
           }
           temP = position
           isFirst=true
           while temP.1+1<=9 {
               //如果有棋子则退出循环
               if (redList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0,temP.1+1)
               })) || (greenList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0,temP.1+1)
               })) {
                   if !isFirst {
                       wantMove.append((temP.0,temP.1+1))
                       break
                   }
                   isFirst = false
               } else {
                   if isFirst {
                       wantMove.append((temP.0,temP.1+1))
                   }
               }
               temP.1 += 1
           }
           temP = position
           isFirst = true
           while temP.1-1>=0 {
               //如果有棋子则退出循环
               if (redList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0,temP.1-1)
               })) || (greenList.contains(where: { (pos) -> Bool in
                   return pos == (temP.0,temP.1-1)
               })) {
                   if !isFirst {
                       wantMove.append((temP.0,temP.1-1))
                       break
                   }
                   isFirst = false
               } else {
                   if isFirst {
                       wantMove.append((temP.0,temP.1-1))
                   }
               }
               temP.1 -= 1
           }
           //交给棋盘类进行移动提示
           gameBoard?.wantMoveItem(positions: wantMove, item: item)
       }
    }
    //一方行棋完成后 换另一方行棋
    func chessMoveEnd() {
        shouldRedMove = !shouldRedMove
        //更新行棋方
        if delegate != nil {
            delegate?.couldRedMove(red: shouldRedMove)
        }
        gameBoard?.cancelAllSelect()
    }
}

