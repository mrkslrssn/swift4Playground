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

 Swift 3.2 is a compilation mode of the Swift 4 compiler (not a separate toolchain)
 It emulates Swift 3 for the Swift 4 compiler for a smoother migration. This makes Swift 3 projects build and run without issues on the Swift 4 compiler.

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


// Strings

/*
 # Ruby

 one = "\u{E9}"         // -> é
 two = "\u{65}\u{301}"  // -> é

 one.length // -> 1
 two.length // -> 2

 one == two // -> false

 Strict Swift takes a different approach, a Character is a grapheme.

 twoCodeUnits.count // -> 1
 oneCodeUnit == twoCodeUnits // true

 */

var family = "👩"
family += "\u{200D}👩"
family += "\u{200D}👧"
family += "\u{200D}👦"

family.count // -> 1 before 6



// Swift 3 strings had a collection of characters, which was a bit messy.

/*
let values = "one,two,three..."
var i = values.characters.startIndex

while let comma = values.characters[i..<values.characters.endIndex].index(of: ",") {
    if values.characters[i..<comma] == "two" {
        print("found it!")
    }
    i = values.characters.index(after: comma)
}
*/

//  In Swift 4 strings are an collection of characters.

/*
let values = "one,two,three..."
var i = values.startIndex
while let comma = values[i..<values.endIndex].index(of: ",") {
    if values[i..<comma] == "two" {
        print("found it!")
    }
    i = values.index(after: comma)
}
*/

// One sided ranges are also introduced, the above can now be written like:

let values = "one,two,three..."
var i = values.startIndex
while let comma = values[i...].index(of: ",") {
    if values[i..<comma] == "two" {
        print("found it!")
    }
    i = values.index(after: comma)
}

// In Swift 4 its now possible to access the underlaying scalar Character has a unicodeScalars

// Using String as a Collection

extension Unicode.Scalar {
    var isRegionalIndicator: Bool {
        return ("🇦"..."🇿").contains(self)
    }
}

extension Character {
    var isFlag: Bool {
        let scalars = self.unicodeScalars
        return scalars.count == 2
            && scalars.first!.isRegionalIndicator
            && scalars.last!.isRegionalIndicator
    }
}

let str = "Good luck 🇹🇼 in the game tonight!"

str.contains { $0.isFlag } // -> true
let flags = str.filter { $0.isFlag }
print(flags) // -> "🇹🇼"
flags.count // -> 1

// Multi-line String Literals

let string = """
    Swift 4 continues the evolution of the safe, fast, and expressive language, with better performance and new features.
    Learn about the new String and improved generics, see how Swift 4 maintains support for your existing Swift 3 code,
    and get insight into where Swift is headed in the future."
    """

// Generic features

/*
 Added associatedtype constraints:

 // Example Swift 3 Sequence

 protocol Sequence {
     associatedtype Iterator: IteratorProtocol

     func makeIterator() -> Iterator
 }

 protocol IteratorProtocol {
     associatedtype Element

     mutating func next() -> Element?
 }

 // Example Swift 4 Sequence

 protocol Sequence {
     associatedtype Element
     associatedtype Iterator: IteratorProtocol where Iterator.Element == Element

     func makeIterator() -> Iterator
 }

 protocol IteratorProtocol {
     associatedtype Element

     mutating func next() -> Element?
 }

 */

// Generic subscripts




