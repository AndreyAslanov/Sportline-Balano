import Foundation

class SpeedDataManager {
    static let shared = SpeedDataManager()

    private let userDefaults = UserDefaults.standard
    private let speedKey = "speedKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: speedKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: speedKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: speedKey)
    }
}
