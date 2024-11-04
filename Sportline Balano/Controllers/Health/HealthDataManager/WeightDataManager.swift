import Foundation

class WeightDataManager {
    static let shared = WeightDataManager()

    private let userDefaults = UserDefaults.standard
    private let weightKey = "weightKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: weightKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: weightKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: weightKey)
    }
}
