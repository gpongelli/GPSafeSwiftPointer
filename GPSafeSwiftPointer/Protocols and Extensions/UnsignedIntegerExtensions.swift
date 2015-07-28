//
//  UnsignedIntegerExtensions.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 26/07/15.
//  Copyright © 2015 Gabriele Pongelli. All rights reserved.
//
// For GenericIntegerType and GenericUnsignedIntegerBitPattern
//  credits to https://gist.github.com/krzyzanowskim/c84d039d1542c1a82731

import Foundation


extension UInt:GenericIntegerType, GenericUnsignedIntegerBitPattern {}

extension UInt8:GenericIntegerType, GenericUnsignedIntegerBitPattern {}

extension UInt16:GenericIntegerType, GenericUnsignedIntegerBitPattern {}

extension UInt32:GenericIntegerType, GenericUnsignedIntegerBitPattern {}

extension UInt64:GenericIntegerType, GenericUnsignedIntegerBitPattern {    
    init(truncatingBitPattern: UIntMax) {
        self.init(truncatingBitPattern)
    }
}


// MARK: - ByteArrayType extension for unsigned integer
extension UInt8 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}

extension UInt16 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}

extension UInt32 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}

extension UInt64 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(self)
    }
}