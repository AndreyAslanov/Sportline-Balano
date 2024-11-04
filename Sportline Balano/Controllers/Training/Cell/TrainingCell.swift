import SnapKit
import UIKit

protocol TrainingCellDelegate: AnyObject {
    func didTapEditButton(with model: TrainingModel)
    func didTapDeleteButton(with model: TrainingModel)
}

class TrainingCell: UICollectionViewCell {
    static let reuseIdentifier = "TrainingCell"
    weak var delegate: TrainingCellDelegate?
    var trainingModel: TrainingModel?
    
    private let nameLabel = UILabel()
    
    private let typeLabel = UILabel()
    private let typeValueLabel = UILabel()
    private let typeStackView = UIStackView()    
    
    private let heightLabel = UILabel()
    private let heightValueLabel = UILabel()
    private let heightStackView = UIStackView()    
    
    private let timeLabel = UILabel()
    private let timeValueLabel = UILabel()
    private let timeStackView = UIStackView()
    
    private let placeLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let firstView = UIView()
    private let secondView = UIView()
    private let thirdView = UIView()
    
    private let deleteButton = UIButton()
    private let editButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white.withAlphaComponent(0.08)
        layer.cornerRadius = 8
        
        [nameLabel, placeLabel].forEach { label in
            label.do { make in
                make.font = .systemFont(ofSize: 17, weight: .semibold)
                make.textColor = .white
                make.textAlignment = .left
            }
        }        
        
        [typeLabel, heightLabel, timeLabel].forEach { label in
            label.do { make in
                make.font = .systemFont(ofSize: 12, weight: .medium)
                make.textColor = .white.withAlphaComponent(0.7)
                make.textAlignment = .center
            }
        }    
        
        typeLabel.text = L.typeTape()
        heightLabel.text = L.height()
        timeLabel.text = L.time()
        
        [typeValueLabel, heightValueLabel, timeValueLabel].forEach { label in
            label.do { make in
                make.font = .systemFont(ofSize: 17, weight: .semibold)
                make.textColor = .white
                make.textAlignment = .center
            }
        }
        
        [typeStackView, heightStackView, timeStackView].forEach { stackView in
            stackView.do { make in
                make.axis = .vertical
                make.spacing = 6
                make.alignment = .center
                make.distribution = .fillProportionally
            }
        }        
        
        [firstView, secondView, thirdView].forEach { view in
            view.do { make in
                make.backgroundColor = .white.withAlphaComponent(0.3)
                make.layer.cornerRadius = 1
            }
        }
        
        descriptionLabel.do { make in
            make.font = .systemFont(ofSize: 12, weight: .medium)
            make.textColor = .white.withAlphaComponent(0.7)
            make.textAlignment = .left
            make.numberOfLines = 2
        }
        
        deleteButton.do { make in
            make.setImage(UIImage(systemName: "trash"), for: .normal)
            make.tintColor = .white
            make.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        }        
        
        editButton.do { make in
            make.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            make.tintColor = .white
            make.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        }

        typeStackView.addArrangedSubviews([typeLabel, typeValueLabel])
        heightStackView.addArrangedSubviews([heightLabel, heightValueLabel])
        timeStackView.addArrangedSubviews([timeLabel, timeValueLabel])
        
        contentView.addSubviews(
            nameLabel, deleteButton, editButton, typeStackView,
            heightStackView, timeStackView, placeLabel, descriptionLabel,
            firstView, secondView, thirdView
        )
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(editButton.snp.leading).offset(-12)
            make.height.equalTo(22)
        }
        
        typeStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(firstView.snp.leading).offset(-8)
        }        
        
        firstView.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.top)
            make.bottom.equalTo(typeStackView.snp.bottom)
            make.width.equalTo(2)
            make.leading.equalTo(typeStackView.snp.trailing).offset(6.5)
            make.trailing.equalTo(heightStackView.snp.leading).offset(-6.5)
        }
        
        heightStackView.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.top)
            make.leading.equalTo(firstView.snp.trailing).offset(8)
            make.trailing.equalTo(secondView.snp.leading).offset(-8)
            make.centerX.equalToSuperview()
            make.width.equalTo(typeStackView.snp.width)
        }       
        
        secondView.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.top)
            make.bottom.equalTo(typeStackView.snp.bottom)
            make.width.equalTo(2)
            make.leading.equalTo(heightStackView.snp.trailing).offset(6.5)
            make.trailing.equalTo(timeStackView.snp.leading).offset(-6.5)
        }
        
        timeStackView.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.top)
            make.leading.equalTo(heightStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(typeStackView.snp.width)
        }
        
        thirdView.snp.makeConstraints { make in
            make.top.equalTo(heightStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(2)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(22)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(32)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(deleteButton.snp.leading)
            make.size.equalTo(32)
        }
    }

    @objc private func didTapEditButton() {
        guard let model = trainingModel else { return }
        delegate?.didTapEditButton(with: model)
    }
    
    @objc private func didTapDeleteButton() {
        guard let model = trainingModel else { return }
        delegate?.didTapDeleteButton(with: model)
    }

    func configure(with model: TrainingModel) {
        trainingModel = model
        nameLabel.text = model.name
        typeValueLabel.text = model.typeTape
        heightValueLabel.text = model.height
        timeValueLabel.text = model.time
        placeLabel.text = model.trainingPlace
        descriptionLabel.text = model.description
    }
}
