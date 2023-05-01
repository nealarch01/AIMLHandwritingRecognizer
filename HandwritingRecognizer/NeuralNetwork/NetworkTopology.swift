import Foundation 

struct NetworkTopology: Codable {
    var layers: [Int]
    var collectors: [Double]


    mutating public func initializeCollectors() {
        while collectors.count < layers[0] {
            collectors.append(1.0)
        }
    }

    public func isValid() -> Bool {
        if layers.count < 2 { 
            // print("There must be at least 2 layers")
            return false 
        }
        if layers[0] != collectors.count {
            // print("The number of collectors must be equal to the number of nodes in the first layer")
            return false
        }
        return true
    }
}

