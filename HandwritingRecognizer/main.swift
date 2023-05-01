//
//  main.swift
//  HandwritingRecognizer
//
//  Created by Neal Archival on 4/30/23.
//

import Foundation
import Darwin
import SQLite

func readData() -> String? {
    let resourcePath = "dataset.csv"
    guard let projectPath = Bundle.main.resourcePath else {
        print("Failed to get project path..")
        return nil
    }
    let fileURL = URL(filePath: projectPath).appending(path: resourcePath)
    do {
        let contents = try String(contentsOf: fileURL, encoding: .utf8)
        return contents
    } catch let error {
        print(error.localizedDescription)
        return nil
    }
}

func network431(trainingInputs: [[Double]], expectedOutputs: [[Double]]) -> NeuralNetwork {
    let networkTopology = NetworkTopology(layers: [4, 3, 1], collectors: Array(repeating: 0.0, count: 4))
    let neuralNetwork = NeuralNetwork(topology: networkTopology)
    neuralNetwork.train(
        trainingInputs: trainingInputs,
        expectedOutputs: expectedOutputs,
        learningRate: 0.3,
        epochs: 1000,
        targetError: 0.03
    )
    return neuralNetwork
}

func network421(trainingInputs: [[Double]], expectedOutputs: [[Double]]) -> NeuralNetwork {
    let networkTopology = NetworkTopology(layers: [4, 2, 1], collectors: Array(repeating: 0.0, count: 4))
    let neuralNetwork = NeuralNetwork(topology: networkTopology)
    neuralNetwork.train(
        trainingInputs: trainingInputs,
        expectedOutputs: expectedOutputs,
        learningRate: 0.3,
        epochs: 50,
        targetError: 0.05
    )
    return neuralNetwork
}


func runSmallData() {
    guard let fileContents = readData() else {
        return
    }
    let lines = fileContents.components(separatedBy: "\n")
    let stringMatrix = lines.map { $0.components(separatedBy: ",") }
    var doubleMatrix = stringMatrix.map { $0.map { Double($0) ?? 0.0 } }
    doubleMatrix = doubleMatrix.dropLast()
    // The last column are the answers therefore it shouldn't be included in collectors
    var trainingInputs: [[Double]] = []
    for i in 0..<doubleMatrix.count {
        let row = doubleMatrix[i]
        trainingInputs.append(row.dropLast())
    }
    var expectedOutputs: [[Double]] = []
    for i in 0..<doubleMatrix.count {
        expectedOutputs.append([doubleMatrix[i].last!])
    }
    print("Running network: [4, 2, 1]")
    let network1 = network421(trainingInputs: trainingInputs, expectedOutputs: expectedOutputs)
    network1.traverseColumn(atIndex: 2)
    print("\nRunning network: [4, 3, 1]")
    let network2 = network431(trainingInputs: trainingInputs, expectedOutputs: expectedOutputs)
    network2.traverseColumn(atIndex: 2)
}

// runSmallData()



func initDB() -> Connection? {
    do {
        let db = try Connection("handwriting.db")
        print("Successfully opened database")
        return db
    } catch let error {
        print(error.localizedDescription)
        return nil
    }
}

func fetchLetter(_ letter: String, connection: Connection) {
    do {
        let statement = try connection.prepare("SELECT * FROM handwriting_data WHERE letter='0'")
        for row in statement {
            print(row)
        }
    } catch let error {
        print(error.localizedDescription)
    }
}

func fetchLetterA(connection: Connection) -> (trainingInputs: [[Double]], expectedOutputs: [[Double]])? {
    var trainingInputs: [[Double]] = []
    do {
        let statement = try connection.prepare("SELECT * FROM handwriting_data WHERE letter='0' LIMIT 10")
        for row in statement {
            trainingInputs.append([])
            for i in 1..<row.count {
                switch row[i] {
                case let doubleValue as Double:
                    trainingInputs[trainingInputs.count - 1].append(doubleValue)
                default:
                    print("Non double")
                    continue
                }
            }
        }
        let expectedOutputs: [[Double]] = [[Double]](repeating: [Double](repeating: 1, count: trainingInputs[0].count), count: trainingInputs.count)
        return (trainingInputs: trainingInputs, expectedOutputs: expectedOutputs)
    } catch let error {
        print(error.localizedDescription)
        return nil
    }
}

func main() {
     guard let connection = initDB() else {
        exit(EXIT_FAILURE)
    }
    guard let data = fetchLetterA(connection: connection) else {
        exit(EXIT_FAILURE)
    }
    print(data.trainingInputs.count)
    print(data.expectedOutputs.count)
    exit(EXIT_SUCCESS)
}


main()

