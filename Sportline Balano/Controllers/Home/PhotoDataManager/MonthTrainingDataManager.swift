import Foundation

class MonthTrainingDataManager {
    static let shared = MonthTrainingDataManager()

    private let userDefaults = UserDefaults.standard
    private let monthTrainingKey = "monthTrainingKey"

    // MARK: - Public Methods

    func saveData(_ name: String) {
        userDefaults.set(name, forKey: monthTrainingKey)
    }

    func fetchData() -> String? {
        return userDefaults.string(forKey: monthTrainingKey)
    }

    func deleteData() {
        return userDefaults.removeObject(forKey: monthTrainingKey)
    }
}
