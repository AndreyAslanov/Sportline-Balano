import SnapKit
import UIKit

protocol ProgressViewDelegate: AnyObject {
    func didTapPulseButton()
    func didTapWeightButton()
    func didTapSleepButton()
    func didTapCaloriesButton()
}

final class ProgressView: UIControl {
    weak var delegate: ProgressViewDelegate?

    private let progressLabel = UILabel()
    private let pulseView = UIView()
    private let weightView = UIView()
    private let sleepView = UIView()
    private let caloriesView = UIView()

    private let pulseImageView = UIImageView()
    private let weightImageView = UIImageView()
    private let sleepImageView = UIImageView()
    private let caloriesImageView = UIImageView()

    private let pulseLabel = UILabel()
    private let weightLabel = UILabel()
    private let sleepLabel = UILabel()
    private let caloriesLabel = UILabel()

    private let pulseValueLabel = UILabel()
    private let weightValueLabel = UILabel()
    private let sleepValueLabel = UILabel()
    private let caloriesValueLabel = UILabel()

    private let pulseButton = UIButton()
    private let weightButton = UIButton()
    private let sleepButton = UIButton()
    private let caloriesButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawSelf()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func drawSelf() {
        backgroundColor = .white.withAlphaComponent(0.08)
        layer.cornerRadius = 20

        pulseImageView.image = R.image.health_pulse_icon()
        weightImageView.image = R.image.health_weight_icon()
        sleepImageView.image = R.image.health_sleep_icon()
        caloriesImageView.image = R.image.health_calories_icon()

        progressLabel.do { make in
            make.text = L.progress()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .left
        }

        [pulseView, weightView, sleepView, caloriesView].forEach { view in
            view.do { make in
                make.backgroundColor = .white.withAlphaComponent(0.08)
                make.layer.cornerRadius = 8
                make.isUserInteractionEnabled = true
            }
        }

        [pulseLabel, weightLabel, sleepLabel, caloriesLabel].forEach { label in
            label.do { make in
                make.font = .systemFont(ofSize: 12, weight: .medium)
                make.textColor = .white.withAlphaComponent(0.7)
                make.numberOfLines = 0
            }
        }

        [pulseValueLabel, weightValueLabel, sleepValueLabel, caloriesValueLabel].forEach { label in
            label.do { make in
                make.text = L.noData()
                make.font = .systemFont(ofSize: 17, weight: .semibold)
                make.textColor = .white.withAlphaComponent(0.7)
                make.numberOfLines = 0
            }
        }

        pulseButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let bookImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(bookImage, for: .normal)
            make.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }

        weightButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let pageImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(pageImage, for: .normal)
            make.addTarget(self, action: #selector(weightButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }        
        
        sleepButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let pageImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(pageImage, for: .normal)
            make.addTarget(self, action: #selector(sleepButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }       
        
        caloriesButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let pageImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(pageImage, for: .normal)
            make.addTarget(self, action: #selector(caloriesButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }

        pulseLabel.text = L.healthPulse()
        weightLabel.text = L.healthWeight()
        sleepLabel.text = L.healthSleep()
        caloriesLabel.text = L.healthCalories()

        pulseView.addSubviews(pulseImageView, pulseLabel, pulseValueLabel, pulseButton)
        weightView.addSubviews(weightImageView, weightLabel, weightValueLabel, weightButton)
        sleepView.addSubviews(sleepImageView, sleepLabel, sleepValueLabel, sleepButton)
        caloriesView.addSubviews(caloriesImageView, caloriesLabel, caloriesValueLabel, caloriesButton)

        addSubviews(progressLabel, pulseView, weightView, sleepView, caloriesView)
    }

    private func setupConstraints() {
        progressLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
        }

        pulseView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(12)
            make.height.equalTo(122)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }

        weightView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(15)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(122)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }
        
        sleepView.snp.makeConstraints { make in
            make.top.equalTo(pulseView.snp.bottom).offset(15)
            make.leading.bottom.equalToSuperview().inset(12)
            make.height.equalTo(122)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }
        
        caloriesView.snp.makeConstraints { make in
            make.top.equalTo(pulseView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(122)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }

        [pulseImageView, weightImageView, sleepImageView, caloriesImageView].forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(12)
                make.size.equalTo(40)
            }
        }

        pulseLabel.snp.makeConstraints { make in
            make.top.equalTo(pulseImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(weightImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }        
        
        sleepLabel.snp.makeConstraints { make in
            make.top.equalTo(sleepImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }        
        
        caloriesLabel.snp.makeConstraints { make in
            make.top.equalTo(caloriesImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        [pulseValueLabel, weightValueLabel, sleepValueLabel, caloriesValueLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview().inset(12)
            }
        }

        pulseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(pulseImageView.snp.centerY)
            make.size.equalTo(32)
        }

        weightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(weightImageView.snp.centerY)
            make.size.equalTo(32)
        }        
        
        sleepButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(sleepImageView.snp.centerY)
            make.size.equalTo(32)
        }        
        
        caloriesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(caloriesImageView.snp.centerY)
            make.size.equalTo(32)
        }
    }

    @objc private func pulseButtonTapped() {
        delegate?.didTapPulseButton()
    }

    @objc private func weightButtonTapped() {
        delegate?.didTapWeightButton()
    }
    
    @objc private func sleepButtonTapped() {
        delegate?.didTapSleepButton()
    }
    
    @objc private func caloriesButtonTapped() {
        delegate?.didTapCaloriesButton()
    }

    func configurePulseValueLabel(with value: String) {
        pulseValueLabel.text = "\(value) beats"
        pulseValueLabel.textColor = UIColor(hex: "#FD5B19")
    }

    func configureWeightValueLabel(with value: String) {
        weightValueLabel.text = "\(value) kg"
        weightValueLabel.textColor = UIColor(hex: "#FD5B19")
    }
    
    func configureSleepValueLabel(with value: String) {
        sleepValueLabel.text = "\(value) hours"
        sleepValueLabel.textColor = UIColor(hex: "#FD5B19")
    }

    func configureCaloriesValueLabel(with value: String) {
        caloriesValueLabel.text = value
        caloriesValueLabel.textColor = UIColor(hex: "#FD5B19")
    }
}
