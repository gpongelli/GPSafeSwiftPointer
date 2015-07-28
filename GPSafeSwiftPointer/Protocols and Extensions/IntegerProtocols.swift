//
//  IntegerProtocols.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 26/07/15.
//  Copyright © 2015 Gabriele Pongelli. All rights reserved.
//
// For GenericIntegerType, GenericSignedIntegerBitPattern, 
//  GenericUnsignedIntegerBitPattern and integerWithBytes
//  credits to https://gist.github.com/krzyzanowskim/c84d039d1542c1a82731

import Foundation

typealias Byte = UInt8

// MARK: - Generic Integer Protocols
protocol GenericIntegerType: IntegerType {
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
    init(bitPattern: UIntMax)
    init(truncatingBitPattern: IntMax)
}

protocol GenericUnsignedIntegerBitPattern {
    init(truncatingBitPattern: UIntMax)
}


// MARK: - Byte Array protocol
protocol ByteArrayType {
    func getByteArray() -> [UInt8]
}


// MARK: - Generic Functions
func integerWithBytes<T: GenericIntegerType where T: UnsignedIntegerType, T: GenericUnsignedIntegerBitPattern>(bytes:[UInt8]) -> T? {
    if (bytes.count < sizeof(T)) {
        return nil
    }
    
    let maxBytes = sizeof(T)
    var i:UIntMax = 0
    for (var j = 0; j < maxBytes; j++) {
        i = i | T(bytes[maxBytes - j - 1]).toUIntMax() << UIntMax(j * 8)
    }
    return T(truncatingBitPattern: i)
}

func integerWithBytes<T: GenericIntegerType where T: SignedIntegerType, T:  GenericSignedIntegerBitPattern>(bytes:[UInt8]) -> T? {
    if (bytes.count < sizeof(T)) {
        return nil
    }
    
    let maxBytes = sizeof(T)
    var i:IntMax = 0
    for (var j = 0; j < maxBytes; j++) {
        i = i | T(bitPattern: UIntMax(bytes[maxBytes - j - 1].toUIntMax())).toIntMax() << (j * 8).toIntMax()
    }
    return T(truncatingBitPattern: i)
}


// MARK: - Generic Byte Array function
func getGenericByteArray<T : GenericIntegerType where T : UnsignedIntegerType, T : ByteArrayType>(unsInt : T) -> [UInt8] {
    let sizeofT = sizeof(T)
    var ret = [UInt8](count: sizeofT, repeatedValue: 0)
    
    for (var j = sizeofT - 1 ; j >= 0; j--) {
        ret[j] = UInt8((unsInt.toUIntMax() >> UIntMax(j * 8)) & 0xFF)
    }
    
    return ret
}


func getGenericByteArray<T : GenericIntegerType where T : SignedIntegerType, T : ByteArrayType>(unsInt : T) -> [UInt8] {
    let sizeofT = sizeof(T)
    var ret = [UInt8](count: sizeofT, repeatedValue: 0)
    
    for (var j = sizeofT - 1 ; j >= 0; j--) {
        ret[j] = UInt8((unsInt.toIntMax() >> IntMax(j * 8)) & 0xFF)
    }
    
    return ret
}
