//
//  ViewController.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// Router to RoomViewController
        let rvc = RoomViewController.enterRoom(uid: 100, roomId: 101)
        view.addSubview(rvc.view)
        addChild(rvc)
    }
}

