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
}

var intStack = Stack<Int>()
intStack.push(newItem: 1)
intStack.push(newItem: 2)

print(intStack.pop()) // Prints Optional(2)
print(intStack.pop()) // Prints Optional(1)
print(intStack.pop()) // Prints nil

var stringStack = Stack<String>()
stringStack.push(newItem: "this is a string")
stringStack.push(newItem: "another string")
print(stringStack.pop()) // Prints Optional("another string")