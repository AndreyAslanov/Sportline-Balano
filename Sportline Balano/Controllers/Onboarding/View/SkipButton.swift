import UIKit

final class SkipButton: UIControl {
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
            make.backgroundColor = .clear
            make.layer.cornerRadius = 22.5
            make.isUserInteractionEnabled = false
            make.layer.borderColor = UIColor.white.cgColor
            make.layer.borderWidth = 1.0
            make.layer.cornerRadius = 14
            make.clipsToBounds = true
        }

        titleLabel.do { make in
            make.text = L.skip()
            make.textColor = .white
            make.font = .systemFont(ofSize: 15)
            make.isUserInteractionEnabled = false
        }

        buttonContainer.addSubview(titleLabel)
        addSubviews(buttonContainer)

        titleLabel.snp.makeConstraints { make in
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
}
