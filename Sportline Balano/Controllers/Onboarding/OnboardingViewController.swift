import UIKit

final class OnboardingViewController: UIViewController {
    // MARK: - Life cycle

    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pagesViewControllers = [UIViewController]()
    
    private var currentPage: OnboardingPageViewController.Page = .tracker
    private var trackButtonTapsCount = 0

    private lazy var first = OnboardingPageViewController(page: .tracker)
    private lazy var second = OnboardingPageViewController(page: .welcome)
    private lazy var third = OnboardingPageViewController(page: .firstTraining)
    private lazy var fourth = OnboardingPageViewController(page: .secondTraining)
    private lazy var fifth = OnboardingPageViewController(page: .thirdTraining)
    private lazy var sixth = OnboardingPageViewController(page: .fourthTraining)
    private lazy var seventh = OnboardingPageViewController(page: .choose)
    
    private let continueButton = OnboardingButton()
    private let skipButton = SkipButton()
    
    private var enteredName: String?
    private var selectedGenres: [Int] = []
    private var isTraining: Bool

    init(isTraining: Bool) {
        self.isTraining = isTraining
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pagesViewControllers += [first, second, third, fourth, fifth, sixth, seventh]
        drawSelf()
        
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        sixth.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func drawSelf() {
        view.backgroundColor = .white

        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)

        addChildController(pageViewController, inside: view)
        if let pageFirst = pagesViewControllers.first {
            pageViewController.setViewControllers([pageFirst], direction: .forward, animated: false)
        }
        pageViewController.dataSource = self

        for subview in pageViewController.view.subviews {
            if let subview = subview as? UIScrollView {
                subview.isScrollEnabled = false
                break
            }
        }

        view.addSubviews(continueButton, skipButton)

        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-70)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(45)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11)
            make.trailing.equalToSuperview().inset(21)
            make.width.equalTo(50)
            make.height.equalTo(28)
        }
    }
}

// MARK: - OnboardingPageViewControllerDelegate
extension OnboardingViewController {
    @objc private func didTapContinueButton() {
        switch currentPage {
        case .tracker:
            pageViewController.setViewControllers([second], direction: .forward, animated: true)
            currentPage = .welcome
            continueButton.setTitle(to: L.getStarted())
        case .welcome:
            pageViewController.setViewControllers([third], direction: .forward, animated: true)
            currentPage = .firstTraining
            continueButton.isHidden = true
        case .firstTraining:
            pageViewController.setViewControllers([fourth], direction: .forward, animated: true)
            currentPage = .secondTraining
        case .secondTraining:
            pageViewController.setViewControllers([fifth], direction: .forward, animated: true)
            currentPage = .thirdTraining
        case .thirdTraining:
            pageViewController.setViewControllers([sixth], direction: .forward, animated: true)
            currentPage = .fourthTraining
        case .fourthTraining:
            pageViewController.setViewControllers([seventh], direction: .forward, animated: true)
            currentPage = .choose
            continueButton.isHidden = false
        case .choose:
            if isTraining {
                UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
                AppActions.shared.openWebPage()
            } else {
                UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")

                let tabBarController = TabBarController.shared
                let navigationController = UINavigationController(rootViewController: tabBarController)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        }
    }

    @objc private func didTapSkipButton() {
        if isTraining {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            AppActions.shared.openWebPage()
        } else {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")

            let tabBarController = TabBarController.shared
            let navigationController = UINavigationController(rootViewController: tabBarController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pagesViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        return pagesViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pagesViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        return pagesViewControllers[index + 1]
    }
}

// MARK: - UIViewController
extension UIViewController {
    func addChildController(_ childViewController: UIViewController, inside containerView: UIView?) {
        childViewController.willMove(toParent: self)
        containerView?.addSubview(childViewController.view)

        addChild(childViewController)

        childViewController.didMove(toParent: self)
    }
}

// MARK: - OnboardingPageViewControllerDelegate
extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func didTapContinue() {
        didTapContinueButton()
    }
}
