import UIKit

protocol EditPhotoDelegate: AnyObject {
    func didDeletePhoto(_ model: PhotoModel)
    func didUpdatePhoto(_ model: PhotoModel)
}

final class EditPhotoViewController: UIViewController {
    private let editPhotoLabel = UILabel()
    private let photoImageView = UIImageView()
    private let saveButton = OnboardingButton()
    private let deleteButton = OnboardingButton()

    private var selectedImagePath: String?
    weak var delegate: EditPhotoDelegate?
    var photo: PhotoModel?
    var photoId: UUID?
    private var isEditingMode: Bool

    init(photoId: UUID? = nil, isEditing: Bool) {
        self.photoId = photoId
        isEditingMode = isEditing
        super.init(nibName: nil, bundle: nil)
        if let photoId = photoId {
            self.photoId = photoId
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.black
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        setupUI()

        if isEditingMode {
            configure(with: photo)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#1F1F1F")
        
        saveButton.do { make in
            make.setTitle(to: L.save())
            make.saveMode()
            let saveTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
            make.addGestureRecognizer(saveTapGesture)
        }        
        
        deleteButton.do { make in
            make.deleteMode()
            let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDelete))
            make.addGestureRecognizer(deleteTapGesture)
        }
        
        editPhotoLabel.do { make in
            make.text = L.editPhoto()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .center
        }

        photoImageView.do { make in
            make.image = R.image.home_placeholder()
            make.contentMode = .scaleAspectFill
            make.clipsToBounds = true
            make.isUserInteractionEnabled = true
            make.layer.cornerRadius = 8
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
            make.addGestureRecognizer(tapGesture)
        }

        view.addSubviews(editPhotoLabel, photoImageView, saveButton, deleteButton)
        
        editPhotoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(editPhotoLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(540)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().dividedBy(2).offset(-22)
            make.height.equalTo(45)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(saveButton.snp.width)
            make.height.equalTo(45)
        }
    }

    @objc private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapEdit() {
        guard let photoId = photoId else {
            print("No photoId provided")
            return
        }
        
        guard let newImagePath = selectedImagePath else {
            print("No selected image path provided")
            return
        }

        PhotoDataManager.shared.updatePhoto(
            withId: photoId,
            photoImagePath: newImagePath
        )
        
        let updatedPhoto = PhotoModel(id: photoId, photoImagePath: newImagePath)
        delegate?.didUpdatePhoto(updatedPhoto)
        didTapBack()
    }

    @objc private func didTapDelete() {
        guard let photo = photo else {
            print("No photo provided")
            return
        }
        didTapDeleteButton(with: photo)
    }
    
    @objc private func didTapImageView() {
        showImagePickerController()
    }
    
    private func didTapDeleteButton(with model: PhotoModel) {
        let alertController = UIAlertController(title: L.deletePhoto(), message: L.deleteThis(), preferredStyle: .alert)
        let closeAction = UIAlertAction(title: L.cancel(), style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: L.delete(), style: .destructive) { [weak self] _ in
            let photoId = model.id
            self?.delegate?.didDeletePhoto(model)
            self?.didTapBack()
        }

        alertController.addAction(closeAction)
        alertController.addAction(deleteAction)
        alertController.view.tintColor = UIColor(hex: "#0A84FF")
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Data Persistence Methods
    private func configure(with model: PhotoModel?) {
        guard let model = model else { return }
        selectedImagePath = model.photoImagePath
        
        if let imagePath = model.photoImagePath, let uuid = UUID(uuidString: imagePath) {
            loadImage(for: uuid) { [weak self] image in
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                    if image == nil {
                        print("Failed to load image for UUID: \(imagePath)")
                    }
                }
            }
        } else {
            print("Invalid image path or UUID: \(model.photoImagePath ?? "nil")")
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

// MARK: - UIImagePickerControllerDelegate
extension EditPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            guard let validPhotoId = photoId else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            selectedImagePath = PhotoDataManager.shared.saveImage(selectedImage, withId: validPhotoId)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
