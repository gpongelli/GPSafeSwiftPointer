//
//  GPSafeSwiftPointer.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 16/07/15.
//  Copyright © 2015-2019 Gabriele Pongelli. All rights reserved.
//

import Foundation


open class GPSafeSwiftPointer<TYPE> : NSObject {
    
    //MARK: - Private Section
    fileprivate let allocatedMemory : Int
    
    fileprivate var unsafeMutablePointer : UnsafeMutablePointer<TYPE>
    
    fileprivate func isAllowed(_ idx : Int) -> Bool {
        return idx < self.allocatedMemory
    }
    
    
    //MARK: - Public Computed Property
    open var ump : UnsafeMutablePointer<TYPE> {
        get {
            return unsafeMutablePointer
        }
    }
    
    open var sizeofType : Int {
        get {
            return MemoryLayout<TYPE>.size
        }
    }
    
    
    //MARK: - Initializers
    required public init(allocatedMemory : Int = 1) {
        self.allocatedMemory = allocatedMemory
        unsafeMutablePointer = UnsafeMutablePointer<TYPE>.allocate(capacity: self.allocatedMemory)
    }
    
    convenience public init(initializeWithValue : TYPE) {
        self.init()
        unsafeMutablePointer.initialize(to: initializeWithValue)
    }
    
    convenience public init(initializeWithValue : [TYPE]) {
        self.init(allocatedMemory: initializeWithValue.count)
        
        for i in 0 ..< initializeWithValue.count {
            self[i] = initializeWithValue[i]
        }
    }
    
    
    //MARK: - Subscription
    open subscript(idx: Int) -> TYPE? {
        get {
            if (!isAllowed(idx)) {
                return nil
            }
            
            return unsafeMutablePointer[idx]
        }
        
        set (newValue) {
            if (!isAllowed(idx)) {
                return
            }
            
            unsafeMutablePointer.advanced(by: idx).initialize(to: newValue!)
        }
    }
    
    //MARK: - Deinitialization
    deinit {
        unsafeMutablePointer.deinitialize()
        unsafeMutablePointer.deallocate(capacity: allocatedMemory)
    }
}


// MARK: - ByteArrayType extension for GPSafeSwiftPointer
extension GPSafeSwiftPointer where TYPE : ByteArrayType {
    public func getByteArray() -> [UInt8] {
        var ret = [UInt8]()
        ret.reserveCapacity(self.allocatedMemory * self.sizeofType)
        
        for i in (0..<self.allocatedMemory).reversed() {
            ret.append( contentsOf: self[i]!.getByteArray() )
        }
        
        return ret
    }
}
