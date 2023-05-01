import Foundation 

class Node: Codable {
    var collector: Double
    var connections: [Edge]
    var delta: Double

    init(collector: Double = 0.0) {
        self.collector = collector
        self.connections = []
        self.delta = 0.0
    }

    func addConnection(node: Node, weight: Double = Double.random(in: 0.0...1.0)) {
        self.connections.append(Edge(node: node, weight: weight))
    }

    func updateCollector(newCollector: Double) {
        self.collector = newCollector
    }

    func updateDelta(newDelta: Double) {
        self.delta = newDelta
    }

    func display() {
        print("Node {")
        print("\tcollector: \(collector)")
        print("\tdelta: \(delta)")
        for edge in connections {
            edge.display()
        }
        print("}")
    }
}
