import SnapKit
import UIKit

protocol ProgressMonthViewDelegate: AnyObject {
    func didTapTrainingButton()
    func didTapHeightButton()
}

final class ProgressMonthView: UIControl {
    weak var delegate: ProgressMonthViewDelegate?

    private let progressMonthLabel = UILabel()
    private let trainingView = UIView()
    private let heightView = UIView()

    private let trainingImageView = UIImageView()
    private let heightImageView = UIImageView()

    private let numberTrainingLabel = UILabel()
    private let numberHeightLabel = UILabel()

    private let trainingValueLabel = UILabel()
    private let heightValueLabel = UILabel()

    private let trainingButton = UIButton()
    private let heightButton = UIButton()

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

        trainingImageView.image = R.image.home_training_icon()
        heightImageView.image = R.image.home_height_icon()

        progressMonthLabel.do { make in
            make.text = L.progressMonth()
            make.font = .systemFont(ofSize: 17, weight: .semibold)
            make.textColor = .white
            make.textAlignment = .left
        }

        [trainingView, heightView].forEach { view in
            view.do { make in
                make.backgroundColor = .white.withAlphaComponent(0.08)
                make.layer.cornerRadius = 8
                make.isUserInteractionEnabled = true
            }
        }

        [numberTrainingLabel, numberHeightLabel].forEach { label in
            label.do { make in
                make.font = .systemFont(ofSize: 12, weight: .medium)
                make.textColor = .white.withAlphaComponent(0.7)
                make.numberOfLines = 0
            }
        }

        [trainingValueLabel, heightValueLabel].forEach { label in
            label.do { make in
                make.text = L.noData()
                make.font = .systemFont(ofSize: 17, weight: .semibold)
                make.textColor = .white.withAlphaComponent(0.7)
                make.numberOfLines = 0
            }
        }

        trainingButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let trainingImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(trainingImage, for: .normal)
            make.addTarget(self, action: #selector(trainingButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }

        heightButton.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let heightImage = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)

            make.setImage(heightImage, for: .normal)
            make.addTarget(self, action: #selector(heightButtonTapped), for: .touchUpInside)
            make.tintColor = .white
        }

        numberTrainingLabel.text = L.numberTraining()
        numberHeightLabel.text = L.heightTape()

        trainingView.addSubviews(trainingImageView, numberTrainingLabel, trainingValueLabel, trainingButton)
        heightView.addSubviews(heightImageView, numberHeightLabel, heightValueLabel, heightButton)

        addSubviews(progressMonthLabel, trainingView, heightView)
    }

    private func setupConstraints() {
        progressMonthLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
        }

        trainingView.snp.makeConstraints { make in
            make.top.equalTo(progressMonthLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(64)
        }

        heightView.snp.makeConstraints { make in
            make.top.equalTo(trainingView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(64)
        }

        [trainingImageView, heightImageView].forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().offset(12)
                make.size.equalTo(40)
            }
        }

        numberTrainingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(trainingImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
        }

        numberHeightLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(heightImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
        }
        
        trainingValueLabel.snp.makeConstraints { make in
            make.top.equalTo(numberTrainingLabel.snp.bottom)
            make.leading.equalTo(heightImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
        }        
        
        heightValueLabel.snp.makeConstraints { make in
            make.top.equalTo(numberHeightLabel.snp.bottom)
            make.leading.equalTo(heightImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
        }

        trainingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(trainingImageView.snp.centerY)
            make.size.equalTo(32)
        }

        heightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(heightImageView.snp.centerY)
            make.size.equalTo(32)
        }
    }

    @objc private func trainingButtonTapped() {
        delegate?.didTapTrainingButton()
    }

    @objc private func heightButtonTapped() {
        delegate?.didTapHeightButton()
    }

    func configureTrainingValueLabel(with value: String) {
        trainingValueLabel.text = value
        trainingValueLabel.textColor = UIColor(hex: "#FD5B19")
    }

    func configureHeightValueLabel(with value: String) {
        heightValueLabel.text = "\(value) m"
        heightValueLabel.textColor = UIColor(hex: "#FD5B19")
    }
}
