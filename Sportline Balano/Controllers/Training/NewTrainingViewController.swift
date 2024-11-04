import UIKit

protocol NewTrainingDelegate: AnyObject {
    func didAddTraining(_ model: TrainingModel)
    func didUpdateTraining(_ model: TrainingModel)
}

final class NewTrainingViewController: UIViewController {
    private let workoutLabel = UILabel()
    private let nameView = AppTextFieldView(type: .name)
    private let typeTapeView = AppTextFieldView(type: .typeTape)
    private let heightView = AppTextFieldView(type: .height)
    private let trainingPlaceView = AppTextFieldView(type: .trainingPlace)
    private let timeView = AppTextFieldView(type: .time)
    private let descriptionView = AppTextFieldView(type: .description)
    private let saveButton = OnboardingButton()

    weak var delegate: NewTrainingDelegate?
    var training: TrainingModel?
    var trainingId: UUID?
    private var isEditingMode: Bool

    init(trainingId: UUID? = nil, isEditing: Bool) {
        self.trainingId = trainingId
        isEditingMode = isEditing
        super.init(nibName: nil, bundle: nil)
        if let trainingId = trainingId {
            self.trainingId = trainingId
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
        navigationItem.title = isEditingMode ? L.editWorkout() : L.newWorkout()

        let backButton = UIBarButtonItem(customView: createBackButton())
        navigationItem.leftBarButtonItem = backButton

        setupUI()
        setupTextFields()
        setupTextView()
        updateAddButtonState()

        if isEditingMode {
            configure(with: training)
        }

        let textFields = [
            nameView.textField,
            typeTapeView.textField,
            heightView.textField,
            trainingPlaceView.textField,
            timeView.textField
        ]

        let textViews = [
            descriptionView.textView
        ]

        let textFieldsToMove = [
            nameView.textField,
            typeTapeView.textField,
            heightView.textField,
            trainingPlaceView.textField,
            timeView.textField
        ]

        let textViewsToMove = [
            descriptionView.textView
        ]

        KeyboardManager.shared.configureKeyboard(
            for: self,
            targetView: view,
            textFields: textFields,
            textViews: textViews,
            moveFor: textFieldsToMove,
            moveFor: textViewsToMove,
            with: .done
        )

        nameView.delegate = self
        typeTapeView.delegate = self
        heightView.delegate = self
        trainingPlaceView.delegate = self
        timeView.delegate = self
        descriptionView.delegate = self
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#1F1F1F")
        
        workoutLabel.do { make in
            make.text = isEditingMode ? L.editWorkout() : L.newWorkout()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .center
        }

        saveButton.setTitle(to: L.save())
        saveButton.saveMode()
        let saveTapGesture = UITapGestureRecognizer(target: self, action: isEditingMode ? #selector(didTapEdit) : #selector(didTapAdd))
        saveButton.addGestureRecognizer(saveTapGesture)

        view.addSubviews(
            workoutLabel, nameView, typeTapeView, heightView, trainingPlaceView, timeView, descriptionView, saveButton
        )
        
        workoutLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        nameView.snp.makeConstraints { make in
            make.top.equalTo(workoutLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }

        typeTapeView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }

        heightView.snp.makeConstraints { make in
            make.top.equalTo(typeTapeView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }        
        
        trainingPlaceView.snp.makeConstraints { make in
            make.top.equalTo(heightView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }        
        
        timeView.snp.makeConstraints { make in
            make.top.equalTo(trainingPlaceView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }

        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(timeView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(150)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(45)
        }
    }

    private func createBackButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(L.back(), for: .normal)
        button.setTitleColor(.white, for: .normal)

        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)

        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(chevronImage, for: .normal)
        button.tintColor = .white

        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)

        button.frame.size = CGSize(width: 120, height: 44)

        return button
    }

    private func setupTextFields() {
        [nameView.textField,
         typeTapeView.textField,
         heightView.textField,
         trainingPlaceView.textField,
         timeView.textField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }

    private func setupTextView() {
        descriptionView.textView.delegate = self
    }

    private func updateAddButtonState() {
        let allFieldsFilled = [
            nameView.textField,
            typeTapeView.textField,
            heightView.textField,
            trainingPlaceView.textField,
            timeView.textField
        ].allSatisfy {
            $0.text?.isEmpty == false
        }

        let feedbackFilled = !descriptionView.textView.text.isEmpty

        saveButton.isEnabled = allFieldsFilled && feedbackFilled
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
    }

    private func saveTraining() {
        guard let nameTitle = nameView.textField.text,
              let typeTape = typeTapeView.textField.text,
              let height = heightView.textField.text,
              let trainingPlace = trainingPlaceView.textField.text,
              let time = timeView.textField.text,
              let description = descriptionView.textView.text else { return }

        let id = UUID()

        training = TrainingModel(
            id: id,
            name: nameTitle,
            typeTape: typeTape,
            height: height,
            trainingPlace: trainingPlace,
            time: time,
            description: description
        )
    }

    @objc private func didTapAdd() {
        saveTraining()
        if let training = training {
            if let existingTrainingIndex = loadTraining().firstIndex(where: { $0.id == training.id }) {
                delegate?.didAddTraining(training)
            } else {
                delegate?.didAddTraining(training)
            }
        } else {
            print("TrainingModel is nil in didTapAdd")
        }
        didTapBack()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateAddButtonState()
    }

    @objc private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapEdit() {
        guard let trainingId = trainingId else {
            print("No trainingId provided")
            return
        }

        let updatedNameTitle = nameView.textField.text ?? ""
        let updatedTypeTape = typeTapeView.textField.text ?? ""
        let updatedHeight = heightView.textField.text ?? ""
        let updatedTraining = trainingPlaceView.textField.text ?? ""
        let updatedTime = timeView.textField.text ?? ""
        let updatedDescription = descriptionView.textView.text ?? ""

        TrainingDataManager.shared.updateTraining(
            withId: trainingId,
            name: updatedNameTitle,
            typeTape: updatedTypeTape,
            height: updatedHeight,
            trainingPlace: updatedTraining,
            time: updatedTime,
            description: updatedDescription
        )

        if let updatedTraining = TrainingDataManager.shared.loadTraining(withId: trainingId) {
            delegate?.didUpdateTraining(updatedTraining)
        } else {
            print("Failed to load updated model")
        }

        didTapBack()
    }

    // MARK: - Data Persistence Methods
    private func loadTraining() -> [TrainingModel] {
        return TrainingDataManager.shared.loadTrainings()
    }

    private func configure(with model: TrainingModel?) {
        guard let model = model else { return }
        nameView.textField.text = model.name
        typeTapeView.textField.text = model.typeTape
        heightView.textField.text = model.height
        trainingPlaceView.textField.text = model.trainingPlace
        timeView.textField.text = model.time
        descriptionView.textView.text = model.description
        descriptionView.placeholderLabel.isHidden = !model.description.isEmpty

        updateAddButtonState()
    }
}

// MARK: - AppTextFieldDelegate
extension NewTrainingViewController: AppTextFieldDelegate {
    func didTapTextField(type: AppTextFieldView.TextFieldType) {
        updateAddButtonState()
    }
}

// MARK: - UITextViewDelegate
extension NewTrainingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateAddButtonState()
    }
}

// MARK: - KeyBoard Apparance
extension NewTrainingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewTrainingViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        KeyboardManager.shared.keyboardWillShow(notification as Notification)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        KeyboardManager.shared.keyboardWillHide(notification as Notification)
    }
}
