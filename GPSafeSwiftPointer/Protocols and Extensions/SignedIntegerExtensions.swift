//
//  SignedIntegerExtensions.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 26/07/15.
//  Copyright © 2015-2019 Gabriele Pongelli. All rights reserved.
//
// For GenericIntegerType and GenericSignedIntegerBitPattern
//  credits to https://gist.github.com/krzyzanowskim/c84d039d1542c1a82731

import Foundation

extension Int:GenericIntegerType, GenericSignedIntegerBitPattern  {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt(truncatingIfNeeded: bitPattern))
    }
}

extension Int8:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt8(truncatingIfNeeded: bitPattern))
    }
}


extension Int16:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt16(truncatingIfNeeded: bitPattern))
    }
}


extension Int32:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt32(truncatingIfNeeded: bitPattern))
    }
}


extension Int64:GenericIntegerType, GenericSignedIntegerBitPattern {
    // init(bitPattern: UInt64) already defined
    
    init(truncatingBitPattern: Int64) {
        self.init(truncatingBitPattern)
    }
}


// MARK: - ByteArrayType extension for signed integer
extension Int8 : ByteArrayType {
    public func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}


extension Int16 : ByteArrayType {
    public func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}


extension Int32 : ByteArrayType {
    public func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}


extension Int64 : ByteArrayType {
    public func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}
