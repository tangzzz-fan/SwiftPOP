//: [Previous](@previous)

import Foundation

var greeting = "Associated types with protocols"

protocol DataStore {
    associatedtype T
    var items: [T] { get set }
    mutating func addItem(_ item: T)
    mutating func removeItem(_ item: T)
}

struct IntegerStore: DataStore {
    typealias T = Int
    var items: [Int] = []
    
    mutating func addItem(_ item: Int) {
        items.append(item)
    }
    
    mutating func removeItem(_ item: Int) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}

var intStore = IntegerStore()
intStore.addItem(42)
intStore.addItem(17)
print(intStore.items) // 输出: [42, 17]
intStore.removeItem(42)
print(intStore.items) // 输出: [17]

//: [Next](@next)
