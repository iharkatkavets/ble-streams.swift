//
//  BLEInputStreamTests.swift
//  BLEInputStream_Tests
//
//  Created by Ihar Katkavets on 29/01/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import BLEStreams

final class BLEInputStreamTests: XCTestCase {
    var inputStream: BLEInputStream?
    var errorExpectation: XCTestExpectation? = nil
    var hasBytesExpectation: XCTestExpectation? = nil
    
    private func makeStream() -> BLEInputStream {
        let stream = BLEInputStream()
        stream.delegate = self
        return stream
        
    }
    
    func testHandleError() {
        inputStream = makeStream()
        
        errorExpectation = expectation(description: "testHandleError")
        inputStream?.streamError = NSError(domain: "", code: 100)
        wait(for: [errorExpectation!], timeout: 1)
    }
    
    func testHasBytesAvailableDefault() {
        inputStream = makeStream()
        XCTAssertFalse(inputStream!.hasBytesAvailable)
    }
    
    func testHasBytesAvailableAfterAddingData() {
        inputStream = makeStream()
        let len = Int.random(in: 0..<100)
        let randomData = randData(length: len)
        
        hasBytesExpectation = expectation(description: "testHasBytesAvailable")
        inputStream?.accept(randomData)
        wait(for: [hasBytesExpectation!], timeout: 1)
        XCTAssertTrue(inputStream!.hasBytesAvailable)
    }

    func testReadFromInputStream() {
        inputStream = makeStream()
        let len = Int.random(in: 0..<100)
        let randomData = randData(length: len)
        
        inputStream?.accept(randomData)
        
        var readData = Array(repeating: UInt8(0), count: len)
        let readLen = inputStream?.read(&readData, maxLength: len)
        XCTAssertEqual(Data(readData), randomData)
        XCTAssertEqual(readLen, randomData.count)
    }
    
    func testStreamWithRunLoop() {
        inputStream = makeStream()
        let len = Int.random(in: 0..<100)
        let randomData = randData(length: len)
        
        let tenSeconds = Double(10)
        let oneSecond = TimeInterval(1)
        runOnBackgroundQueue(oneSecond) {
            self.inputStream?.accept(randomData)
        }
        let dateInFuture = Date(timeIntervalSinceNow: tenSeconds)
        inputStream?.schedule(in: .current, forMode: RunLoop.Mode.default)
        RunLoop.current.run(until: dateInFuture)
        XCTAssertTrue(dateInFuture.timeIntervalSinceNow > 0, "Timeout. RunLoop didn't exit. ")
    }
}

extension BLEInputStreamTests: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .errorOccurred {
            errorExpectation?.fulfill()
        }
        else if eventCode == .hasBytesAvailable {
            hasBytesExpectation?.fulfill()
        }
    }
}
