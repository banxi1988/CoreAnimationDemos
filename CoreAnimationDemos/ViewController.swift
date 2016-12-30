//
//  ViewController.swift
//  CoreAnimationDemos
//
//  Created by Haizhen Lee on 12/29/16.
//  Copyright © 2016 banxi1988. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let clockView = ClockView(frame: CGRect(x: 80, y: 150, width: 200, height: 200))
  override func viewDidLoad() {
    super.viewDidLoad()
    let playgroundView = self.view!
    playgroundView.backgroundColor = .gray
    
    clockView.backgroundColor = .white
    playgroundView.addSubview(clockView)
    
    if #available(iOS 10.0, *) {
      Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
        self.tick()
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  func tick(){
      DispatchQueue.main.async{
        UIView.animate(withDuration: 0.15, animations: { 
          self.clockView.tick()
        })
      }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

