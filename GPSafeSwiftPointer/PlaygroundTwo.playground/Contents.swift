import Cocoa
import Foundation

typealias Byte = UInt8

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


extension Int:GenericIntegerType, GenericSignedIntegerBitPattern  {
    init(bitPattern: UInt64) {
        self.init(bitPattern: UInt(truncatingIfNeeded: bitPattern))
    }
}
extension UInt:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int8:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt8(truncatingIfNeeded: bitPattern))
    }
}
extension UInt8:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int16:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt16(truncatingIfNeeded: bitPattern))
    }
}
extension UInt16:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int32:GenericIntegerType, GenericSignedIntegerBitPattern {
    public init(bitPattern: UInt64) {
        self.init(bitPattern: UInt32(truncatingIfNeeded: bitPattern))
    }
}
extension UInt32:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int64:GenericIntegerType, GenericSignedIntegerBitPattern {
    // init(bitPattern: UInt64) already defined
    
    init(truncatingBitPattern: Int64) {
        self.init(truncatingBitPattern)
    }
}
extension UInt64:GenericIntegerType, GenericUnsignedIntegerBitPattern {
    // init(bitPattern: Int64) already defined
    
    init(truncatingBitPattern: UInt64) {
        self.init(truncatingBitPattern)
    }
}

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


let bytes:[UInt8] = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
print("\(integerWithBytes(bytes) as Int8?)")
print("\(integerWithBytes(bytes) as UInt8?)")
print("\(integerWithBytes(bytes) as Int16?)")
print("\(integerWithBytes(bytes) as UInt16?)")
print("\(integerWithBytes(bytes) as Int32?)")
print("\(integerWithBytes(bytes) as UInt32?)")
print("\(integerWithBytes(bytes) as Int64?)")
print("\(integerWithBytes(bytes) as UInt64?)")

//---
func getGenericByteArray<T : GenericIntegerType>(from: T) -> [UInt8] where T : UnsignedInteger, T : ByteArrayType {
    let sizeofT = MemoryLayout<T>.size
    var ret = [UInt8](repeating: 0, count: sizeofT)
    
    for j in 0 ..< sizeofT {
        ret[sizeofT - j - 1] = UInt8((UInt64(from) >> UInt64(j * 8)) & 0xFF)
    }
    
    return ret
}


func getGenericByteArray<T : GenericIntegerType>(from: T) -> [UInt8] where T : SignedInteger, T : ByteArrayType {
    let sizeofT = MemoryLayout<T>.size
    var ret = [UInt8](repeating: 0, count: sizeofT)
    
    for j in 0 ..< sizeofT {
        ret[sizeofT - j - 1] = UInt8((Int64(from) >> Int64(j * 8)) & 0xFF)
    }
    
    return ret
}


protocol ByteArrayType {
    func getByteArray() -> [UInt8]
}


extension UInt8 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
    }
}

extension Int8 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
    }
}


extension Int16 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
    }
}

extension Int32 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
    }
}

extension Int64 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
    }
}


extension UInt16 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
        /*return [UInt8(self >> 8), UInt8(self & 0xFF)]*/
    }
}

extension UInt32 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
        /*return [    UInt8((self >> 24) & 0xFF),
                    UInt8((self >> 16) & 0xFF),
                    UInt8((self >> 8) & 0xFF),
                    UInt8(self & 0xFF)
               ]*/
    }
}



extension UInt64 : ByteArrayType {
    func getByteArray() -> [UInt8] {
        return getGenericByteArray(from: self)
        /*return [    UInt8((self >> 56) & 0xFF),
                    UInt8((self >> 48) & 0xFF),
                    UInt8((self >> 40) & 0xFF),
                    UInt8((self >> 32) & 0xFF),
                    UInt8((self >> 24) & 0xFF),
                    UInt8((self >> 16) & 0xFF),
                    UInt8((self >> 8) & 0xFF),
                    UInt8(self & 0xFF)
                ] */
    }
}




let x : UInt32 = 43605
getGenericByteArray(from: x)
x.getByteArray()

integerWithBytes(getGenericByteArray(from: x)) as UInt32?

// TEST integer type
let a1 : UInt32 = 320
print(getGenericByteArray(from: a1))
print(a1.getByteArray())


extension UnsafeMutablePointer where Pointee : ByteArrayType {
    func returnByteArray() -> [UInt8] {
        return self.pointee.getByteArray()
    }
}


public class GPSafeSwiftPointers<TYPE> : NSObject {
    
    private let allocatedMemory : Int
    
    
    public var unsafeMutablePointer : UnsafeMutablePointer<TYPE>
    
    
    public var sizeofType : Int {
        get {
            return MemoryLayout<TYPE>.size
        }
    }
    
    required public init(allocatedMemory : Int = 1) {
        self.allocatedMemory = allocatedMemory
        unsafeMutablePointer = UnsafeMutablePointer<TYPE>.allocate(capacity: self.allocatedMemory)
    }
    
    convenience public init(initializeWithValue : TYPE) {
        self.init()
        
        unsafeMutablePointer.initialize(to: initializeWithValue)
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
            unsafeMutablePointer[idx] = newValue!
        }
    }
    
    
    public func castSafePointer<TO_TYPE>() -> TO_TYPE? {
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

extension GPSafeSwiftPointers where TYPE : ByteArrayType {
    func getByteArray() -> [UInt8] {
        var ret = [UInt8]()
        
        for i in (0...self.allocatedMemory - 1).reversed() {
            ret.append(contentsOf: self[i]!.getByteArray() )
        }
        
        return ret
    }
}

let tGP = GPSafeSwiftPointers<UInt32>(allocatedMemory: 2)
tGP[0] = 1054
tGP[1] = 7
tGP.getByteArray()
tGP[3] == nil


let un = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
un[0] = 50
un[1] = 20
un[2] = 1
un[3] = 1

print("\(un.pointee)")  //50
print("\(un.successor().pointee)")  //20

print("\(un[0])")  //50
print("\(un[1])")  //20
print("\(un[6])")  // 0
print("\(un[7])")  // WHY can I access there ??


let pi = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
pi[0] = 1054
let ba = pi.returnByteArray()
print("byteArr: \(ba)")
print("BA: \(integerWithBytes(ba) as UInt32?)")


let anUint64 : UInt64 = 4313256763419
anUint64.getByteArray()

let anUint8 : Int64 = -4313256763419
anUint8.getByteArray()

let anInt : Int8 = -3
anInt.getByteArray()

let by:[UInt8] = [253]
integerWithBytes(by) as Int8?



let anInt8ByteArr : [UInt8] = [234]
integerWithBytes(anInt8ByteArr) as Int8?

let anInt16ByteArr : [UInt8] = [161, 32]
integerWithBytes(anInt16ByteArr) as Int16?

let anInt32ByteArr : [UInt8] = [255, 255, 85, 171]
integerWithBytes(anInt32ByteArr) as Int32?

let anInt64ByteArr : [UInt8] = [255, 255, 252, 19, 189, 220, 223, 229]
integerWithBytes(anInt64ByteArr) as Int64?
