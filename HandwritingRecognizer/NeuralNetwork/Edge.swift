import Foundation

struct Edge: Codable {
    var node: Node
    var weight: Double

    init(node: Node, weight: Double = Double.random(in: 0.0...1.0)) {
        self.node = node
        self.weight = weight
    }

    mutating func updateWeight(newWeight: Double) {
        self.weight = newWeight
    }

    func display() {
        print("\tEdge {")
        print("\t\tweight: \(self.weight)")
        print("\t}")
    }
    
}
