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
    public init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt(truncatingBitPattern: bitPattern))
    }
}

extension Int8:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt8(truncatingBitPattern: bitPattern))
    }
}


extension Int16:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt16(truncatingBitPattern: bitPattern))
    }
}


extension Int32:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt32(truncatingBitPattern: bitPattern))
    }
}


extension Int64:GenericIntegerType, GenericSignedIntegerBitPattern {
    // init(bitPattern: UInt64) already defined
    
    public init(truncatingBitPattern: IntMax) {
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
