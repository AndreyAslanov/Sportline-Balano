import Foundation

class PulseDataManager {
    static let shared = PulseDataManager()

    private let userDefaults = UserDefaults.standard
    private let pulseDataManagerKey = "pulseDataManager"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: pulseDataManagerKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: pulseDataManagerKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: pulseDataManagerKey)
    }
}
