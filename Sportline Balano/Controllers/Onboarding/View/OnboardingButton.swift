import UIKit

final class OnboardingButton: UIControl {
    // MARK: - Properties

    override var isHighlighted: Bool {
        didSet {
            configureAppearance()
        }
    }

    private var didAddGradient = false
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let buttonStackView = UIStackView()
    let buttonContainer = UIView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawSelf()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func drawSelf() {
        buttonContainer.do { make in
            make.backgroundColor = UIColor(hex: "#FD5B19")
            make.layer.cornerRadius = 22.5
            make.isUserInteractionEnabled = false
        }

        titleLabel.do { make in
            make.text = L.further()
            make.textColor = .white
            make.font = .systemFont(ofSize: 16, weight: .semibold)
            make.isUserInteractionEnabled = false
        }
        
        arrowImageView.do { make in
            let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            make.image = UIImage(systemName: "arrow.forward", withConfiguration: configuration)
            make.tintColor = .white
        }
        
        buttonStackView.do { make in
            make.axis = .horizontal
            make.spacing = 12
            make.alignment = .center
            make.distribution = .fillProportionally
        }

        buttonContainer.addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews([titleLabel, arrowImageView])
        addSubviews(buttonContainer)

        buttonStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        buttonContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureAppearance() {
        alpha = isHighlighted ? 0.7 : 1
    }

    func setTitle(to title: String) {
        titleLabel.text = title
    }

    func setBackgroundColor(_ color: UIColor) {
        buttonContainer.backgroundColor = color
    }

    func setTextColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    func deleteMode() {
        arrowImageView.isHidden = true
        buttonContainer.backgroundColor = .clear
        buttonContainer.layer.cornerRadius = 22.5
        buttonContainer.layer.borderColor = UIColor.red.cgColor
        buttonContainer.layer.borderWidth = 2
        
        titleLabel.text = L.delete()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    func saveMode() {
        arrowImageView.isHidden = true
    }
}
