//
//  BLEInputStream.swift
//  BLEInputStream
//
//  Created by Ihar Katkavets on 29/01/2023.
//

import Foundation

public class BLEInputStream: InputStream {
    private var data = Data()
    private var runLoopSource: CFRunLoopSource?
    private var runLoop: RunLoop?
//    private var
    public override var hasBytesAvailable: Bool {
        get {
            return data.count > 0
        }
    }
    
    var streamErrorInternal: Error?
    public override var streamError: Error? {
        set {
            streamErrorInternal = newValue
            delegate?.stream?(self, handle: .errorOccurred)
        }
        get {
            return streamErrorInternal
        }
    }
    
    var delegateInternal: StreamDelegate?
    public override var delegate: StreamDelegate? {
        set {
            delegateInternal = newValue
        }
        get {
            return delegateInternal
        }
    }
    
    public func accept(_ data: Data) {
        guard data.count > 0 else { return }
        
        self.data += data
        delegate?.stream?(self, handle: .hasBytesAvailable)
        
        if let runLoopSource {
            CFRunLoopSourceSignal(runLoopSource)
            print("CFRunLoopSourceSignal(runLoopSource)")
        }
        if let runLoop {
            CFRunLoopWakeUp(runLoop.getCFRunLoop())
            print("CFRunLoopWakeUp(runLoop.getCFRunLoop())")
        }
    }
    
    public override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        self.runLoop = aRunLoop
        var context = CFRunLoopSourceContext()
        self.runLoopSource = CFRunLoopSourceCreate(nil, 0, &context)
        let cfloopMode: CFRunLoopMode = CFRunLoopMode(mode as CFString)
        CFRunLoopAddSource(aRunLoop.getCFRunLoop(), self.runLoopSource!, cfloopMode)
        print("hello")
    }
    
    final override public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        let dataLen = data.count
        let readLen = min(dataLen, len)
        let actualReadLen = data.withUnsafeBytes { urbp in
            let bUInt8 = urbp.bindMemory(to: UInt8.self)
            guard let ptr = bUInt8.baseAddress else { return 0 }
            buffer.initialize(from: ptr, count: readLen)
            return readLen
        }
        data.removeFirst(readLen)
        return actualReadLen
    }
}

