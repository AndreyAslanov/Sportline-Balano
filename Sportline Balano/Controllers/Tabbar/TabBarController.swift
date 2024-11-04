import UIKit

final class TabBarController: UITabBarController {
    static let shared = TabBarController()

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(
            rootViewController: HomeViewController()
        )
        let trainingVC = UINavigationController(
            rootViewController: TrainingViewController()
        )
        let healthVC = UINavigationController(
            rootViewController: HealthViewController()
        )
        let settingsVC = UINavigationController(
            rootViewController: SettingsViewController()
        )

        homeVC.tabBarItem = UITabBarItem(
            title: L.home(),
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )

        trainingVC.tabBarItem = UITabBarItem(
            title: L.training(),
            image: UIImage(systemName: "figure.surfing"),
            tag: 1
        )

        healthVC.tabBarItem = UITabBarItem(
            title: L.health(),
            image: UIImage(systemName: "heart.fill"),
            tag: 2
        )
        
        settingsVC.tabBarItem = UITabBarItem(
            title: L.settings(),
            image: UIImage(systemName: "gearshape.fill"),
            tag: 3
        )

        let viewControllers = [homeVC, trainingVC, healthVC, settingsVC]
        self.viewControllers = viewControllers

        setTabBarBackground()
        updateTabBar()
    }
    
    func updateTabBar() {
        tabBar.backgroundColor = .white.withAlphaComponent(0.08)
        tabBar.tintColor = UIColor(hex: "#FD5B19")
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.3)
        tabBar.itemPositioning = .automatic
    }
    
    func setTabBarBackground() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tabBar.insertSubview(blurEffectView, at: 0)
    }
}
