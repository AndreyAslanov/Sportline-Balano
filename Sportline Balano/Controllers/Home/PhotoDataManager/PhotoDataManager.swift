import Foundation
import UIKit

final class PhotoDataManager {
    static let shared = PhotoDataManager()
    private let photosKey = "savedPhotos"
    private let userDefaults = UserDefaults.standard
    
    func savePhotos(_ photos: [PhotoModel]) {
        do {
            let data = try JSONEncoder().encode(photos)
            UserDefaults.standard.set(data, forKey: photosKey)
        } catch {
            print("Error saving photos: \(error)")
        }
    }
    
    // load PhotoModel
    func loadPhotos() -> [PhotoModel] {
        guard let data = userDefaults.data(forKey: photosKey) else {
            return []
        }
        do {
            let photos = try JSONDecoder().decode([PhotoModel].self, from: data)
            return photos
        } catch {
            return []
        }
    }

    // update PhotoModel
    func updatePhoto(withId id: UUID, photoImagePath: String) {
        var photos = loadPhotos()
        if let index = photos.firstIndex(where: { $0.id == id }) {
            photos[index].photoImagePath = photoImagePath
            savePhotos(photos)
        } else {
            print("Photo with id \(id) not found.")
        }
    }
    
    // Delete an image to the filesystem
    func deletePhoto(_ model: PhotoModel) {
        var photos = loadPhotos()
        photos.removeAll { $0.id == model.id }
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(photos)
            userDefaults.set(encoded, forKey: photosKey)
        } catch {
            print("Failed to save photos after deletion: \(error.localizedDescription)")
        }
    }

    // Save an image to the filesystem
    func saveImage(_ image: UIImage, withId id: UUID) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }

        let fileName = id.uuidString
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }

    // Load an image by id
    func loadImage(withId id: UUID) -> UIImage? {
        let fileName = id.uuidString
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)

        if fileManager.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            print("File does not exist at path: \(fileURL.path)")
            return nil
        }
    }
    
    // Delete all PhotoModel entries
    func deleteAllPhotos() {
        let photos: [PhotoModel] = []
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(photos)
            userDefaults.set(encoded, forKey: photosKey)
        } catch {
            print("Failed to delete all photos: \(error.localizedDescription)")
        }
    }
}
