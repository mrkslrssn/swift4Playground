//: Playground - noun: a place where people can play

import UIKit

// Private access control for extensions

/*
struct Date: Equatable, Comparable {
    private let secondsSinceReferenceDate: Double

    static func ==(lhs: Date, rhs: Date) -> Bool {
        return lhs.secondsSinceReferenceDate == rhs.secondsSinceReferenceDate
    }

    static func <(lhs: Date, rhs: Date) -> Bool {
        return lhs.secondsSinceReferenceDate < rhs.secondsSinceReferenceDate
    }
}
*/

// Separate into extensions

/*
 In Swift 4 extensions can access private properties if they live in the same class.
 In Swift 3 this was not possible, it had to be fileprivate and exposed to the whole file.
*/

struct Date {
    private let secondsSinceReferenceDate: Double
}

extension Date: Equatable {
    static func ==(lhs: Date, rhs: Date) -> Bool {
        return lhs.secondsSinceReferenceDate == rhs.secondsSinceReferenceDate
    }
}

extension Date: Comparable {
    static func <(lhs: Date, rhs: Date) -> Bool {
        return lhs.secondsSinceReferenceDate < rhs.secondsSinceReferenceDate
    }
}

// Composing classes and protocols

protocol Shakeable {
    func shake()
}

extension UIButton: Shakeable {
    func shake() { /* ... */ }
}
extension UISlider: Shakeable {
    func shake() { /* ... */ }
}

/*
func shakeEm(controls: [/* No type to specify here???... all Shakeable is not UIControl, all UIControl is not shakeable */]) {
    for control in controls where control.state.isEnabled {
        control.shake()
    }
}
*/

/*
 In Swift 4 we can compose a class with any number of protocols
 */

func shakeEm(controls: [UIControl & Shakeable]) {
    for control in controls where control.isEnabled {
        control.shake()
    }
}

/*
 This is something that has been missing from objective-c
 @interface NSCandidateListTouchBarItem<CandidateType> : NSTouchBarItem
 @property (nullable, weak) NSView <NSTextInputClient> *client;
 @end

 This type was not representable in Swift 3

 class NSCandidateListTouchBarItem<CandidateType: AnyObject> : NSTouchBarItem {
     var client: NSView?
 }

 // Swift 4, its possible to map all the api:s appropriately

 class NSCandidateListTouchBarItem<CandidateType: AnyObject> : NSTouchBarItem {
     var client: (NSView & NSTextInputClient)?
 }

 */

protocol SomeProtocol {}
protocol SomeProtocol2 {}

class SomeClass {}
class SomeSubclass: SomeClass, SomeProtocol {}
class SomeSubclass2: SomeClass, SomeProtocol, SomeProtocol2 {}

class AnotherClass {
    var delegate: (SomeClass & SomeProtocol)?
}

let anotherClass = AnotherClass()
// anotherClass.delegate = SomeClass() // error: cannot assign value of type 'SomeClass' to type '(SomeClass & SomeProtocol)?'
anotherClass.delegate = SomeSubclass()
anotherClass.delegate = SomeSubclass2()

// Swift 4 - improving cocoa idioms, whats new in Foundation separate talk

// - Smart KeyPaths: Better key-value coding for Swift
// - Swift archival & serialization
// - Swift encoders

/*
 Swift 4 source compatibility, mostly Swift 3 compatible mostly refinements and SDK improvements.
 Additive features that extends the existing syntax.

 Swift 3.2 is a compilation mode of the Swift 4 compiler (Not a separate toolchain)
 It emulates Swift 3 for the Swift 4 compiler for a smother migration. This makes Swift 3 projects build and run without issues on the Swift 4 compiler.

 Swift 3.2 and Swift 4 can co-exists in the same application, the language is set on target level. So app target can be migrated without the need for migrate all dependecies and frameworks in order and at the same time.
 */

/*
 Swift Package Manager improvements for server-side Swift
 */

/*
 New Build System written in Swift on top off the open-source LLBuild engine that promise to be faster, lower overhead for large projects especially for incremental builds. Improved Indexing, now part of the build step and not running in the background. This is available as an technology preview in the Project Settings of Xcode 9.

 Xcode 9 also introduces precompiled bridging headers to speed up compile time for large projects with mixed source files.

 Code size improvements with minimal inference, Swift 4 compiler will automatically optimise away conformances that are unused. For example if the comparable Date struct extension is not used.

 Another improvement is the symbol tables size, Swift 3 uses a lot of symbols with long names, of the standard library in Swift 3 almost half the size was taken up by symbols. In Swift 4 this has been reduced a lot even though there is more content the overall size has decresed. The symbol table size has be reduced to ~one-fifh. Build setting
 */

/* Another example is @objc Thunks. Can be enable as part of the Swift 4 migration step but might need some manual work with the help of deprecation warnings. */

class SomeNSObjectClass: NSObject {
    func print() { /* ... */ } // -> Swift 3, automatically infers @objc func print() <- [SomeClass print] in this case as it derives from NSObject, but if only called within Swift is directly and the Thunk func will remain unused. In Swift 4 @objc is only inferred when its absolutly needed such as overriding Objective-C method or conforming to Objective-C protocol
}
