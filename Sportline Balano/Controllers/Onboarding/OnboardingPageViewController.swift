import UIKit

protocol OnboardingPageViewControllerDelegate: AnyObject {
    func didTapContinue()
}

final class OnboardingPageViewController: UIViewController {
    // MARK: - Types

    enum Page {
        case tracker, welcome, firstTraining, secondTraining, thirdTraining, fourthTraining, choose
    }

    weak var delegate: OnboardingPageViewControllerDelegate?
    private let nameImageView = UIImageView()
    private var selectedImagePath: String?

    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let backgroundImageView = UIImageView()

    private let exitButton = UIButton(type: .custom)

    // MARK: - Properties info

    private let privacyLabel = UILabel()
    private let protectActivityLabel = UILabel()

    private var didAddGradient = false

    private let page: Page

    // MARK: - Init

    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        switch page {   
        case .tracker: drawTracker()
        case .welcome: drawWelcome()
        case .firstTraining: drawFirstTraining()
        case .secondTraining: drawSecondTraining()
        case .thirdTraining: drawThirdTraining()
        case .fourthTraining: drawFourthTraining()
        case .choose: drawChoose()
        }
    }

    // MARK: - Draw

    private func drawTracker() {
        backgroundImageView.image = R.image.launch_background()
        backgroundImageView.isUserInteractionEnabled = true
        mainLabel.isHidden = false

        mainLabel.do { make in
            make.text = L.slacklineTracker()
            make.textColor = .white
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textAlignment = .left
            make.numberOfLines = 0
        }        
        
        subLabel.do { make in
            make.text = L.motivatedSubLabel()
            make.textColor = .white
            make.font = .systemFont(ofSize: 20)
            make.textAlignment = .left
            make.numberOfLines = 0
        }

        view.addSubviews(backgroundImageView, subLabel, mainLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(137)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        mainLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subLabel.snp.top).offset(-6)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }

    private func drawWelcome() {
        backgroundImageView.image = R.image.launch_background()
        backgroundImageView.isUserInteractionEnabled = true

        mainLabel.do { make in
            make.text = L.welcome()
            make.textColor = .white
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textAlignment = .center
            make.numberOfLines = 0
        }
        
        subLabel.do { make in
            make.text = L.welcomeSubLabel()
            make.textColor = .white
            make.font = .systemFont(ofSize: 34)
            make.textAlignment = .center
            make.numberOfLines = 0
        }

        view.addSubviews(backgroundImageView, mainLabel, subLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(198)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(88)
            make.leading.trailing.equalToSuperview().inset(18.5)
        }
    }    
    
    private func drawFirstTraining() {
        backgroundImageView.image = R.image.onb_first_training()
        backgroundImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContinueButton))
        backgroundImageView.addGestureRecognizer(tapGestureRecognizer)

        view.addSubviews(backgroundImageView)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }    
    
    private func drawSecondTraining() {
        backgroundImageView.image = R.image.onb_second_training()
        backgroundImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContinueButton))
        backgroundImageView.addGestureRecognizer(tapGestureRecognizer)

        view.addSubviews(backgroundImageView)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func drawThirdTraining() {
        backgroundImageView.image = R.image.onb_third_training()
        backgroundImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContinueButton))
        backgroundImageView.addGestureRecognizer(tapGestureRecognizer)

        view.addSubviews(backgroundImageView)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func drawFourthTraining() {
        backgroundImageView.image = R.image.onb_fourth_training()
        backgroundImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContinueButton))
        backgroundImageView.addGestureRecognizer(tapGestureRecognizer)

        view.addSubviews(backgroundImageView)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func drawChoose() {
        backgroundImageView.image = R.image.launch_background()
        backgroundImageView.isUserInteractionEnabled = true

        mainLabel.do { make in
            make.text = L.chooseLabel()
            make.textColor = .white
            make.font = .systemFont(ofSize: 34, weight: .bold)
            make.textAlignment = .center
            make.numberOfLines = 0
        }
        
        subLabel.do { make in
            make.text = L.chooseSubLabel()
            make.textColor = .white
            make.font = .systemFont(ofSize: 34)
            make.textAlignment = .center
            make.numberOfLines = 0
        }

        view.addSubviews(backgroundImageView, mainLabel, subLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(177)
            make.width.equalTo(230)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(68)
            make.leading.trailing.equalToSuperview().inset(18.5)
        }
    }
    
    @objc private func didTapContinueButton() {
        delegate?.didTapContinue()
    }
}
