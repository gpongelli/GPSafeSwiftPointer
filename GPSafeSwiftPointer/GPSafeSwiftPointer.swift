//
//  GPSafeSwiftPointer.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 16/07/15.
//  Copyright © 2015 Gabriele Pongelli. All rights reserved.
//

import Foundation


public class GPSafeSwiftPointer<TYPE> : NSObject {
    
    //MARK: - Private Section
    private let allocatedMemory : Int
    
    private var unsafeMutablePointer : UnsafeMutablePointer<TYPE>
    
    private func isAllowed(idx : Int) -> Bool {
        return idx < self.allocatedMemory
    }
    
    
    //MARK: - Public Computed Property
    public var ump : UnsafeMutablePointer<TYPE> {
        get {
            return unsafeMutablePointer
        }
    }
    
    public var sizeofType : Int {
        get {
            return sizeof(TYPE)
        }
    }
    
    
    //MARK: - Initializers
    required public init(allocatedMemory : Int = 1) {
        self.allocatedMemory = allocatedMemory
        unsafeMutablePointer = UnsafeMutablePointer<TYPE>.alloc(self.allocatedMemory)
    }
    
    convenience public init(initializeWithValue : TYPE) {
        self.init()
        unsafeMutablePointer.initialize(initializeWithValue)
    }
    
    
    //MARK: - Subscription
    subscript(idx: Int) -> TYPE? {
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
            
            unsafeMutablePointer.advancedBy(idx).initialize(newValue!)
        }
    }
    
    //MARK: - Deinitialization
    deinit {
        unsafeMutablePointer.destroy()
        unsafeMutablePointer.dealloc(allocatedMemory)
    }
}


// MARK: - ByteArrayType extension for GPSafeSwiftPointer
extension GPSafeSwiftPointer where TYPE : ByteArrayType {
    func getByteArray() -> [UInt8] {
        var ret = [UInt8]()
        
        for (var i = self.allocatedMemory - 1; i >= 0; i--) {
            ret.extend( self[i]!.getByteArray() )
        }
        
        return ret
    }
}
