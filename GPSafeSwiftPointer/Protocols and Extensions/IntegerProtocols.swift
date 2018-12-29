//
//  IntegerProtocols.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 26/07/15.
//  Copyright © 2015-2019 Gabriele Pongelli. All rights reserved.
//
// For GenericIntegerType, GenericSignedIntegerBitPattern, 
//  GenericUnsignedIntegerBitPattern and integerWithBytes
//  credits to https://gist.github.com/krzyzanowskim/c84d039d1542c1a82731

import Foundation

typealias Byte = UInt8

// MARK: - Generic Integer Protocols
protocol GenericIntegerType: BinaryInteger {
    init(_ v: Int)
    init(_ v: UInt)
    init(_ v: Int8)
    init(_ v: UInt8)
    init(_ v: Int16)
    init(_ v: UInt16)
    init(_ v: Int32)
    init(_ v: UInt32)
    init(_ v: Int64)
    init(_ v: UInt64)
}

protocol GenericSignedIntegerBitPattern {
    init(bitPattern: UInt64)
    init(truncatingIfNeeded: Int64)
}

public protocol GenericUnsignedIntegerBitPattern {
    init(truncatingIfNeeded: UInt64)
}


// MARK: - Byte Array protocol
public protocol ByteArrayType {
    func getByteArray() -> [UInt8]
}


// MARK: - Generic Functions
func integerWithBytes<T: GenericIntegerType>(_ bytes:[UInt8]) -> T? where T: UnsignedInteger, T: GenericUnsignedIntegerBitPattern {
    if (bytes.count < MemoryLayout<T>.size) {
        return nil
    }
    
    let maxBytes = MemoryLayout<T>.size
    var i:UInt64 = 0
    for j in 0..<maxBytes {
        i = i | UInt64(T(bytes[maxBytes - j - 1])) << UInt64(j * 8)
    }
    return T(truncatingIfNeeded: i)
}

func integerWithBytes<T: GenericIntegerType>(_ bytes:[UInt8]) -> T? where T: SignedInteger, T:  GenericSignedIntegerBitPattern {
    if (bytes.count < MemoryLayout<T>.size) {
        return nil
    }
    
    let maxBytes = MemoryLayout<T>.size
    var i:Int64 = 0
    for j in 0 ..< maxBytes {
        i = i | Int64(T(bitPattern: UInt64(bytes[maxBytes - j - 1]))) << Int64(j * 8)
    }
    return T(truncatingIfNeeded: i)
}


// MARK: - Generic Byte Array function
func getGenericByteArray<T : GenericIntegerType>(_ unsInt : T) -> [UInt8] where T : UnsignedInteger, T : ByteArrayType {
    let sizeofT = MemoryLayout<T>.size
    var ret = [UInt8](repeating: 0, count: sizeofT)
    
    for j in 0 ..< sizeofT {
        ret[sizeofT - j - 1] = UInt8((UInt64(unsInt) >> UInt64(j * 8)) & 0xFF)
    }
    
    return ret
}


func getGenericByteArray<T : GenericIntegerType>(_ unsInt : T) -> [UInt8] where T : SignedInteger, T : ByteArrayType {
    let sizeofT = MemoryLayout<T>.size
    var ret = [UInt8](repeating: 0, count: sizeofT)
    
    for j in 0 ..< sizeofT {
        ret[sizeofT - j - 1] = UInt8((Int64(unsInt) >> Int64(j * 8)) & 0xFF)
    }
    
    return ret
}
