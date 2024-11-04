import SnapKit
import UIKit

protocol AppTextFieldDelegate: AnyObject {
    func didTapTextField(type: AppTextFieldView.TextFieldType)
}

final class AppTextFieldView: UIControl {
    enum TextFieldType {
        case name
        case typeTape
        case height
        case trainingPlace
        case time
        case description
        
        var title: String {
            switch self {
            case .name: L.name()
            case .typeTape: L.typeTape()
            case .height: L.height()
            case .trainingPlace: L.trainingPlace()
            case .time: L.time()
            case .description: L.description()
            }
        }

        var placeholder: String {
            switch self {
            case .name: L.value()
            case .typeTape: L.value()
            case .height: L.value()
            case .trainingPlace: L.value()
            case .time: L.value()
            case .description: L.value()
            }
        }
    }

    private let type: TextFieldType
    weak var delegate: AppTextFieldDelegate?

    let textField = UITextField()
    let textView = UITextView()
    let placeholderLabel = UILabel()
    let titleLabel = UILabel()

    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        drawSelf()
        setupConstraints()
        configureButtonActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func drawSelf() {
        backgroundColor = UIColor(hex: "#838383")
        layer.cornerRadius = 10
        
        if type == .description {
            textView.do { make in
                make.font = .systemFont(ofSize: 15)
                make.textColor = .black.withAlphaComponent(0.7)
                make.textAlignment = .left
                make.backgroundColor = .clear
                make.delegate = self
                make.showsVerticalScrollIndicator = false
                make.showsHorizontalScrollIndicator = false
            }
            
            titleLabel.do { make in
                make.text = type.title
                make.font = .systemFont(ofSize: 15)
                make.textColor = .black
                make.textAlignment = .left
            }
            
            placeholderLabel.do { make in
                make.text = type.placeholder
                make.font = .systemFont(ofSize: 15)
                make.textColor = UIColor.black.withAlphaComponent(0.3)
                make.isHidden = !textView.text.isEmpty
            }

            addSubviews(textView, titleLabel, placeholderLabel)
        } else {
            titleLabel.do { make in
                make.text = type.title
                make.font = .systemFont(ofSize: 15)
                make.textColor = .black
                make.textAlignment = .left
            }
            
            textField.do { make in
                make.font = .systemFont(ofSize: 15)
                make.textColor = .black.withAlphaComponent(0.7)
                make.textAlignment = .left
                
                let placeholderColor = UIColor.black.withAlphaComponent(0.3)
                let placeholderFont = UIFont.systemFont(ofSize: 15)
                let placeholderText = type.placeholder
                
                textField.attributedPlaceholder = NSAttributedString(
                    string: placeholderText,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: placeholderColor,
                        NSAttributedString.Key.font: placeholderFont
                    ]
                )
            }

            addSubviews(titleLabel, textField)
        }
    }

    private func setupConstraints() {
        if type == .description {
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalTo(textView.snp.leading).offset(-15)
                make.width.equalTo(79)
            }
            
            textView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(3)
                make.leading.equalTo(titleLabel.snp.trailing).offset(15)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            placeholderLabel.snp.makeConstraints { make in
                make.top.equalTo(textView.snp.top).offset(9)
                make.leading.equalTo(textView.snp.leading).offset(5)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalTo(textField.snp.leading).offset(-15)
                if type == .name {
                    make.width.equalTo(42)
                } else if type == .typeTape {
                    make.width.equalTo(87)
                } else if type == .height {
                    make.width.equalTo(47)
                } else if type == .trainingPlace {
                    make.width.equalTo(96)
                } else if type == .time {
                    make.width.equalTo(36)
                }
            }
            
            textField.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(titleLabel.snp.trailing).offset(-15)
                make.trailing.equalToSuperview().inset(16)
            }
        }
    }

    private func configureButtonActions() {
        textView.delegate = self
        textView.isEditable = true
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChangeNotification(_:)), name: UITextView.textDidChangeNotification, object: textView)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        addTarget(self, action: #selector(didTapButton), for: .touchUpOutside)

        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.didTapTextField(type: type)
    }

    @objc private func didTapButton() {
        delegate?.didTapTextField(type: type)
    }

    @objc private func textViewDidChangeNotification(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            placeholderLabel.isHidden = !textView.text.isEmpty
            delegate?.didTapTextField(type: type)
        }
    }
}

// MARK: - UITextViewDelegate
extension AppTextFieldView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.didTapTextField(type: type)
    }
}
