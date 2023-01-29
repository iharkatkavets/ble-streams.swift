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
    private var runLoopMode: CFRunLoopMode?
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
        
        if let runLoopSource, let runLoop, let runLoopMode {
            CFRunLoopRemoveSource(runLoop.getCFRunLoop(), runLoopSource, runLoopMode)
        }
        if let runLoop {
            CFRunLoopWakeUp(runLoop.getCFRunLoop())
        }
    }
    
    public override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        runLoop = aRunLoop
        var context = CFRunLoopSourceContext()
        runLoopSource = CFRunLoopSourceCreate(nil, 0, &context)
        runLoopMode = CFRunLoopMode(mode as CFString)
        CFRunLoopAddSource(aRunLoop.getCFRunLoop(), runLoopSource!, runLoopMode!)
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

