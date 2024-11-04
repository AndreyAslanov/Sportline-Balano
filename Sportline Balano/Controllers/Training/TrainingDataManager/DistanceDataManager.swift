import Foundation

class DistanceDataManager {
    static let shared = DistanceDataManager()

    private let userDefaults = UserDefaults.standard
    private let distanceKey = "distanceKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: distanceKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: distanceKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: distanceKey)
    }
}
