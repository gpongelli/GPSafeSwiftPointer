//
//  GPSafeSwiftPointerTests.swift
//  GPSafeSwiftPointerTests
//
//  Created by Gabriele on 16/07/15.
//  Copyright © 2015 Gabriele Pongelli. All rights reserved.
//

import XCTest


class GPSafeSwiftPointerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTypeOf() {
        let myType = type(of: GPSafeSwiftPointer<UInt8>().ump.self)
        let originalType = UnsafeMutablePointer<UInt8>.self
        
        XCTAssert( originalType == myType , "Different Type")
    }
    
    func testSubscript() {
        let anUmp = GPSafeSwiftPointer<UInt8>(allocatedMemory: 2)
        anUmp[0] = 4
        anUmp[1] = 7
        
        XCTAssertEqual(anUmp[0]!, 4, "Subscription error")
        XCTAssertEqual(anUmp[1]!, 7, "Subscription error")
        XCTAssertNil(anUmp[2] as AnyObject?, "Subscription error")
    }
    
    func testConvenienceInit() {
        let anUmp = GPSafeSwiftPointer<UInt8>(initializeWithValue: 11)
        
        XCTAssertEqual(anUmp[0]!, 11, "Init error")
        XCTAssertNil(anUmp[1] as AnyObject?, "Init error")
    }
    
    func testConvenienceInitArray() {
        let anUmpArray : [UInt8] = [1, 3];
        let anUmp = GPSafeSwiftPointer<UInt8>(initializeWithValue: anUmpArray)
        
        XCTAssertEqual(anUmp[0]!, 1, "Init error")
        XCTAssertEqual(anUmp[1]!, 3, "Init error")
    }
    
    func testUIntToByteArray() {

        let anUint8 : UInt8 = 226
        XCTAssertEqual(anUint8.getByteArray(), [226], "ByteArray Error")
        
        let anUint16 : UInt16 = 24288
        XCTAssertEqual(anUint16.getByteArray(), [94, 224], "ByteArray Error")
        
        let anUint32 : UInt32 = 43605
        XCTAssertEqual(anUint32.getByteArray(), [0, 0, 170, 85], "ByteArray Error")

        let anUint64 : UInt64 = 4313256763419
        XCTAssertEqual(anUint64.getByteArray(), [0, 0, 3, 236, 66, 35, 32, 27], "ByteArray Error")
    }
    
    func testByteArrayToUInt() {
        
        let anUint8ByteArr : [UInt8] = [226]
        XCTAssertEqual((integerWithBytes(anUint8ByteArr) as UInt8?)!, 226 as UInt8, "ByteArray Error")
        
        let anUint16ByteArr : [UInt8] = [94, 224]
        XCTAssertEqual((integerWithBytes(anUint16ByteArr) as UInt16?)!, 24288 as UInt16, "ByteArray Error")
        
        let anUint32ByteArr : [UInt8] = [0, 0, 170, 85]
        XCTAssertEqual((integerWithBytes(anUint32ByteArr) as UInt32?)!, 43605 as UInt32, "ByteArray Error")
        
        let anUint64ByteArr : [UInt8] = [0, 0, 3, 236, 66, 35, 32, 27]
        XCTAssertEqual((integerWithBytes(anUint64ByteArr) as UInt64?)!, 4313256763419 as UInt64, "ByteArray Error")
    }
    
    func testIntToByteArray() {
        
        let anUint8 : Int8 = -22
        XCTAssertEqual(anUint8.getByteArray(), [234], "ByteArray Error")
        
        let anUint16 : Int16 = -24288
        XCTAssertEqual(anUint16.getByteArray(), [161, 32], "ByteArray Error")
        
        let anUint32 : Int32 = -43605
        XCTAssertEqual(anUint32.getByteArray(), [255, 255, 85, 171], "ByteArray Error")
        
        let anUint64 : Int64 = -4313256763419
        XCTAssertEqual(anUint64.getByteArray(), [255, 255, 252, 19, 189, 220, 223, 229], "ByteArray Error")
    }
    
    func testByteArrayToInt() {
        
        let anInt8ByteArr : [UInt8] = [234]
        XCTAssertEqual((integerWithBytes(anInt8ByteArr) as Int8?)!, -22 as Int8, "ByteArray Error")
        
        let anInt16ByteArr : [UInt8] = [161, 32]
        XCTAssertEqual((integerWithBytes(anInt16ByteArr) as Int16?)!, -24288 as Int16, "ByteArray Error")
        
        let anInt32ByteArr : [UInt8] = [255, 255, 85, 171]
        XCTAssertEqual((integerWithBytes(anInt32ByteArr) as Int32?)!, -43605 as Int32, "ByteArray Error")
        
        let anInt64ByteArr : [UInt8] = [255, 255, 252, 19, 189, 220, 223, 229]
        XCTAssertEqual((integerWithBytes(anInt64ByteArr) as Int64?)!, -4313256763419 as Int64, "ByteArray Error")
    }
    
    func testUnsafeMutablePointer() {
        let ump = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        ump.initialize(to: 1054)
        XCTAssertEqual(ump.returnByteArray(), [0, 0, 4, 30], "UnsafeMutablePointer getByteArray Error")
        ump.deinitialize()
        ump.deallocate(capacity: 1)
    }
    
    func testGPSafeGetByteArray() {
        let gpSafe = GPSafeSwiftPointer<UInt32>(allocatedMemory: 2)
        gpSafe[0] = 1054
        gpSafe[1] = 7
        XCTAssertEqual(gpSafe.getByteArray(), [0, 0, 0, 7, 0, 0, 4, 30], "GPSafeSwiftPointer getByteArray Error")
    }
    
    func testUnsafeBitCast() {
        let gpSafe = GPSafeSwiftPointer<UInt8>(initializeWithValue: 5)
        XCTAssertNotEqual(UInt(bitPattern: gpSafe.ump), 5, "Unsafe bit cast error")
        
        // for educational purpose, gpSafe.ump contains the hexadecimal address and not the value
        //print(gpSafe.ump)
        
        // gpSafe.ump[0] can be cast only to UnsafeMutablePointer type, otherwise error
        XCTAssertEqual(gpSafe.ump[0], 5, "Unsafe bit cast of pointed value error")
    }
}
