import Cocoa

struct Stack<Element> {
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