//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport



let playgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 360, height: 300))
playgroundView.backgroundColor =  UIColor(white: 0.912, alpha: 1.0)

let clockView = ClockView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
clockView.backgroundColor = .white
clockView.layer.shadowColor = UIColor(white: 0.2, alpha: 1.0).cgColor
clockView.layer.shadowOffset = CGSize(width: 2, height: 2)
clockView.layer.shadowRadius = 3
clockView.layer.shadowOpacity = 0.8


playgroundView.addSubview(clockView)
clockView.center = CGPoint(x: playgroundView.bounds.midX, y: playgroundView.bounds.midY)

clockView.updateTime(date: Date())


Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
  clockView.updateTime(date: Date())
}
playgroundView
PlaygroundPage.current.liveView = playgroundView
