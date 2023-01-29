//
//  ViewController.swift
//  BLEStreams
//
//  Created by Ihar Katkavets on 01/29/2023.
//  Copyright (c) 2023 Ihar Katkavets. All rights reserved.
//

import UIKit
import BLEStreams

class ViewController: UIViewController {
    var stream = BLEInputStream()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let baseDate = Date.now
        let thread = StreamThread(stream: stream, baseDate: baseDate)
        thread.start()
        print("main thread pauses at \(Date.now.timeIntervalSince(baseDate))")
        Thread.sleep(forTimeInterval: 2)
        print("stream accepts Data \(Date.now.timeIntervalSince(baseDate))")
        stream.accept(Data([1,2,3]))
    }
}

