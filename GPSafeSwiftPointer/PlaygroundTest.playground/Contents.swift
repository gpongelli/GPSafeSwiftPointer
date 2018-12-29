//: Playground - noun: a place where people can play

import Cocoa
import Security
import Foundation

public class GPSafeSwiftPointers<TYPE> : NSObject {
    
    public let allocatedMemory : Int
    
    public var unsafeMutablePointer : UnsafeMutablePointer<TYPE>
    
    public var sizeofType : Int {
        get {
            return MemoryLayout<TYPE>.size
        }
    }
    
    private func isAllowed(idx : Int) -> Bool {
        return idx < self.allocatedMemory
    }
    
    subscript(idx: Int) -> TYPE? {
        get {
            if (!isAllowed(idx: idx)) {
                return nil
            }
            
            return unsafeMutablePointer[idx]
        }
        
        set (newValue) {
            if (!isAllowed(idx: idx)) {
                return
            }
            
            var temp = unsafeMutablePointer
            
            for _ in 0 ..< idx {
                temp = temp.successor()
            }
            temp.initialize(to: newValue!)
        }
    }
    
    required public init(allocatedMemory: Int = 1) {
        self.allocatedMemory = allocatedMemory
        
        unsafeMutablePointer = UnsafeMutablePointer<TYPE>.allocate(capacity: self.allocatedMemory)
    }
    
    convenience public init(initializeWithValue: TYPE) {
        self.init()
        
        unsafeMutablePointer.initialize(to: initializeWithValue)
    }
    
    public func castSafePointer<TO_TYPE>(/*aGPSafePointer : GPSafeSwiftPointers<TYPE>*/) -> TO_TYPE? {
        if ( (self.allocatedMemory * self.sizeofType) == MemoryLayout<TO_TYPE>.size ) {
            return unsafeBitCast(self.unsafeMutablePointer, to: TO_TYPE.self)
        } else {
            return nil
        }
    }
    
    deinit {
        unsafeMutablePointer.deinitialize(count: self.allocatedMemory)
        unsafeMutablePointer.deallocate()
    }
}



// Random content from previous content of pointed memory area
var test = GPSafeSwiftPointers<UInt8>(allocatedMemory: 8)
test[0]
test.unsafeMutablePointer.pointee
test[1]
test[2]
test[3]
test[4]
test[5]
test[6]
test[7]


// Randomize pointed values
SecRandomCopyBytes(kSecRandomDefault, 8, test.unsafeMutablePointer)
test[0]
test[1]
test[2]
test[3]
test[4]
test[5]
test[6]
test[7]

let hexStr0 = String (test.unsafeMutablePointer.pointee, radix: 16, uppercase: false)
let hexStr1 = String (test.unsafeMutablePointer.successor().pointee, radix: 16, uppercase: false)
let hexStr2 = String (test.unsafeMutablePointer.successor().successor().pointee, radix: 16, uppercase: false)
let hexStr3 = String (test.unsafeMutablePointer.successor().successor().successor().pointee, radix: 16, uppercase: false)
let hexStr4 = String (test.unsafeMutablePointer.successor().successor().successor().successor().pointee, radix: 16, uppercase: false)
let hexStr5 = String (test.unsafeMutablePointer.successor().successor().successor().successor().successor().pointee, radix: 16, uppercase: false)
let hexStr6 = String (test.unsafeMutablePointer.successor().successor().successor().successor().successor().successor().pointee, radix: 16, uppercase: false)
let hexStr7 = String (test.unsafeMutablePointer.successor().successor().successor().successor().successor().successor().successor().pointee, radix: 16, uppercase: false)

let hexValue0 = UInt8(hexStr0.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue1 = UInt8(hexStr1.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue2 = UInt8(hexStr2.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue3 = UInt8(hexStr3.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue4 = UInt8(hexStr4.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue5 = UInt8(hexStr5.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue6 = UInt8(hexStr6.replacingOccurrences(of: "0x", with: ""), radix: 16)
let hexValue7 = UInt8(hexStr7.replacingOccurrences(of: "0x", with: ""), radix: 16)


let iby : [UInt8?] = [ hexValue7, hexValue6, hexValue5, hexValue4, hexValue3, hexValue2, hexValue1, hexValue0 ]
let data = NSData(bytes: iby, length: 16)
var value : UInt = 0
data.getBytes(&value, length: 8)
value = UInt(bigEndian: value)


/*
let by = [ hex0, hex1, hex2 ,hex3, hex4, hex5, hex6, hex7 ]
let u32 = UnsafeMutablePointer<UInt>(by).pointee
let u64 = UnsafeMutablePointer<UInt64>(by).pointee


let iby = [ hex7, hex6, hex5 ,hex4, hex3, hex2, hex1, hex0 ]
let iu32 = UnsafeMutablePointer<UInt>(iby).pointee
let iu64 = UnsafeMutablePointer<UInt64>(iby).pointee
*/

//test.unsafeMutablePointer.memory
//test.unsafeMutablePointer.successor().memory

let random = UInt(bitPattern: test.unsafeMutablePointer)

var tt : UInt? = test.castSafePointer()
print("safePoint: \(tt!)")

MemoryLayout<UInt>.size
test.allocatedMemory
test.sizeofType

// tt : UInt -> == true
tt==random

print("orig: \(random)")
MemoryLayout.size(ofValue: random)

// puntatori di 8 byte su macchine x86_64
MemoryLayout.size(ofValue: test.unsafeMutablePointer)
MemoryLayout<UnsafeMutablePointer<UInt8>>.size


MemoryLayout<UInt>.size
MemoryLayout<UInt8>.size
MemoryLayout<UInt16>.size
MemoryLayout<UInt32>.size
MemoryLayout<UInt64>.size


// ---
let variab : UInt8 = 15
let aPoint = GPSafeSwiftPointers<UInt8>(initializeWithValue: variab)
aPoint.unsafeMutablePointer.pointee == variab
// ---
/*
let apt = GPSafeSwiftPointers<UInt8>(allocatedMemory: 2)
/*var tt1 : UInt? = apt.castSafePointer()
apt[0] = 5
apt[1] = 7
apt[2] = 0
apt[3] = 0
//apt[4] = 3
*/
apt[0]
apt[1]
//apt[4]



apt.allocatedMemory
apt.sizeofType
MemoryLayout<UInt16>.size



let bytes:[UInt8] = [0x01, 0x02]
let u16 = UnsafePointer<UInt16>(bytes).pointee  //0x02 0x01 = 513
print("u16: \(u16)") // u16: 513


//var tt2 : UInt16? = apt.castSafePointer()

/*apt.unsafeMutablePointer.initialize(1)
apt.unsafeMutablePointer.memory

apt.unsafeMutablePointer.successor().initialize(3)
apt.unsafeMutablePointer.memory
apt.unsafeMutablePointer.successor().memory
apt.unsafeMutablePointer.successor().successor().memory
apt.unsafeMutablePointer.successor().successor().successor().memory */
*/
