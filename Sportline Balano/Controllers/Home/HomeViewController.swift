import SnapKit
import UIKit

final class HomeViewController: UIViewController {
    private let mainLabel = UILabel()
    private let trainingPhotoLabel = UILabel()
    private let plusButton = UIButton()
    
    private let monthView = ProgressMonthView()
    private let addPhotoView = AddPhotoView()
    private var selectedImagePath: String?
    private var photos: [PhotoModel] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.black
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        view.backgroundColor = UIColor(hex: "#1F1F1F")

        drawself()
        monthView.delegate = self
        addPhotoView.delegate = self

        if let trainingName = MonthTrainingDataManager.shared.fetchData() {
            monthView.configureTrainingValueLabel(with: trainingName)
        }

        if let heightName = MonthHeightDataManager.shared.fetchData() {
            monthView.configureHeightValueLabel(with: heightName)
        }

        photos = PhotoDataManager.shared.loadPhotos()
        updateViewVisibility()
    }

    private func drawself() {
        mainLabel.do { make in
            make.text = L.main()
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textColor = .white
            make.textAlignment = .left
        }        
        
        trainingPhotoLabel.do { make in
            make.text = L.trainingPhotos()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .left
        }
        
        plusButton.do { make in
            make.setImage(UIImage(systemName: "plus"), for: .normal)
            make.tintColor = .white
            make.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        }

        view.addSubviews(
            mainLabel, monthView, collectionView, trainingPhotoLabel, plusButton, addPhotoView
        )

        mainLabel.snp.makeConstraints { make in
            if UIDevice.isIphoneBelowX {
                make.top.equalToSuperview().offset(34)
            } else {
                make.top.equalToSuperview().offset(74)
            }
            make.leading.equalToSuperview().offset(15)
        }

        monthView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(197)
        }
        
        trainingPhotoLabel.snp.makeConstraints { make in
            make.top.equalTo(monthView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(27)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(27)
            make.centerY.equalTo(trainingPhotoLabel.snp.centerY)
        }

        addPhotoView.snp.makeConstraints { make in
            make.top.equalTo(trainingPhotoLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(136)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(trainingPhotoLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(27)
            make.bottom.equalToSuperview()
        }
    }

    private func updateViewVisibility() {
        let isEmpty = photos.isEmpty
        addPhotoView.isHidden = !isEmpty
        trainingPhotoLabel.isHidden = isEmpty
        plusButton.isHidden = isEmpty
        collectionView.reloadData()
    }
    
    // MARK: - Public Func For Deleting
    func deleteHomeData() {
        MonthTrainingDataManager.shared.deleteData()
        MonthHeightDataManager.shared.deleteData()
        PhotoDataManager.shared.deleteAllPhotos()
        refreshUI()
    }
    
    private func refreshUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        drawself()
    }
}

// MARK: - LastMonthViewDelegate
extension HomeViewController: ProgressMonthViewDelegate {
    func didTapTrainingButton() {
        let alertController = UIAlertController(title: L.numberTraining(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Text"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            MonthTrainingDataManager.shared.saveData(nameText)
            self.monthView.configureTrainingValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }

    func didTapHeightButton() {
        let alertController = UIAlertController(title: L.heightTape(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "m"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            MonthHeightDataManager.shared.saveData(nameText)
            self.monthView.configureHeightValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - AddPhotoViewDelegate
extension HomeViewController: AddPhotoViewDelegate {
    @objc func didTapAddButton() {
        showImagePickerController()
    }
}

// MARK: - NewBookDelegate
extension HomeViewController: EditPhotoDelegate {
    func didDeletePhoto(_ model: PhotoModel) {
        PhotoDataManager.shared.deletePhoto(model)
        if let index = photos.firstIndex(where: { $0.id == model.id }) {
            photos.remove(at: index)
            collectionView.reloadData()
            updateViewVisibility()
        }
    }
    
    func didUpdatePhoto(_ model: PhotoModel) {
        if let index = photos.firstIndex(where: { $0.id == model.id }) {
            photos[index] = model
            collectionView.reloadData()
        }
        updateViewVisibility()
    }
}

// MARK: - PhotoCellDelegate
extension HomeViewController: PhotoCellDelegate {
    func didTapCell(with model: PhotoModel) {
        let editPhotoVC = EditPhotoViewController(isEditing: true)
        editPhotoVC.delegate = self
        editPhotoVC.photo = model
        editPhotoVC.photoId = model.id

        if #available(iOS 15.0, *) {
            if let sheet = editPhotoVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .large
            }
        } else {
            editPhotoVC.modalPresentationStyle = .fullScreen
            editPhotoVC.modalTransitionStyle = .coverVertical
        }

        present(editPhotoVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (photos.count + 1) / 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index1 = section * 2
        let index2 = index1 + 1
        
        if index2 < photos.count {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            fatalError("Unable to dequeue CategoryCell")
        }
        
        let genreIndex = indexPath.section * 2 + indexPath.item
        if genreIndex < photos.count {
            let photoItem = photos[genreIndex]
            cell.delegate = self
            cell.configure(with: photoItem)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 2) - 5
        let height: CGFloat = 230
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let newId = UUID()
            let imagePath = PhotoDataManager.shared.saveImage(selectedImage, withId: newId)
            
            let newPhoto = PhotoModel(id: newId, photoImagePath: imagePath)
            photos.append(newPhoto)
            PhotoDataManager.shared.savePhotos(photos)
            
            collectionView.reloadData()
            updateViewVisibility()
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
