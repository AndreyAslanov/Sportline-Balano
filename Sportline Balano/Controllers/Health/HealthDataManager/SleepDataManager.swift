import Foundation

class SleepDataManager {
    static let shared = SleepDataManager()

    private let userDefaults = UserDefaults.standard
    private let sleepKey = "sleepKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: sleepKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: sleepKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: sleepKey)
    }
}
