import SnapKit
import UIKit

protocol TrainingProgressViewDelegate: AnyObject {
    func didTapHeightButton()
    func didTapDistanceButton()
    func didTapTimeButton()
    func didTapSpeedButton()
}

final class TrainingProgressView: UIControl {
    weak var delegate: TrainingProgressViewDelegate?

    private let progressLabel = UILabel()
    
    private let heightView = UIView()
    private let distanceView = UIView()
    private let timeView = UIView()
    private let speedView = UIView()

    private let heightImageView = UIImageView()
    private let distanceImageView = UIImageView()
    private let timeImageView = UIImageView()
    private let speedImageView = UIImageView()

    private let heightLabel = UILabel()
    private let distanceLabel = UILabel()
    private let timeLabel = UILabel()
    private let speedLabel = UILabel()

    private let heightValueLabel = UILabel()
    private let distanceValueLabel = UILabel()
    private let timeValueLabel = UILabel()
    private let speedValueLabel = UILabel()

    private let heightButton = UIButton()
    private let distanceButton = UIButton()
    private let timeButton = UIButton()
    private let speedButton = UIButton()

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

        heightImageView.image = R.image.training_height_icon()
        distanceImageView.image = R.image.training_distance_icon()
        timeImageView.image = R.image.training_time_icon()
        speedImageView.image = R.image.training_speed_icon()

        progressLabel.do { make in
            make.text = L.progress()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .left
        }

        [heightView, distanceView, timeView, speedView].forEach { view in
            view.do { make in
                make.backgroundColor = .white.withAlphaComponent(0.08)
                make.layer.cornerRadius = 8
                make.isUserInteractionEnabled = true
            }
        }

        [heightLabel, distanceLabel, timeLabel, speedLabel].forEach { label in
            label.do { make in
                make.font = .systemFont(ofSize: 12, weight: .medium)
                make.textColor = .white.withAlphaComponent(0.7)
                make.numberOfLines = 0
            }
        }

        [heightValueLabel, distanceValueLabel, timeValueLabel, speedValueLabel].forEach { label in
            label.do { make in
                make.text = L.noData()
                make.font = .systemFont(ofSize: 17, weight: .semibold)
                make.textColor = .white.withAlphaComponent(0.7)
                make.numberOfLines = 0
            }
        }

        heightButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let bookImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(bookImage, for: .normal)
            make.addTarget(self, action: #selector(heightButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }

        distanceButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let pageImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(pageImage, for: .normal)
            make.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }
        
        timeButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let pageImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(pageImage, for: .normal)
            make.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }
        
        speedButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let pageImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(pageImage, for: .normal)
            make.addTarget(self, action: #selector(speedButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }

        heightLabel.text = L.maxHeight()
        distanceLabel.text = L.maxDistance()
        timeLabel.text = L.trainingTime()
        speedLabel.text = L.windSpeed()

        heightView.addSubviews(heightImageView, heightLabel, heightValueLabel, heightButton)
        distanceView.addSubviews(distanceImageView, distanceLabel, distanceValueLabel, distanceButton)
        timeView.addSubviews(timeImageView, timeLabel, timeValueLabel, timeButton)
        speedView.addSubviews(speedImageView, speedLabel, speedValueLabel, speedButton)

        addSubviews(progressLabel, heightView, distanceView, timeView, speedView)
    }

    private func setupConstraints() {
        progressLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.height.equalTo(22)
        }

        heightView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(12)
            make.height.equalTo(122)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }

        distanceView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(15)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(heightView.snp.height)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }
        
        timeView.snp.makeConstraints { make in
            make.top.equalTo(heightView.snp.bottom).offset(15)
            make.leading.bottom.equalToSuperview().inset(12)
            make.height.equalTo(heightView.snp.height)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }
        
        speedView.snp.makeConstraints { make in
            make.top.equalTo(heightView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(heightView.snp.height)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
        }

        [heightImageView, distanceImageView, timeImageView, speedImageView].forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(12)
                make.size.equalTo(40)
            }
        }

        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        speedLabel.snp.makeConstraints { make in
            make.top.equalTo(speedImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        [heightValueLabel, distanceValueLabel, timeValueLabel, speedValueLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview().inset(12)
            }
        }

        heightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(heightImageView.snp.centerY)
            make.size.equalTo(32)
        }

        distanceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(distanceImageView.snp.centerY)
            make.size.equalTo(32)
        }
        
        timeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(timeImageView.snp.centerY)
            make.size.equalTo(32)
        }
        
        speedButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(speedImageView.snp.centerY)
            make.size.equalTo(32)
        }
    }

    @objc private func heightButtonTapped() {
        delegate?.didTapHeightButton()
    }

    @objc private func distanceButtonTapped() {
        delegate?.didTapDistanceButton()
    }
    
    @objc private func timeButtonTapped() {
        delegate?.didTapTimeButton()
    }
    
    @objc private func speedButtonTapped() {
        delegate?.didTapSpeedButton()
    }

    func configureHeightValueLabel(with value: String) {
        heightValueLabel.text = "\(value) m"
        heightValueLabel.textColor = UIColor(hex: "#FD5B19")
    }

    func configureDistanceValueLabel(with value: String) {
        distanceValueLabel.text = "\(value) m"
        distanceValueLabel.textColor = UIColor(hex: "#FD5B19")
    }
    
    func configureTimeValueLabel(with value: String) {
        timeValueLabel.text = "\(value) min"
        timeValueLabel.textColor = UIColor(hex: "#FD5B19")
    }

    func configureSpeedValueLabel(with value: String) {
        speedValueLabel.text = "\(value) m/sec"
        speedValueLabel.textColor = UIColor(hex: "#FD5B19")
    }
}
