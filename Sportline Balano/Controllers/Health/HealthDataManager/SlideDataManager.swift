import Foundation

class SlideDataManager {
    static let shared = SlideDataManager()

    private let userDefaults = UserDefaults.standard
    private let slideKey = "slideKey"

    // MARK: - Public Methods

    func saveData(_ value: Int) {
        userDefaults.set(value, forKey: slideKey)
    }

    func fetchData() -> Int? {
        return userDefaults.integer(forKey: slideKey) == 0 && userDefaults.object(forKey: slideKey) == nil ? nil : userDefaults.integer(forKey: slideKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: slideKey)
    }
}
