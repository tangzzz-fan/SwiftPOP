//: [Previous](@previous)

import Foundation

var greeting = "Type casting with protocols"

protocol Vehicle {
    var make: String { get }
    var model: String { get }
    func drive()
}

class Car: Vehicle {
    let make: String
    let model: String
    
    init(make: String, model: String) {
        self.make = make
        self.model = model
    }
    
    func drive() {
        print("Driving a \(make) \(model)")
    }
}

class Truck: Vehicle {
    let make: String
    let model: String
    
    init(make: String, model: String) {
        self.make = make
        self.model = model
    }
    
    func drive() {
        print("Driving a \(make) \(model) truck")
    }
}

func test() {
    let vehicles: [Vehicle] = [
        Car(make: "Toyota", model: "Camry"),
        Truck(make: "Ford", model: "F-150"),
        Car(make: "Honda", model: "Civic")
    ]

    for vehicle in vehicles {
        if let car = vehicle as? Car {
            car.drive()
        } else if let truck = vehicle as? Truck {
            truck.drive()
        }
    }
}


//: [Next](@next)
