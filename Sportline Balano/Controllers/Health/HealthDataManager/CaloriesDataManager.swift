import Foundation

class CaloriesDataManager {
    static let shared = CaloriesDataManager()

    private let userDefaults = UserDefaults.standard
    private let caloriesKey = "caloriesKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: caloriesKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: caloriesKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: caloriesKey)
    }
}
