//
//  XCTestCaseExtensions.swift
//  BLEStreams_Example
//
//  Created by Ihar Katkavets on 29/01/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func randData(length: Int) -> Data {
        return Data((0..<length).map { _ in UInt8.random(in: UInt8.min..<UInt8.max) })
    }
    
    func runOnBackgroundQueue(_ delay: TimeInterval, _ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5, execute: block)
    }
}
