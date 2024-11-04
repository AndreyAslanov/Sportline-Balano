import SnapKit
import UIKit

final class SettingsViewController: UIViewController {
    private let settingsLabel = UILabel()
    private let settingsStackView = UIStackView()
    
    private let homeVC = HomeViewController()
    private let trainingVC = TrainingViewController()
    private let healthVC = HealthViewController()
    
    private let shareAppView: SettingsView
    private let usagePolicyView: SettingsView
    private let rateAppView: SettingsView
    private let resetView: SettingsView

    init() {
        shareAppView = SettingsView(type: .shareApp)
        usagePolicyView = SettingsView(type: .usagePolicy)
        rateAppView = SettingsView(type: .rateApp)
        resetView = SettingsView(type: .reset)
        
        super.init(nibName: nil, bundle: nil)
        
        shareAppView.delegate = self
        usagePolicyView.delegate = self
        rateAppView.delegate = self
        resetView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1F1F1F")
        drawself()
    }

    private func drawself() {
        settingsLabel.do { make in
            make.text = L.settings()
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textColor = .white
            make.textAlignment = .left
        }
        
        settingsStackView.do { make in
            make.axis = .vertical
            make.spacing = 14
            make.distribution = .equalSpacing
        }

        settingsStackView.addArrangedSubviews(
            [usagePolicyView, rateAppView, shareAppView, resetView]
        )
        
        view.addSubviews(settingsLabel, settingsStackView)
        
        settingsLabel.snp.makeConstraints { make in
            if UIDevice.isIphoneBelowX {
                make.top.equalToSuperview().offset(34)
            } else {
                make.top.equalToSuperview().offset(74)
            }
            make.leading.equalToSuperview().offset(15)
        }
        
        settingsStackView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        [shareAppView, usagePolicyView, rateAppView, resetView].forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(45)
            }
        }
    }
}

// MARK: - ProfileViewDelegate
extension SettingsViewController: SettingsViewDelegate {
    func didTapView(type: SettingsView.SelfType) {
        switch type {
        case .shareApp:
            AppActions.shared.shareApp()
        case .usagePolicy:
            AppActions.shared.showUsagePolicy()
        case .rateApp:
            AppActions.shared.rateApp()
        case .reset:
            trainingVC.deleteTrainingData()
            homeVC.deleteHomeData()
            healthVC.deleteHealthData()
        }
    }
}
