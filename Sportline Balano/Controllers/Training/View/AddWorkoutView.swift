import SnapKit
import UIKit

protocol AddWorkoutViewDelegate: AnyObject {
    func didTapAddButton()
}

final class AddWorkoutView: UIControl {
    weak var delegate: AddWorkoutViewDelegate?
    
    private let title = UILabel()
    private let buttonView = UIView()
    private let plusImageView = UIImageView()
    private let addLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawSelf()
        setupConstraints()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func drawSelf() {
        backgroundColor = .white.withAlphaComponent(0.08)
        layer.cornerRadius = 16

        title.do { make in
            make.text = L.addWorkout()
            make.font = .systemFont(ofSize: 28, weight: .bold)
            make.textColor = .white
            make.textAlignment = .center
            make.isUserInteractionEnabled = false
        }
        
        buttonView.do { make in
            make.backgroundColor = UIColor(hex: "#FD5B19")
            make.layer.cornerRadius = 17.5
            make.clipsToBounds = true
        }
        
        addLabel.do { make in
            make.text = L.add()
            make.textColor = .white
            make.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }

        buttonView.addSubviews(addLabel)
        addSubviews(title, buttonView)
    }

    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.centerX.equalToSuperview()
        }

        buttonView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(178)
        }
        
        addLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addViewTapped))
        buttonView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func addViewTapped() {
        delegate?.didTapAddButton()
    }
    
    func updateTitle(with newText: String) {
        title.text = newText
    }
}
