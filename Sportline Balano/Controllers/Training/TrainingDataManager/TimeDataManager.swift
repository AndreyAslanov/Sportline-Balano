import Foundation

class TimeDataManager {
    static let shared = TimeDataManager()

    private let userDefaults = UserDefaults.standard
    private let timeKey = "timeKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: timeKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: timeKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: timeKey)
    }
}
