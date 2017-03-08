import Cocoa

// NOTE GeneratorType has been renamed to IteratorProtocol
struct StackGenerator<T>: IteratorProtocol {
    typealias Element = T  // NOTE this is verbose, can remove it...
    
    var stack: Stack<T>
    mutating func next() -> Element? {  // ...then replace Element? with T?
        return stack.pop()
    }
}

// NOTE SequenceType has been renamed to Sequence
struct Stack<Element>: Sequence {
    var items = [Element]()
    mutating func push(newItem: Element) {
        items.append(newItem)
    }
    mutating func pop() -> Element? {
        guard !items.isEmpty else {
            return nil
        }
        return items.removeLast()
    }
    
    func map<U>(f: (Element) -> U) -> Stack<U> {
        var mappedItems = [U]()
        for item in items {
            mappedItems.append(f(item))
        }
        return Stack<U>(items: mappedItems)
    }
    
    // NOTE SequenceType.generate() is now Sequence.makeIterator()
    func makeIterator() -> StackGenerator<Element> {
        return StackGenerator(stack: self)
    }
}

var intStack = Stack<Int>()
intStack.push(newItem: 1)
intStack.push(newItem: 2)
var doubledStack = intStack.map(f: { 2 * $0 })

print(intStack.pop()) // Prints Optional(2)
print(intStack.pop()) // Prints Optional(1)
print(intStack.pop()) // Prints nil

print(doubledStack.pop()) // Prints Optional(4)
print(doubledStack.pop()) // Prints Optional(2)

var stringStack = Stack<String>()
stringStack.push(newItem: "this is a string")
stringStack.push(newItem: "another string")
print(stringStack.pop()) // Prints Optional("another string")

func myMap<T,U>(items: [T], f: (T) -> (U)) -> [U] {
    var result = [U]()
    for item in items {
        result.append(f(item))
    }
    return result
}

let strings = ["one", "two", "three"]
let stringLengths = myMap(items: strings) { $0.characters.count }
print(stringLengths) // Prints [3, 3, 5]

// NOTE I removed the underscore before second
func checkIfEqual<T: Equatable>(first: T, second: T) -> Bool {
    return first == second
}

print(checkIfEqual(first: 1, second: 1))
print(checkIfEqual(first: "a string", second: "a string"))
print(checkIfEqual(first: "a string", second: "a different string"))

func checkIfDescriptionsMatch<T: CustomStringConvertible, U: CustomStringConvertible>(
    first: T, second: U) -> Bool {
    return first.description == second.description
}

// NOTE removed underscore again
print(checkIfDescriptionsMatch(first: Int(1), second: UInt(1)))
print(checkIfDescriptionsMatch(first: 1, second: 1.0))
print(checkIfDescriptionsMatch(first: Float(1.0), second: Double(1.0)))

var myStack = Stack<Int>()
myStack.push(newItem: 10)
myStack.push(newItem: 20)
myStack.push(newItem: 30)

var myStackGenerator = StackGenerator(stack: myStack)
while let value = myStackGenerator.next() {
    print("got \(value)")
}
// NOTE this ^^ was destructive on the stack, but it was a copy, so we can
//      still use myStack below

for value in myStack {
    print("for-in loop: got \(value)")
}

// NOTE 'where' clause next to generic parameter is deprecated, so moved to end of signature
//      also replaced S.Generator with S.Iterator
func pushItemsOntoStack<Element, S: Sequence>( stack: inout Stack<Element>, fromSequence sequence: S)
    where S.Iterator.Element == Element {
    for item in sequence {
        stack.push(newItem: item)
    }
}


pushItemsOntoStack(stack: &myStack, fromSequence: [1, 2, 3])
    for value in myStack {
        print("after pushing: got \(value)")
}

var myOtherStack = Stack<Int>()
pushItemsOntoStack(stack: &myOtherStack, fromSequence: [1, 2, 3])
pushItemsOntoStack(stack: &myStack, fromSequence: myOtherStack)
for value in myStack {
    print("after pushing items onto stack, got \(value)")
}





