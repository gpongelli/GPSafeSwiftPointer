# GPSafeSwiftPointer
A framework containing a safe wrapper for UnsafeMutablePointer with integer to byte array generics.

## Requirements
- Xcode 7
- Swift 2

## Motivation
Why I made this framework? Because I found UnsafeMutablePointer very **unsafe** .
[UnsafeMutablePointer Reference](https://developer.apple.com/library/prerelease/mac/documentation/Swift/Reference/Swift_UnsafeMutablePointer_Structure/index.html#//apple_ref/swift/structcm/UnsafeMutablePointer/s:ZFVSs20UnsafeMutablePointer5allocurFMGS_q__FSiGS_q__) for alloc method defines
> Allocate memory for num objects of type Memory.

So it's expected to 
```swift
let test = UnsafeMutablePointer<UInt8>.alloc(1)
test[0] = 5
print(test[0])  // correctly prints 5
```

but it's not expected to have these result IMHO
```swift
print(test[1])  // why prints 0 ?!
print(test[2])  // why again prints 0 ?!
...
print(test[7])  // why prints 127 ?!
```
Playground are you serious :flushed: :interrobang: :interrobang:

This is one of the reason I created this class, having these results
```swift
let test = GPSafeSwiftPointer<UInt8>()  // pointer to one UInt8
test[0] = 5
print(test[0])  // correctly prints Optional(5)
print(test[1])  // correctly returns nil 
...
test[2] = 4  // this instruction returns without setting any value
print(test[2])  // correctly returns nil as before
```

Another reason that let me create this framework was about memory management, because after `alloc()` and `initialize()` it's developer's responsibility to call `dealloc()` and `destroy()`; this class automatically call these methods on deinit.


## Installation
### Carthage
TODO


## Usage
Some simple usage are reported here, some usage are already showed in motivation paragraph, for other example see iOS tests file.

### Initialization
GPSafeSwiftPointer variables can be initializated as follows
1. let test = GPSafeSwiftPointer<_type_>()  // alloc one element of type _type_
2. let test = GPSafeSwiftPointer<_type_>(allocatedMemory: _k_)  // alloc _k_ elements of type _type_
3. let test = GPSafeSwiftPointer<_type_>(initializeWithValue: _n_)  // alloc one element of type _type_ initialized with value _n_

### Underlying UnsafeMutablePointer
Having a 
```
let test = GPSafeSwiftPointer<TYPE>() 
test.ump 
```
returns the underlying UnsafeMutablePointer<TYPE> to be used when calling Apple methods as I do for `SecRandomCopyBytes` .

### Byte Array Protocol for Integers
Test file contains some tests about all integer types conversion to and from byte array, having Big Endian coding.

So for example, an UInt16 equal to _24288_ will be converted to an array of two UInt8 containing __[94, 224]__ having these representation:
Representation |  MSB     |   LSB
:--------------|:--------:|:--------:
integer        |    94    |   224
binary         | 01011110 | 11100000
hexadecimal    |   0x5E   |   0xE0
Converting back the hexadecimal or binary representation will lead to the original value.

### Byte Array Protocol for UnsafeMutablePointer and GPSafeSwiftPointer
Looking at test file you'll find two test about UnsafeMutablePointer and GPSafeSwiftPointer using Byte Array protocol.

The called method and the results are the same as for simple integer variables, but in this case the pointed integer is used without any hassle.

### UnsafeBitCast 
Using GPSafeSwiftPointer and Byte Array protocol to return the contained value as byte array, it can be avoided to use unsafeBitCast to have the pointed value casted as another type as erroneously wrote in some blog post around internet, :arrow_right: Swift prevents to do this :arrow_left: .

Looking at the relative test, it's clear that an UnsafeMutablePointer of any type casted to UInt (32 bit) does not return the pointed value; inspecting the results with playground it's easy to see that the returned value is the **address** that UnsafeMutablePointer contains, not it's **pointed value** .

The only unsafeBitCast that works is to the same type of original pointed type, as showed inside the test.

A typical example I use for GPSafeSwiftPointer instead of unsafeBitCast is when generating random bytes with `SecRandomCopyBytes` .

## Author
Gabriele Pongelli

## Contribution
Thanks to @krzyzanowskim to his [gist](https://gist.github.com/krzyzanowskim/c84d039d1542c1a82731), I've included his code inside this project adding some changes I commented to his gist simply because I prefer Big Endian to Little Endian representation.


### License
GPSafeSwiftPointer is available under the MIT license. See the LICENSE file for more info.
