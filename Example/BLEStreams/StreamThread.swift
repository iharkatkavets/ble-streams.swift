//
//  StreamThread.swift
//  BLEStreams_Example
//
//  Created by Ihar Katkavets on 29/01/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import BLEStreams

class StreamThread: Thread, StreamDelegate {
    let stream: BLEInputStream
    let baseDate: Date
    
    init(stream: BLEInputStream, baseDate: Date) {
        self.stream = stream
        self.baseDate = baseDate
    }
    
    override func main() {
        stream.delegate = self
        stream.schedule(in: .current, forMode: RunLoop.Mode.default)
        print("thread starts at \(Date.now.timeIntervalSince(baseDate))")
        let tenSeconds = Double(10)
        let dateInFuture = Date(timeIntervalSinceNow: tenSeconds)
        RunLoop.current.run(until: dateInFuture)
        print("finish \(Date.now.timeIntervalSince(baseDate))")
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .errorOccurred {
            print("eventCode == .errorOccurred")
        }
        else if eventCode == .hasBytesAvailable {
            print("eventCode == .hasBytesAvailable")
        }
    }
}
