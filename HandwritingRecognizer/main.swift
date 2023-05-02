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



func normalize(_ pixel: Double) -> Double {
    return pixel / 255.0
}

func fetchLetter(_ letter: Int, connection: Connection) -> (trainingInputs: [[Double]], expectedOutputs: [[Double]])? {
    var trainingInputs: [[Double]] = []
    var expectedOutputs: [[Double]] = []
    do {
        let statement = try connection.prepare("SELECT * FROM handwriting_data WHERE letter='\(letter)' ORDER BY RANDOM() LIMIT 5")
        for row in statement {
            trainingInputs.append([Double](repeating: 0.0, count: row.count))
            expectedOutputs.append([row[0] as! Double])
            for i in 1..<row.count {
                trainingInputs[trainingInputs.count - 1][i] = normalize(row[i] as! Double)
            }
        }
        return (trainingInputs: trainingInputs, expectedOutputs: [[Double]](repeating: [1.0], count: 784)) // TODO: Swap this hacked solution
    } catch let error {
        print(error.localizedDescription)
        return nil
    }
}

func fetchLetterA(connection: Connection) -> (trainingInputs: [[Double]], expectedOutputs: [[Double]])? {
    var trainingInputs: [[Double]] = []
    var expectedOutputs: [[Double]] = []
    do {
        let statement = try connection.prepare("SELECT * FROM a_train WHERE LETTER='1' ORDER BY RANDOM() LIMIT 100")
        for row in statement {
            trainingInputs.append([Double](repeating: 0.0, count: row.count))
            expectedOutputs.append([row[0] as! Double])
            for i in 1..<row.count {
                trainingInputs[trainingInputs.count - 1][i] = row[i] as! Double / 255.0
            }
        }
        return (trainingInputs: trainingInputs, expectedOutputs: expectedOutputs)
    } catch let error {
        print("An error occured")
        print(error.localizedDescription)
        return nil
    }
}

func fetchTestData(connection: Connection) -> [[Double]]? {
    var testData: [[Double]] = []
    do {
        let statement = try connection.prepare("SELECT * FROM handwriting_data WHERE letter='5' ORDER BY RANDOM() LIMIT 100")
        for row in statement {
            testData.append([Double](repeating: 0.0, count: row.count))
            for i in 1..<row.count {
                testData[testData.count - 1][i] = row[i] as! Double / 255.0
            }
        }
        return testData
    } catch let error {
        print(error.localizedDescription)
        return nil
    }
}

func trainLetterA(connection: Connection, neuralNetwork: inout NeuralNetwork) {
    print("Fetching letter 'A'")
    guard let data = fetchLetterA(connection: connection) else {
        print("Failed to fetch letter 'A'")
        exit(EXIT_FAILURE)
    }
    print("Normalizing training data")
    print("Training network..")
    neuralNetwork.train(
        trainingInputs: data.trainingInputs,
        expectedOutputs: data.expectedOutputs,
        learningRate: 0.3,
        epochs: 5000,
        targetError: 0.001
    )
    neuralNetwork.traverseColumn(atIndex: neuralNetwork.layerCount - 1)
}

func testLetterA(connection: Connection, neuralNetwork: inout NeuralNetwork) {
    print("Fetching test data")
    guard let testData = fetchTestData(connection: connection) else {
        print("Failed to fetch test data")
        exit(EXIT_FAILURE)
    }
    print(testData.count)
    print("Testing..")
    let average = neuralNetwork.test(inputs: testData)
    print(average)
}

func main() {
    let arguments = CommandLine.arguments
    if arguments.count != 2 {
        print("Usage: ./HandwritingRecognizer 0")
        exit(EXIT_FAILURE)
    }
    guard let letterNumber = Int(arguments[1]) else {
        print("Letter must be a number 'A' = 0 and 'Z' = 25")
        exit(EXIT_FAILURE)
    }
    print("Creting connection")
    guard let connection = initDB() else {
        exit(EXIT_FAILURE)
    }
    print("Initializing neural network")
    print("Training network for letter: \(letterNumber)")
    let networkTopology = NetworkTopology(layers: [784, 250, 60, 4, 1], collectors: [Double](repeating: 0.0, count: 784))
    var neuralNetwork = NeuralNetwork(topology: networkTopology)
    guard let data = fetchLetter(letterNumber, connection: connection) else {
        exit(EXIT_FAILURE)
    }
    let learningRate = 0.45
    let targetError = 0.001
    let epochs = 250
    print("Hyperparameters:")
    print("Learning Rate: \(learningRate)")
    print("Target Error: \(targetError)")
    print("Training Network \(epochs)")
    print("Number of rows: \(data.trainingInputs.count)")
    neuralNetwork.train(
        trainingInputs: data.trainingInputs,
        expectedOutputs: data.expectedOutputs,
        learningRate: learningRate,
        epochs: epochs,
        targetError: targetError
    )
    exit(EXIT_SUCCESS)
}


main()
//runSmallData()

