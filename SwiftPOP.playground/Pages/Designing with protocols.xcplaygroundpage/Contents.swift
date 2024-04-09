//: [Previous](@previous)

import Foundation

var greeting = "Designing with protocols"

protocol RobotMovement {
    func moveToPosition(x: Double, y: Double, z: Double)
    func rotateBy(roll: Double, pitch: Double, yaw: Double)
    var currentPosition: (x: Double, y: Double, z: Double) { get }
    var currentOrientation: (roll: Double, pitch: Double, yaw: Double) { get }
}

protocol RobotMovementThreeDimensions: RobotMovement {
    func up(speedPercent: Double)
    func down(speedPercent: Double)
}

protocol Sensor {
    var sensorType: String { get }
    var sensorName: String { get set }
    
    init(sensorName: String)
    func pollSensor()
}

protocol RobotSensor: Sensor {
    var robot: Robot? { get set }
    func attachToRobot(_ robot: Robot)
}

protocol EnvironmentSensor: Sensor {
    func currentTemperature() -> Double
    func currentHumidity() -> Double
}

protocol RangeSensor: Sensor {
    func setRangeNotification(rangeCentimeter: Double, rangeNotification: () -> Void)
    func currentRange() -> Double
}

protocol DisplaySensor: Sensor {
    func displayMessage(message: String)
}

protocol WirelessSensor: Sensor {
    func setMessageReceivedNotification(messageNotification: (String) -> Void)
    func messageSend(message: String)
}

protocol Robot {
    var name: String { get set }
    var robotMovement: RobotMovement { get set }
    var sensors: [Sensor] { get }
    
    init(name: String, robotMovement: RobotMovement)
    func addSensor(sensor: Sensor)
    func pollSensors()
}

class SmartHomeSystem {
    private var rangeSensors: [RangeSensor] = []
    private var displaySensors: [DisplaySensor] = []
    private var wirelessSensors: [WirelessSensor] = []
    private var robots: [Robot] = []
    private var robotSensors: [RobotSensor] = []
    
    func addRobot(_ robot: Robot) {
        robots.append(robot)
    }
    
    func addRobotSensor(_ sensor: RobotSensor) {
        robotSensors.append(sensor)
        if let robot = robots.first {
            sensor.attachToRobot(robot)
        }
    }
    
    func pollSensors() {
        for sensor in robotSensors {
            sensor.pollSensor()
        }
        
        for robot in robots {
            robot.pollSensors()
        }
    }
    func addRangeSensor(_ sensor: RangeSensor) {
        rangeSensors.append(sensor)
        sensor.setRangeNotification(rangeCentimeter: 100) { [weak self] in
            self?.handleRangeNotification(sensor)
        }
    }
    
    func addDisplaySensor(_ sensor: DisplaySensor) {
        displaySensors.append(sensor)
    }
    
    func addWirelessSensor(_ sensor: WirelessSensor) {
        wirelessSensors.append(sensor)
        sensor.setMessageReceivedNotification { [weak self] message in
            self?.handleMessageReceived(message, from: sensor)
        }
    }
    
    private func handleRangeNotification(_ sensor: RangeSensor) {
        let range = sensor.currentRange()
        for display in displaySensors {
            display.displayMessage("Range: \(range) cm")
        }
    }
    
    private func handleMessageReceived(_ message: String, from sensor: WirelessSensor) {
        for display in displaySensors {
            display.displayMessage("Received: \(message)")
        }
    }
}

class UltrasonicSensor: RangeSensor {
    // 实现 RangeSensor 协议的要求
}

class LEDDisplay: DisplaySensor {
    // 实现 DisplaySensor 协议的要求
}

class BluetoothModule: WirelessSensor {
    // 实现 WirelessSensor 协议的要求
}

class CleaningRobot: Robot {
    var name: String
    var robotMovement: RobotMovement
    var sensors: [Sensor] = []
    
    required init(name: String, robotMovement: RobotMovement) {
        self.name = name
        self.robotMovement = robotMovement
    }
    
    func addSensor(sensor: Sensor) {
        sensors.append(sensor)
        if let robotSensor = sensor as? RobotSensor {
            robotSensor.attachToRobot(self)
        }
    }
    
    func pollSensors() {
        for sensor in sensors {
            sensor.pollSensor()
        }
    }
}

class CartesianRobot: RobotMovement {
    private var position: (Double, Double, Double) = (0, 0, 0)
    private var orientation: (Double, Double, Double) = (0, 0, 0)
    
    var currentPosition: (x: Double, y: Double, z: Double) {
        return (position.0, position.1, position.2)
    }
    
    var currentOrientation: (roll: Double, pitch: Double, yaw: Double) {
        return (orientation.0, orientation.1, orientation.2)
    }
    
    func moveToPosition(x: Double, y: Double, z: Double) {
        position = (x, y, z)
        print("Moving to (\(x), \(y), \(z))")
    }
    
    func rotateBy(roll: Double, pitch: Double, yaw: Double) {
        orientation = (roll, pitch, yaw)
        print("Rotating by (\(roll), \(pitch), \(yaw))")
    }
}

class RobotVacuumSensor: RobotSensor {
    var robot: Robot?
    
    func attachToRobot(_ robot: Robot) {
        self.robot = robot
    }
    
    func pollSensor() {
        print("\(robot?.name ?? "Unknown robot") is vacuuming")
    }
}

let smartHome = SmartHomeSystem()
let robotMovement = CartesianRobot()

let cleaningRobot = CleaningRobot(name: "CleanBot", robotMovement: robotMovement)
smartHome.addRobot(cleaningRobot)

let vacuumSensor = RobotVacuumSensor()
smartHome.addRobotSensor(vacuumSensor)

smartHome.pollSensors()
// 输出: CleanBot is vacuuming

cleaningRobot.robotMovement.moveToPosition(x: 5, y: 3, z: 1)
// 输出: Moving to (5.0, 3.0, 1.0)

cleaningRobot.robotMovement.rotateBy(roll: 0, pitch: 0.5, yaw: 0)
// 输出: Rotating by (0.0, 0.5, 0.0)

smartHome.pollSensors()
// 输出: CleanBot is vacuuming









//: [Next](@next)
