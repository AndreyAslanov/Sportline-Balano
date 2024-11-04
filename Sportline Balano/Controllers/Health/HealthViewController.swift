import SnapKit
import UIKit

final class HealthViewController: UIViewController {
    private let healthLabel = UILabel()
    private let progressView = ProgressView()
    private let moodView = CustomSlider()
    private let moodContainerView = UIView()
    private let moodTrainingLabel = UILabel()
    private let upImageView = UIImageView()
    private let downImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.black
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        view.backgroundColor = UIColor(hex: "#1F1F1F")

        drawself()
        progressView.delegate = self
        moodView.delegate = self

        if let pulseName = PulseDataManager.shared.fetchData() {
            progressView.configurePulseValueLabel(with: pulseName)
        }

        if let weightName = WeightDataManager.shared.fetchData() {
            progressView.configureWeightValueLabel(with: weightName)
        }        
        
        if let sleepName = SleepDataManager.shared.fetchData() {
            progressView.configureSleepValueLabel(with: sleepName)
        }

        if let caloriesName = CaloriesDataManager.shared.fetchData() {
            progressView.configureCaloriesValueLabel(with: caloriesName)
        }
        
        let sliderValue = SlideDataManager.shared.fetchData() ?? 0  
        moodView.setSliderValue(value: sliderValue, animated: false)
    }

    private func drawself() {
        downImageView.image = R.image.health_down()
        upImageView.image = R.image.health_up()
        
        healthLabel.do { make in
            make.text = L.health()
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textColor = .white
            make.textAlignment = .left
        }
        
        moodContainerView.do { make in
            make.backgroundColor = .white.withAlphaComponent(0.08)
            make.layer.cornerRadius = 20
            make.isUserInteractionEnabled = true
        }
        
        moodTrainingLabel.do { make in
            make.text = L.moodTraining()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .left
        }
        
        moodContainerView.addSubviews(moodTrainingLabel, moodView, upImageView, downImageView)
        view.addSubviews(
            healthLabel, progressView, moodContainerView
        )

        healthLabel.snp.makeConstraints { make in
            if UIDevice.isIphoneBelowX {
                make.top.equalToSuperview().offset(34)
            } else {
                make.top.equalToSuperview().offset(74)
            }
            make.leading.equalToSuperview().offset(15)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(healthLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(321)
        }
      
        moodContainerView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(105)
        }
        
        moodTrainingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
        }
        
        moodView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(233)
            make.height.equalTo(44)
        }
        
        downImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        upImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Public Func For Deleting
    func deleteHealthData() {
        PulseDataManager.shared.deleteData()
        WeightDataManager.shared.deleteData()
        SleepDataManager.shared.deleteData()
        CaloriesDataManager.shared.deleteData()
        SlideDataManager.shared.deleteData()
        refreshUI()
    }
    
    private func refreshUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        drawself()
    }
}

// MARK: - ProgressViewDelegate
extension HealthViewController: ProgressViewDelegate {
    func didTapPulseButton() {
        let alertController = UIAlertController(title: L.healthPulse(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "beats"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            PulseDataManager.shared.saveData(nameText)
            self.progressView.configurePulseValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }

    func didTapWeightButton() {
        let alertController = UIAlertController(title: L.healthWeight(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "kg"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            WeightDataManager.shared.saveData(nameText)
            self.progressView.configureWeightValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
    
    func didTapSleepButton() {
        let alertController = UIAlertController(title: L.healthSleep(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "hours"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            SleepDataManager.shared.saveData(nameText)
            self.progressView.configureSleepValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
    
    func didTapCaloriesButton() {
        let alertController = UIAlertController(title: L.healthCalories(), message: L.trackProgress(), preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "calories"
            textField.keyboardType = .phonePad
        }

        let cancelAction = UIAlertAction(title: L.close(), style: .default, handler: nil)

        let saveAction = UIAlertAction(title: L.save(), style: .cancel) { _ in
            guard let nameText = alertController.textFields?[0].text,
                  !nameText.isEmpty else {
                return
            }

            CaloriesDataManager.shared.saveData(nameText)
            self.progressView.configureCaloriesValueLabel(with: nameText)
        }

        saveAction.setValue(UIColor(hex: "#0A84FF"), forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.overrideUserInterfaceStyle = .dark

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - LanguageViewDelegate
extension HealthViewController: CustomSliderDelegate {
    func sliderValueDidChange(_ slider: CustomSlider, value: Int) {
        SlideDataManager.shared.saveData(value)
    }
}
