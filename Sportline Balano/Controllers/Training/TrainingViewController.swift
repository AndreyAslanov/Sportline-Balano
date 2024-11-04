import SnapKit
import UIKit

final class TrainingViewController: UIViewController {
    private let trainingLabel = UILabel()
    private let trainingSmallLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let addWorkoutView = AddWorkoutView()
    private let trainingProgressView = TrainingProgressView()

   private var trainings: [TrainingModel] = [] {
        didSet {
            saveTrainings(trainings)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrainingCell.self, forCellWithReuseIdentifier: TrainingCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        addWorkoutView.delegate = self
        trainingProgressView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.black
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        view.backgroundColor = UIColor(hex: "#1F1F1F")

        drawself()
        trainings = loadTrainings()
        updateViewVisibility()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        calculateCollectionViewHeight()
        
        if let maxHeight = HeightDataManager.shared.fetchData() {
            trainingProgressView.configureHeightValueLabel(with: maxHeight)
        }

        if let maxDistance = DistanceDataManager.shared.fetchData() {
            trainingProgressView.configureDistanceValueLabel(with: maxDistance)
        }
        
        if let trainingTime = TimeDataManager.shared.fetchData() {
            trainingProgressView.configureTimeValueLabel(with: trainingTime)
        }

        if let windSpeed = SpeedDataManager.shared.fetchData() {
            trainingProgressView.configureSpeedValueLabel(with: windSpeed)
        }
    }

    private func drawself() {
        trainingLabel.do { make in
            make.text = L.training()
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textColor = .white
            make.textAlignment = .left
        }        
        
        trainingSmallLabel.do { make in
            make.text = L.training()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .left
        }
        
        view.addSubviews(trainingLabel, addWorkoutView, scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            trainingProgressView, trainingSmallLabel, collectionView
        )
        
        trainingLabel.snp.makeConstraints { make in
            if UIDevice.isIphoneBelowX {
                make.top.equalToSuperview().offset(34)
            } else {
                make.top.equalToSuperview().offset(74)
            }
            make.leading.equalToSuperview().offset(15)
        }

        addWorkoutView.snp.makeConstraints { make in
            make.top.equalTo(trainingLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(136)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(addWorkoutView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        trainingProgressView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.height.equalTo(342)
        }
        
        trainingSmallLabel.snp.makeConstraints { make in
            make.top.equalTo(trainingProgressView.snp.bottom).offset(19)
            make.leading.equalTo(contentView).offset(15)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(trainingSmallLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(calculateCollectionViewHeight())
        }
    }
    
    private func updateViewVisibility() {
        let isEmpty = trainings.isEmpty
        trainingSmallLabel.isHidden = isEmpty
        collectionView.reloadData()
        
        let height = calculateCollectionViewHeight()
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    @objc private func customButtonTapped() {
        didTapPlusButton()
    }

    @objc private func didTapPlusButton() {        
        let newTrainingVC = NewTrainingViewController(isEditing: false)
        newTrainingVC.delegate = self

        if #available(iOS 15.0, *) {
            if let sheet = newTrainingVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .large
            }
        } else {
            newTrainingVC.modalPresentationStyle = .fullScreen
            newTrainingVC.modalTransitionStyle = .coverVertical
        }

        present(newTrainingVC, animated: true, completion: nil)
    }

    // MARK: - Data Persistence Methods
    private func loadTrainings() -> [TrainingModel] {
        return TrainingDataManager.shared.loadTrainings()
    }

    private func saveTrainings(_ models: [TrainingModel]) {
        TrainingDataManager.shared.saveTrainings(models)
    }
    
    // MARK: - Public Func For Deleting
    func deleteTrainingData() {
        HeightDataManager.shared.deleteData()
        DistanceDataManager.shared.deleteData()
        TimeDataManager.shared.deleteData()
        SpeedDataManager.shared.deleteData()
        TrainingDataManager.shared.deleteAllTrainings()
        refreshUI()
    }
    
    private func refreshUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        drawself()
    }
}

// MARK: - NewBookViewDelegate
extension TrainingViewController: AddWorkoutViewDelegate {
    func didTapAddButton() {
        didTapPlusButton()
    }
}

// MARK: - TrainingProgressViewDelegate
extension TrainingViewController: TrainingProgressViewDelegate {
    func didTapHeightButton() {
        let alertController = UIAlertController(title: L.maxHeight(), message: L.trackProgress(), preferredStyle: .alert)

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

            HeightDataManager.shared.saveData(nameText)
            self.trainingProgressView.configureHeightValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
    
    func didTapDistanceButton() {
        let alertController = UIAlertController(title: L.maxDistance(), message: L.trackProgress(), preferredStyle: .alert)

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

            DistanceDataManager.shared.saveData(nameText)
            self.trainingProgressView.configureDistanceValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
    
    func didTapTimeButton() {
        let alertController = UIAlertController(title: L.trainingTime(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "min"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            TimeDataManager.shared.saveData(nameText)
            self.trainingProgressView.configureTimeValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
    
    func didTapSpeedButton() {
        let alertController = UIAlertController(title: L.windSpeed(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "m/sec"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            SpeedDataManager.shared.saveData(nameText)
            self.trainingProgressView.configureSpeedValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - NewFavouriteDelegate
extension TrainingViewController: NewTrainingDelegate {
    func didAddTraining(_ model: TrainingModel) {
        trainings.append(model)
        calculateCollectionViewHeight()
        updateViewVisibility()
    }
    
    func didUpdateTraining(_ model: TrainingModel) {
        if let index = trainings.firstIndex(where: { $0.id == model.id }) {
            trainings[index] = model
        }
        calculateCollectionViewHeight()
        updateViewVisibility()
    }
}

// MARK: - BookCellDelegate
extension TrainingViewController: TrainingCellDelegate {    
    func didTapEditButton(with model: TrainingModel) {
        let newTrainingVC = NewTrainingViewController(isEditing: true)
        newTrainingVC.delegate = self
        newTrainingVC.training = model
        newTrainingVC.trainingId = model.id

        if #available(iOS 15.0, *) {
            if let sheet = newTrainingVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .large
            }
        } else {
            newTrainingVC.modalPresentationStyle = .fullScreen
            newTrainingVC.modalTransitionStyle = .coverVertical
        }

        present(newTrainingVC, animated: true, completion: nil)
    }

    func didTapDeleteButton(with model: TrainingModel) {
        let alertController = UIAlertController(title: L.delete(), message: L.deleteThis(), preferredStyle: .alert)
        let closeAction = UIAlertAction(title: L.cancel(), style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: L.delete(), style: .destructive) { [weak self] _ in
            let trainingId = model.id

            TrainingDataManager.shared.deleteTraining(withId: trainingId)
            self?.didDeleteModel(withId: trainingId)
        }

        alertController.addAction(closeAction)
        alertController.addAction(deleteAction)
        alertController.view.tintColor = UIColor(hex: "#0A84FF")
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }

    func didDeleteModel(withId trainingId: UUID) {
        if let index = trainings.firstIndex(where: { $0.id == trainingId }) {
            trainings.remove(at: index)
            calculateCollectionViewHeight()
            updateViewVisibility()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrainingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trainings.isEmpty ? 0 : trainings.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < trainings.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrainingCell.reuseIdentifier, for: indexPath) as? TrainingCell else {
                fatalError("Unable to dequeue RoutersPermanentCell")
            }
            let trainings = trainings[indexPath.section]
            cell.delegate = self
            cell.configure(with: trainings)
            return cell
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 198
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        collectionView.layoutIfNeeded()
        
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        let spacing: CGFloat = 16
        let totalHeight = contentHeight + CGFloat(trainings.count - 1) * spacing
        return totalHeight
    }
}
