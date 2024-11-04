import Foundation
import UIKit

struct PhotoModel: Codable {
    var id: UUID
    var photoImagePath: String?

    var photoImage: UIImage? {
        guard let path = photoImagePath else { return nil }
        return UIImage(contentsOfFile: path)
    }
}
