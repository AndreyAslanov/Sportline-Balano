import SnapKit
import UIKit

protocol SettingsViewDelegate: AnyObject {
    func didTapView(type: SettingsView.SelfType)
}

final class SettingsView: UIControl {
    enum SelfType {
        case shareApp
        case usagePolicy
        case rateApp
        case reset

        var title: String {
            switch self {
            case .shareApp: return L.shareApp()
            case .usagePolicy: return L.usagePolicy()
            case .rateApp: return L.rateApp()
            case .reset: return L.reset()
            }
        }
        
        var image: UIImage? {
            switch self {
            case .shareApp: return R.image.settings_share_icon()
            case .usagePolicy: return R.image.settings_policy_icon()
            case .rateApp: return R.image.settings_rate_icon()
            case .reset: return R.image.settings_reset_icon()
            }
        }
    }

    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let imageView = UIImageView()
    private let stackView = UIStackView()
    override var isHighlighted: Bool {
        didSet {
            configureAppearance()
        }
    }

    private let type: SelfType
    weak var delegate: SettingsViewDelegate?

    init(type: SelfType) {
        self.type = type
        super.init(frame: .zero)
        setupView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        if type == .reset {
            backgroundColor = UIColor(hex: "#FD5B19")
        } else {
            backgroundColor = .white.withAlphaComponent(0.08)
        }
        
        layer.cornerRadius = 22.5
        imageView.image = type.image
        imageView.contentMode = .scaleAspectFit
        arrowImageView.image = R.image.settings_arrow()
        
        titleLabel.do { make in
            make.textColor = .white
            make.font = .systemFont(ofSize: 15, weight: .medium)
            make.text = type.title
        }
        
        stackView.do { make in
            make.axis = .horizontal
            make.spacing = 5
            make.alignment = .center
            make.distribution = .fillProportionally
            make.isUserInteractionEnabled = false
        }
        
        if type == .reset {
            stackView.addArrangedSubviews([imageView, titleLabel])
            addSubviews(stackView)
        } else {
            addSubviews(imageView, titleLabel, arrowImageView)
        }
        
        if type == .reset {
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(136)
            }
            
            imageView.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(imageView.snp.trailing).offset(15)
                make.centerY.equalToSuperview()
            }

            imageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(26)
                make.centerY.equalToSuperview()
                make.size.equalTo(24)
            }
            
            arrowImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(26)
                make.height.equalTo(17)
                make.width.equalTo(10)
            }
        }
    }

    private func configureAppearance() {
        alpha = isHighlighted ? 0.5 : 1
    }

    @objc private func didTapView() {
        delegate?.didTapView(type: type)
    }
}
