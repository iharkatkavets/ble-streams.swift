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
        let randomData = Data([1,2,3,4,5])
        
        hasBytesExpectation = expectation(description: "testHasBytesAvailable")
        inputStream?.accept(randomData)
        wait(for: [hasBytesExpectation!], timeout: 1)
        XCTAssertTrue(inputStream!.hasBytesAvailable)
        
        let len = randomData.count
        var readData = Array(repeating: UInt8(0), count: len)
        let readLen = inputStream?.read(&readData, maxLength: len)
        XCTAssertEqual(Data(readData), randomData)
        XCTAssertEqual(readLen, randomData.count)
    }

    func testReadFromInputStream() {
        
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
