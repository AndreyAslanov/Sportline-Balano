import Foundation
import SnapKit
import UIKit

protocol PhotoCellDelegate: AnyObject {
    func didTapCell(with model: PhotoModel)
}

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    weak var delegate: PhotoCellDelegate?
    var photoModel: PhotoModel?
    
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        contentView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white.withAlphaComponent(0.08)
        layer.cornerRadius = 8
        
        imageView.do { make in
            make.contentMode = .scaleAspectFill
            make.clipsToBounds = true
            make.isUserInteractionEnabled = true
            make.layer.cornerRadius = 8
        }

        contentView.addSubviews(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func didTapCell() {
        guard let photoModel = photoModel else { return }
        delegate?.didTapCell(with: photoModel)
    }

    func configure(with model: PhotoModel) {
        photoModel = model

        if let imagePath = model.photoImagePath, let uuid = UUID(uuidString: imagePath) {
            loadImage(for: uuid) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    if image == nil {
                        print("Failed to load image for UUID: \(imagePath)")
                    }
                }
            }
        }
    }

    private func loadImage(for id: UUID, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let image = PhotoDataManager.shared.loadImage(withId: id)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
