import Foundation
protocol StackProtocol: Codable {
    associatedtype Element: Codable
    func push(_ element: Element)
    func pop() -> Element?
    func describe() -> String
}

protocol QueueProtocol: Codable {
    associatedtype Element: Codable
    func enqueue(_ element: Element)
    func dequeue() -> Element?
    func describe() -> String
}

class Deque<T: Codable>: StackProtocol, QueueProtocol {
    private var elements: [T] = []

    func push(_ element: T) {
        elements.append(element)
    }

    func pop() -> T? {
        return elements.popLast()
    }

    func enqueue(_ element: T) {
        elements.insert(element, at: 0)
    }

    func dequeue() -> T? {
        return elements.isEmpty ? nil : elements.removeLast()
    }

    func peekFront() -> T? {
        return elements.first
    }

    func peekBack() -> T? {
        return elements.last
    }

    func isEmpty() -> Bool {
        return elements.isEmpty
    }

    func size() -> Int {
        return elements.count
    }

    func describe() -> String {
        return "Deque: \(elements)"
    }

    func generateRandomData(count: Int, generator: () -> T) {
        elements = (0..<count).map { _ in generator() }
    }
}

class Stack<T: Codable>: StackProtocol {
    private var elements: [T] = []

    func push(_ element: T) {
        elements.append(element)
    }

    func pop() -> T? {
        return elements.popLast()
    }

    func isEmpty() -> Bool {
        return elements.isEmpty
    }

    func describe() -> String {
        return "Stack: \(elements)"
    }

    func generateRandomData(count: Int, generator: () -> T) {
        elements = (0..<count).map { _ in generator() }
    }
}

class Queue<T: Codable>: QueueProtocol {
    private var elements: [T] = []

    func enqueue(_ element: T) {
        elements.append(element)
    }

    func dequeue() -> T? {
        return elements.isEmpty ? nil : elements.removeFirst()
    }

    func isEmpty() -> Bool {
        return elements.isEmpty
    }

    func describe() -> String {
        return "Queue: \(elements)"
    }

    func generateRandomData(count: Int, generator: () -> T) {
        elements = (0..<count).map { _ in generator() }
    }
}

class Character: Codable {
    private(set) var name: String
    private(set) var health: Int

    init(name: String, health: Int) {
        self.name = name
        self.health = health
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.health = try container.decode(Int.self, forKey: .health)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(health, forKey: .health)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case health
    }

    func takeDamage(_ amount: Int) {
        health = max(health - amount, 0)
    }

    func isAlive() -> Bool {
        return health > 0
    }

    func displayInfo() -> String {
        return "\(name): \(health) HP"
    }
}

class Hero: Character {
    private let specialAbility: String

    init(name: String, health: Int, specialAbility: String) {
        self.specialAbility = specialAbility
        super.init(name: name, health: health)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.specialAbility = try container.decode(String.self, forKey: .specialAbility)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(specialAbility, forKey: .specialAbility)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case specialAbility
    }

    func useAbility() {
        print("\(name) uses \(specialAbility)!")
    }
}

class Villain: Character {
    private let evilPlan: String

    init(name: String, health: Int, evilPlan: String) {
        self.evilPlan = evilPlan
        super.init(name: name, health: health)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.evilPlan = try container.decode(String.self, forKey: .evilPlan)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(evilPlan, forKey: .evilPlan)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case evilPlan
    }

    func executePlan() {
        print("\(name) executes their evil plan: \(evilPlan).")
    }
}

class Environment: Codable {
    private(set) var name: String
    private(set) var description: String

    init(name: String, description: String) {
        self.name = name
        self.description = description
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case description
    }

    func describe() {
        print("\(name): \(description)")
    }
}

struct Coordinates: Codable {
    let x: Int
    let y: Int
}

class Location: Environment {
    private let coordinates: Coordinates

    init(name: String, description: String, coordinates: Coordinates) {
        self.coordinates = coordinates
        super.init(name: name, description: description)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.coordinates = coordinates
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinates, forKey: .coordinates)
        try super.encode(to: encoder)
    }

    private enum CodingKeys: String, CodingKey {
        case coordinates
    }

    func getCoordinates() -> Coordinates {
        return coordinates
    }
}

class Event: Codable {
    private let title: String
    private let participants: [Character]

    init(title: String, participants: [Character]) {
        self.title = title
        self.participants = participants
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.participants = try container.decode([Character].self, forKey: .participants)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(participants, forKey: .participants)
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case participants
    }

    func start() {
        print("Event '\(title)' has started!")
        participants.forEach { participant in
            print(participant.displayInfo())
        }
    }
}

func write<T: Codable>(toFile filename: String, data: T) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(data)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try data.write(to: url)
        print("Data has been written to \(url.path)")
    } catch {
        print("Failed to write data: \(error)")
    }
}

func read<T: Codable>(fromFile filename: String) -> T? {
    let decoder = JSONDecoder()
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
    do {
        let data = try Data(contentsOf: url)
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    } catch {
        print("Failed to read data: \(error)")
        return nil
    }
}


func main() {
    let hero = Hero(name: "Superman", health: 100, specialAbility: "Flight")
    let villain = Villain(name: "Lex Luthor", health: 80, evilPlan: "World Domination")
    let event = Event(title: "Epic Battle", participants: [hero, villain])

    write(toFile: "hero.json", data: hero)
    write(toFile: "villain.json", data: villain)
    write(toFile: "event.json", data: event)

    // счит с файла опционал
    if let loadedHero: Hero = read(fromFile: "hero.json") {
        print("Loaded Hero: \(loadedHero.displayInfo())")
    }

    if let loadedVillain: Villain = read(fromFile: "villain.json") {
        print("Loaded Villain: \(loadedVillain.displayInfo())")
    }

    if let loadedEvent: Event = read(fromFile: "event.json") {
        loadedEvent.start()
    }
}

main()
