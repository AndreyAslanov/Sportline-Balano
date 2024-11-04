import Foundation

class MonthHeightDataManager {
    static let shared = MonthHeightDataManager()

    private let userDefaults = UserDefaults.standard
    private let monthHeightKey = "monthHeightKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: monthHeightKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: monthHeightKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: monthHeightKey)
    }
}
