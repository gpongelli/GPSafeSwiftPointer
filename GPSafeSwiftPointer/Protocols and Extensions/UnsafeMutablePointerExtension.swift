//
//  UnsafeMutablePointerExtension.swift
//  GPSafeSwiftPointer
//
//  Created by Gabriele on 26/07/15.
//  Copyright © 2015 Gabriele Pongelli. All rights reserved.
//

import Foundation

extension UnsafeMutablePointer where T : ByteArrayType {
    func returnByteArray() -> [UInt8] {
        return self.memory.getByteArray()
    }
}

