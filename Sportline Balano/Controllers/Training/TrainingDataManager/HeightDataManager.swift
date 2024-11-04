import Foundation

class HeightDataManager {
    static let shared = HeightDataManager()

    private let userDefaults = UserDefaults.standard
    private let heightKey = "heightKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: heightKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: heightKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: heightKey)
    }
}
