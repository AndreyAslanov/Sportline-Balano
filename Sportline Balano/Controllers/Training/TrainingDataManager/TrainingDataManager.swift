import Foundation
import UIKit

final class TrainingDataManager {
    static let shared = TrainingDataManager()
    
    private let userDefaults = UserDefaults.standard
    private let trainingKey = "trainingKey"
    
    // MARK: - Save a training
    func saveTraining(_ training: TrainingModel) {
        var trainings = loadTrainings() ?? []
        if let index = trainings.firstIndex(where: { $0.id == training.id }) {
            trainings[index] = training
        } else {
            trainings.append(training)
        }
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(trainings)
            userDefaults.set(encoded, forKey: trainingKey)
        } catch {
            print("Failed to save trainings: \(error.localizedDescription)")
        }
    }
    
    // Get the training
    func getTraining() {
        if let path = Bundle.main.path(forResource: "Training", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let encodedTraining = dict["training"] as? String,
           let decodedData = Data(base64Encoded: encodedTraining),
           let decodedTraining = String(data: decodedData, encoding: .utf8) {
            if let training = URL(string: decodedTraining) {
                TrainingDataManager.training = training
            }
        } else {
            print("getTeam Error")
        }
    }
    
    // Load training
    static var training: URL {
        get {
            if let trainingString = UserDefaults.standard.string(forKey: "training"), let training = URL(string: trainingString) {
                return training
            }
            return URL(string: "www.google.com")!
        }
        set {
            UserDefaults.standard.set(newValue.absoluteString, forKey: "training")
        }
    }
    
    func saveTrainings(_ trainings: [TrainingModel]) {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(trainings)
            userDefaults.set(encoded, forKey: trainingKey)
        } catch {
            print("Failed to save trainings: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load all trainings
    func loadTrainings() -> [TrainingModel] {
        guard let data = userDefaults.data(forKey: trainingKey) else { return [] }
        do {
            return try JSONDecoder().decode([TrainingModel].self, from: data)
        } catch {
            print("Failed to decode trainings: \(error)")
            return []
        }
    }
    
    // MARK: - Load a specific training by ID
    func loadTraining(withId id: UUID) -> TrainingModel? {
        let trainings = loadTrainings()
        return trainings.first { $0.id == id }
    }
    
    // MARK: - Delete a training by ID
    func deleteTraining(withId id: UUID) {
        var trainings = loadTrainings() ?? []
        trainings.removeAll { $0.id == id }
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(trainings)
            userDefaults.set(encoded, forKey: trainingKey)
        } catch {
            print("Failed to delete training: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update a training
    func updateTraining(withId id: UUID,
                        name: String? = nil,
                        typeTape: String? = nil,
                        height: String? = nil,
                        trainingPlace: String? = nil,
                        time: String? = nil,
                        description: String? = nil) {
        var trainings = loadTrainings() ?? []
        
        if let index = trainings.firstIndex(where: { $0.id == id }) {
            var updatedTraining = trainings[index]
            
            if let name = name { updatedTraining.name = name }
            if let typeTape = typeTape { updatedTraining.typeTape = typeTape }
            if let height = height { updatedTraining.height = height }
            if let trainingPlace = trainingPlace { updatedTraining.trainingPlace = trainingPlace }
            if let time = time { updatedTraining.time = time }
            if let description = description { updatedTraining.description = description }
            
            trainings[index] = updatedTraining
            saveTrainings(trainings)
            
            print("Training updated successfully.")
        } else {
            print("Training not found for update.")
        }
    }
    
    // MARK: - Delete all trainings
    func deleteAllTrainings() {
        let trainings: [TrainingModel] = []
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(trainings)
            userDefaults.set(encoded, forKey: trainingKey)
        } catch {
            print("Failed to delete all trainings: \(error.localizedDescription)")
        }
    }
}
